class: center, middle, title

# LDAP Directory Services

## How to run an LDAP server and domain

.height_8em[[![Tree in Mist](https://farm8.staticflickr.com/7095/7230738190_3c6f7146e6_b.jpg)](https://www.flickr.com/photos/matthewpaulson/7230738190)]

### Chris Wilson, [Aptivate](http://www.aptivate.org/), AfNOG 2014

---

## Credits

Based on presentations by:

* [FreeIPA Guide](http://docs.fedoraproject.org/en-US/Fedora/15/html/FreeIPA_Guide/index.html)
* [Seth Lyons](https://forums.freebsd.org/viewtopic.php?f=39&t=46526)

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

* What is an LDAP directory
* How to use an LDAP directory
* What is FreeIPA
* Practical exercises

---

## What is FreeIPA?

* Domain controller for Linux and Unix machines.
* Used on controlling servers and enrolled client machines.
* Provides centralized structure for Linux/Unix environments.
* Centralizes identity management and identity policies.
* Uses native Linux (Unix) applications and protocols.

---
layout: true
## Control Levels
---

### Low Control environment

* Central user, password, and policy stores.
* IT staff maintain the identities on one machine (the FreeIPA server).
* Users and policies are uniformly applied to all machines.
* Set different access levels for laptops and remote users.

---

### Medium Control environment

* Replaces traditional fragmented management tools:
  * NIS domain for machines;
  * LDAP directory for users;
  * Kerberos for authentication.
* Reduces administrative overhead by integrating these services seamlessly.
* Provides a single and simplified tool set.

---

### Absent Control environment

* Integrate Linux/Unix systems into Windows Active Directory forest.

---
layout: false
## Comparison with plain LDAP

* 389 Directory Server:
  * A generic directory service.
  * Can store and retrieve any kind of information.
  * Frequently used as database backends for other applications.
  * Organises entries into a hierarchical *directory tree*.
  * Trees can be very simple, or very complex, with many branch points.
* FreeIPA:
  * Very specific purpose and application.
  * It is not a general LDAP directory, backend or policy server.
  * It is not generic!

---

## What's in the Box?

[.height_8em[[FreeIPA Services](images/ipa-server.png)]](http://docs.fedoraproject.org/en-US/Fedora/15/html/FreeIPA_Guide/ipa-linux-services.html)

* Primary FreeIPA server = domain controller
  * Kerberos server and KDC for authentication.
  * LDAP backend contains all of the domain information:
    * users, client machines, and domain configuration.
* Other services included for support:
  * DNS for machine discovery and finding to other domain members.
  * NTP to synchronize all domain clocks for logging and certificates.
  * Certificate service provides certificates for Kerberos-aware services.
* Unified tools to manage these services (CLI and web)

---

## Practicals

---
layout: true
## Installing FreeIPA
---

### Before you Start

Choose a `domain_name` for your domain.
* For example, `myname.afnog.guru`

Decide which host will be your master IPA server.
* For example, `pcXX.sse.ws.afnog.org`

---

### Install the Packages

```sh
sudo pkg install sssd
```

---

### Enable the Service

Edit `/etc/rc.conf` (using sudo) and add the line:

```sh
sssd_enable="YES"
```

Edit `/etc/nsswitch.conf` (using sudo) and change the `group` and `passwd` lines to match these:

```sh
group: files sss
passwd: files sss
```

---

### Configure the Service (1)

Create the file `/usr/local/etc/sssd/sssd.conf` (using sudo):

```
[domain/<domain_name>]
cache_credentials = True
krb5_store_password_if_offline = True
ipa_domain = <domain_name>
id_provider = ipa
auth_provider = ipa
access_provider = ipa
ipa_hostname = pcXX.sse.ws.afnog.org
chpass_provider = ipa
ipa_server = _srv_ # use DNS SRV
```

---

### Configure the Service (2)

Continue adding to `/usr/local/etc/sssd/sssd.conf`:

```
ldap_tls_cacert = <ldap tls CA cert location>
enumerate = True #to enumerate users and groups

[sssd]
enumerate = True
services = nss, pam, sudo
config_file_version = 2
domains = <domain_name>

[nss]

[pam]

[sudo]
```

/usr/local/etc/sssd/sssd.conf


Copy the sample configuration for `sssd`:

```sh
sudo cp /usr/local/etc/sssd/sssd.conf{.sample,}
```

---

### Enable PAM Integration

Edit `/etc/pam.d/system` (using sudo), find the line that says:

```sh
auth            required        pam_unix.so
```

And add the following line before it:

```sh
auth            sufficient      /usr/local/lib/pam_sss.so
```

---
layout: false

## FIN

Any questions?
