class: center, middle, title

# LDAP and Kerberos

## How to run an LDAP server and Kerberos domain

.height_8em[[![Tree in Mist](https://farm8.staticflickr.com/7095/7230738190_3c6f7146e6_b.jpg)](https://www.flickr.com/photos/matthewpaulson/7230738190)]

### Chris Wilson, [Aptivate](http://www.aptivate.org/), AfNOG 2014

---

## Credits

Based on presentations by:

* [Brian Candler and NSRC](https://nsrc.org/workshops/2011/sanog17/wiki/Agenda) (SANOG 17)

You can access this presentation at: http://afnog.github.io/sse/ldap/presentation
([edit](https://github.com/afnog/sse/ldap/presentation.md))

---

## Conventions

Commands to enter are shown like this:

```sh
openssl smime -encrypt -binary -aes-256-cbc -in message3.txt -out message3.txt.enc yourpartner.crt.pem
openssl smime -decrypt -binary -in encrypted.zip.enc -out decrypted.zip -inkey private.key -passin pass:your_password
```

Please note:

* Long command lines are wrapped for readability.
* Each &#9656; triangle marks the start of a single command.

---

## What we can talk about

* What is LDAP
* What is Kerberos
* Creating a Kerberos domain (KDC)
* Add clients to Kerberos domain
* Share user information using LDAP

---

## What is LDAP

* A generic directory service.
* Can store and retrieve any kind of information.
* Frequently used as database backends for other applications.
* Organises entries into a hierarchical *directory tree*.
* Trees can be very simple, or very complex, with many branch points.

---

## What is Kerberos

---

## Practicals

---
layout: true
## Build a KDC
---

### Before you Start

Choose a realm name:
* For example, `myname.afnog.guru`

---

```sh
sudo pkg install krb5
```

---

class: small

### Configure Local Kerberos

Edit `/etc/krb5.conf` (using sudo) and add these lines:

```
[libdefaults]
default_realm = <your_realm>
dns_lookup_realm = true
dns_lookup_kdc = true

[realms]
<your_realm> = {
        kdc = pcXX.sse.ws.afnog.org
        admin_server = pcXX.sse.ws.afnog.org
}

[domain_realm]
pcXX.sse.ws.afnog.org = <your_realm>
```

---

### Create the Kerberos database

Run this command to create the database:

```sh
sudo kdb5_util create -r <your_realm> -s
```

* This can pause for several minutes.
* Eventually you will be asked to choose a database master password.
* Use `afnog` as the password for this exercise.
* Normally you'd choose something much stronger.
* Record this password and keep it very safe!

---

### Grant rights to admins

Create the KDC directory:

```sh
sudo mkdir /etc/krb5kdc
```

Create the ACL file and grant admin rights to all */admin principals.

* Edit `/etc/krb5kdc/kadm5.acl` (using sudo) and add the following line:

```
*/admin@<your_realm> *
```

---

### Create some principals (users)

Kerberos calls its users *principals*.

Use `kadmin.local` (running as root) to create the first few principals:

* a host principal for the host itself;
* a regular principal `student`;
* a KDC admin principal `student/admin`.

The host principal will have a key generated and stored in a file.

The users (regular principals) have passwords instead of keys.

---

### Create the Heimdal database

Start the 

---

### Create some principals (users)

Start a `kadmin` interactive session (shell):

```sh
sudo kadmin.local
```

Enter the following commands into it:

```
addprinc -randkey host/pcXX.sse.ws.afnog.org
ktadd host/pcXX.sse.ws.afnog.org
addprinc student
addprinc student/admin
```

Press Ctrl+D to end the session.

---

### Start your Engines

Edit `/etc/rc.conf` (with sudo) and add the following lines:

```sh
kerberos5_server_enable=YES
kadmind5_server_enable=YES
```

Start the Kerberos daemons:

```sh
sudo /etc/rc.d/kerberos start
sudo /etc/rc.d/kadmind start
```

---

## Install OpenLDAP

### Before you start

* Decide the root of your tree, usually based on your domain:
  * For example, `pcXX.sse.ws.afnog.org`
* Reverse it, add `DC=` to each component, and separate with commas:
  * For example, `DC=org,DC=afnog,DC=ws,DC=sse,DC=pcXX`

```sh
sudo pkg install openldap-server
```

Edit `/etc/rc.conf` and add the following lines:

```
slapd_enable="YES"
slapd_flags='-h "ldapi://%2fvar%2frun%2fopenldap%2fldapi/ ldap://0.0.0.0/"'
slapd_sockets="/var/run/openldap/ldapi"
```

Start the server:

```sh
sudo /usr/local/etc/rc.d/slapd start
```

Edit `/usr/local/etc/openldap/slapd.conf`:

* Find the `rootdn` line and change value to your manager DN

and `password`

---
layout: false

## FIN

Any questions?
