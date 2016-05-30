class: center, middle

# Apache

.height_8em[[![Apache](geronimo.jpg)](http://www.greatdreams.com/apache/apache-index.htm)]

### Chris Wilson, AfNOG 2016

Based on a previous talk by Joel Jaeggli with thanks!

You can access this presentation at: http://afnog.github.io/sse/apache/
([edit](https://github.com/afnog/sse/apache/presentation.md))

.smaller.left[
* Online: http://afnog.github.io/sse/apache/
* Local: http://www.ws.afnog.org/afnog2016/sse/apache/index.html
* Github: https://github.com/afnog/sse/blob/master/sse/apache/presentation.md
* Download PDF: http://www.ws.afnog.org/afnog2016/sse/apache/presentation.pdf
]

---

## What is Apache?

* An HTTP server (web server)
* A foundation supporting several web-related software projects

.height_8em[[![Apache projects](apache-projects.png)](http://www.apache.org/index.html#projects-list)]

For clarity it might help to talk about "Apache Server" to mean the HTTPD server.

.height_8em[[![Pronouncing HTTPD](bill.gif)](http://acme.com/software/thttpd/)]

---

## Other HTTP servers

What other HTTP (web) servers are commonly used?

---

## Other HTTP servers

What other HTTP (web) servers are commonly used?

[![Netcraft Survey](wpid-wss-share.png)](http://news.netcraft.com/archives/2015/09/16/september-2015-web-server-survey.html)

???

Note: The "Other" category is 20%! This includes:

* Apache Tomcat
* Lighttpd
* Thttpd

Also note growing popularity of nginx.

---

## Which one to use?

* Apache
  * Popular, well-documented, flexible, secure, big, slow, heavy, PHP integration.
* Nginx
  * Increasingly popular, quite well-documented, very fast, reverse proxy, SSL support/wrapper, no PHP.
* Lighttpd
  * Simple, fast, no PHP.
* Thttpd
  * Tiny, fast, no PHP.

???

Notice how only Apache supports PHP (natively)?

Most web servers need you to install and run a FastCGI server to support PHP, which is more complex.

But it does completely isolate the PHP server process from your web server, preventing it from
bringing down your HTTP server (by overloading or a vulnerability).

---

## Apache Features

* Server Side Programming Language Support
  * Apache supports some common language interfaces which include Perl, Python, Tcl, and PHP. It also supports a variety of popular authentication modules like mod_auth, mod_access, mod_digest and many others.
* IPv6 Support
  * On systems where IPv6 is supported by the underlying Apache Portable Runtime library, Apache gets IPv6 listening sockets by default. 
* Virtual Hosting
  * Apache will allow one installation instance to serve multiple websites. For instance one Apache installation can serve sse.afnog.org, ws.afnog.org etc
* Simplified configuration (!)

More at: http://httpd.apache.org/docs/2.2/new_features_2_0.html 

---

## Virtual Hosting

What does it mean?

Apache support virtual hosting (deciding which website to display) using:

* Name based virtual hosts (`Host` header)
* IP/Port based virtual hosts
* Aliases (subdirectories)

???

**IP/Port based** virtual hosting looks at the IP and port that received the request to identify which
website to serve.

**Name based** virtual hosting is recommended for modern systems to conserve IP addresses. The server looks
at the IP and port **and also the Host: header of the request** to identify which website to serve. 

Every IP and port with `NameVirtualHost` enabled has a default site that is shown if the Host: header
does not match any site configured on the IP and port. This is useful for:

* showing a default page if the DNS has been changed to point a new domain to the web server,
  but the web server not yet configured for it;

* when you do not know which domain name the client is going to use, e.g. when intercepting 
  web requests (captive portal)

---

## PHP and MySQL

* Many web applications written in PHP and using a MySQL database.
* Relatively easy to deploy under Apache (and most web hosting).
* We will install the necessary software shortly.

---

## Apache and SSL

* SSL is the "Secure Socket Layer"
  * Used to secure several protocols including HTTP
  * When used properly, protects the wrapped protocol from 
  * Usually the wrapped protocol has little or no interaction with SSL layer (transparent)
  * This causes problems with virtual hosting!
* HTTPS (HTTP over SSL) runs on port 443 by convention
  * Each SSL-wrapped service runs on a different port than its non-SSL-wrapped version

---

## SSL Certificates

* Certificates identify parties (servers and sometimes clients)
  * SSL useless without server auth - why not?
* Need to generate a Certificate Signing Request (CSR) and get someone to sign it
  * Chain of trust, established by signatures
  * Signer needs to be trusted by web browser (directly or indirectly)
* Each SSL certificate* has a Public and Private key
  * The public key is used to encrypt the information
  * The public key is accessible to everyone
  * The private Key is used to decipher the information
  * The private should be not be disclosed to anyone

.footnote[.red.bold[*] The key is included on the certificate, but can be
reused on more certificates as long as not compromised. There is no way to
revoke it except to revoke all certs signed with it.]

---

## How SSL works

.fill[![How SSL works](how-ssl-works.svg)]

???

* Server gets a certificate:
  * Generates a public-private key pair
  * Generates a Certificate Signing Request (CSR) containing a hash of the public key
  * Sends CSR and money to a Certificate Authority (CA)
  * CA generates a certificate, including its own public key, signed with the corresponding private key, and returns to server
  * All of this happens ~1 time per certificate lifetime (1-5 years)
* Client connects to server via SSL
  * Sends a nonce (number used once) to server
  * Server signs nonce and returns it with the certificate (**which one?**) to client
* Client checks that:
  * It trusts the CA - possibly via a chain from a trusted CA
  * The cert lists the domain that it tried to connect to (**aha!**)
  * The cert has the correct purpose (authentication)
  * The cert has not been revoked (against a list downloaded by OCSP)
  * The nonce was signed by the key listed in the certificate
* All of this proves that:
  * The server has a key
  * which was given a certificate
  * which is valid for the purpose
  * and was signed (directly or indirectly) by a CA that the client trusts
  * and has not been revoked
  * therefore they can trust the server

Note: no protection against key theft except certificate revocation!

Also, invalidating a certificate invalidates all those signed by it.

---

## Certificate Authorities

Who are these guys anyway?

* Geotrust, Go Daddy, RSA, Thawte, Verisign, many others...
* Trusted by browsers
* Verify your identity (not really any more)
* Take your money
* Try not to lose their private keys
  * What would happen if they did?

---

## Self-signed certificates

* Useful for testing
* Useful in controlled environments
* Free (as in beer, but take time and skill to manage)
* Useless for clients who won't install the cert

---

## Getting Certificates

So how do I get one again?

* Pay money
* Self-certified (own CA)
* Self-signed

We will show you how to setup your own CA and create valid certs signed by it.






Requires the creation of SSL certificates and Certificate Signing Requests (CSR)
For integrity, SSL certificates are signed by a Certificate Authority’s (CA) such as Verisign
Self signed Certificates will also work but your browser will not trust it and will give a warning to users (which most don’t read)
Refer to the Creating SSL Certificate Exercise Section


* Many web applications written in PHP and using a MySQL database.
* Relatively easy to deploy under Apache (and most web hosting).
* We will install the necessary software shortly.


---

## Stateful Firewalls

.fill[[![TCP states](Tcp_state_diagram_fixed.svg)](http://commons.wikimedia.org/wiki/File:Tcp_state_diagram_fixed.svg)]

???

* "Stateful inspection" tracks the state or progress of a network connection.
* These are the states of a TCP connection.
* Most useful for allowing return packets for an open connection.
* Can prevent sneaking in packets after connection closed.
* What about ICMP and UDP? They are not inherently stateful protocols.
* Almost essential for NAT - tracks the internal address corresponding to a connection.
* Performance impact - scanning the connection table vs partially/not evaluating the ruleset

---

## Limitations of Firewalls

.fill[[![Snakes on a Plane](snake_plane_2719321b.jpg)](http://i.telegraph.co.uk/multimedia/archive/02719/snake_plane_2719321b.jpg)]

???

* Usually only block *inbound* traffic - what about outbound?
* How to protect against inside attacks? (more firewalls!)
* Limited ability to understand application protocols (need other defenses e.g. Application Layer Gateways)
* Performance impact - minimal (especially compared to ALGs)
* Blocking legitimate traffic
* Some traffic very hard to block (skype, encrypted bittorrent, particular websites)

---

## Blocking Websites

.fill[[![Great Firewall of China](China.png)](http://www.apc.org/en/node/14821)]

???

* How do you do it?
* How do you know what sites people are accessing?
* Can you do it at the packet level? DNS? HTTP Host header?
* Bypassing - alternative DNS servers, HTTPS
* Turkey blocking Twitter example
* How does China do it? Secret, massive manpower, intimidation.

---

## Typical features

* Rulesets (lists of rules, read in order)
* Rules (IF this THEN that)
* Match conditions
  * interface, IP address, protocol, port, time, contents
* Actions
  * accept, drop, reject, jump to another table, return
* Default policy

---

## iptables/netfilter

.fill[[![Netfilter diagram](iptables.png)](http://www.adminsehow.com/2011/09/iptables-packet-traverse-map/)]

???

* `iptables` is the command-line tool to manage the Netfilter firewall
* connection tracking
* multiple "tables":
  * filter (packet filtering)
  * NAT
  * mangle
* hooks at different points in the packet path:
  * INPUT, FORWARD, OUTPUT, PREROUTING, POSTROUTING
* many matches and targets

---

## Listing current rules

We use the `iptables` command to interact with the firewall (in the kernel):

	$ sudo apt install iptables
	$ sudo iptables -L -nv

	Chain INPUT (policy ACCEPT 119 packets, 30860 bytes)
	 pkts bytes target     prot opt in     out     source       destination         

	Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
	 pkts bytes target     prot opt in     out     source       destination         

	Chain OUTPUT (policy ACCEPT 36 packets, 1980 bytes)
	 pkts bytes target     prot opt in     out     source       destination         

???

This command is to:

* `L`ist all the rules,
* in the `filter` table (default),
* not resolving `n`umeric addresses,

This shows 3 chains (INPUT, FORWARD and OUTPUT) with no rules in any of them.

---

## Your first ruleset

Configure your firewall to allow ICMP packets.

	$ sudo iptables -A INPUT -p icmp -j ACCEPT

	$ sudo iptables -L INPUT -nv

	Chain INPUT (policy ACCEPT 4 packets, 520 bytes)
	 pkts bytes target     prot opt in     out     source       destination         
	    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0    0.0.0.0/0           

What effect will this have?

What are the numbers?

???

It will **-A**ppend a rule to the `INPUT` chain, which will match incoming packets.
It will have no effect for now, because the policy is also ACCEPT. However you will see
*icmp* packets accounted against the rule, instead of the chain.

The first two numbers show that 0 packets (totalling 0 bytes) have matched this rule
(since it was created or the packet counters were last reset).

---

## Testing rules

How can you test it?

	$ ping -c4 127.0.0.1
	PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
	64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.058 ms
	...

	$ sudo iptables -L INPUT -nv
	Chain INPUT (policy ACCEPT 220 packets, 218K bytes)
	 pkts bytes target     prot opt in     out     source       destination         
	    8   672 ACCEPT     icmp --  *      *       0.0.0.0/0    0.0.0.0/0           

Why do we see 8 packets against the rule, instead of 4?

You can use `iptables -L INPUT -nZ` to `Z`ero the counters.

???

* The *ping* command uses ICMP packets of the `echo-request` and `echo-response` types.
* Every ping has a request and a response packet.
* Both are received by the same machine because it's local.
* Try working with your neighbour: each test the other's firewall.

---

## Blocking pings

Add another rule:

	$ sudo iptables -A INPUT -p icmp -j DROP

	$ sudo iptables -L INPUT -nv
	Chain INPUT (policy ACCEPT 12 packets, 1560 bytes)
	 pkts bytes target     prot opt in     out     source       destination         
	    8   672 ACCEPT     icmp --  *      *       0.0.0.0/0    0.0.0.0/0           
	    0     0 DROP       icmp --  *      *       0.0.0.0/0    0.0.0.0/0           

	$ ping -c1 127.0.0.1
	64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.067 ms

Is that what you expected?

???

Some people would have expected that pings would be dropped.

* Hint: look at the number of packets matching the DROP rule
* Why did no packets match? The ACCEPT rule came first!

---

## Rule precedence

Insert a DROP rule **before** the ACCEPT rule with `-I`:

	$ sudo iptables -I INPUT -p icmp -j DROP

	$ sudo iptables -L INPUT -nv
	Chain INPUT (policy ACCEPT 12 packets, 1560 bytes)
	 pkts bytes target     prot opt in     out     source       destination         
	    0     0 DROP       icmp --  *      *       0.0.0.0/0    0.0.0.0/0           
	   10   840 ACCEPT     icmp --  *      *       0.0.0.0/0    0.0.0.0/0           
	    0     0 DROP       icmp --  *      *       0.0.0.0/0    0.0.0.0/0           

---

## Rule precedence testing

	$ ping -c1 127.0.0.1
	PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
	^C
	--- 127.0.0.1 ping statistics ---
	1 packets transmitted, 0 received, 100% packet loss, time 0ms

???

What can we do to tidy up?

---

## List rules with indexes

Use the iptables `-L --line-numbers` options:

	$ sudo iptables -L INPUT -nv --line-numbers
	Chain INPUT (policy ACCEPT 15 packets, 1315 bytes)
	num   pkts bytes target   prot opt in    out   source       destination         
	1        0     0 DROP     icmp --  *     *     0.0.0.0/0    0.0.0.0/0           
	2        0     0 ACCEPT   icmp --  *     *     0.0.0.0/0    0.0.0.0/0           
	3        0     0 DROP     icmp --  *     *     0.0.0.0/0    0.0.0.0/0

---

## Deleting Rules

Delete rule by index:

	$ sudo iptables -D INPUT 3

Delete rule by target:

	$ sudo iptables -D INPUT -p icmp -j ACCEPT

Check the results:

	$ sudo iptables -L INPUT -nv --line-numbers
	Chain INPUT (policy ACCEPT 9 packets, 835 bytes)
	num   pkts bytes target     prot opt in     out     source               destination         
	1        0     0 DROP       icmp --  *      *       0.0.0.0/0            0.0.0.0/0           

---

## Simple rule set

This is one of the first things I set up on any new box:

	iptables -P INPUT ACCEPT
	iptables -F INPUT
	iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT
	iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix 'Rejected INPUT '

Check that I can access the server without triggering a "Rejected INPUT" message in the logs, and then
lock it down:

	iptables -P INPUT DROP

---

## Persistent Rules

What happens when you reboot?

---

## Persistent Rules

What happens when you reboot?

The rules that we created are only in the kernel's memory. They will be lost on reboot.

How can we make them permanent? Could be as simple as:

	/sbin/iptables-save > /etc/default/iptables
	/sbin/iptables-restore < /etc/default/iptables

Or install `iptables-persistent` which automates this a little.

---

## Connection Tracking

Every packet is tracked by default (made into a connection).

You can see them with `conntrack -L`:

	sudo /usr/sbin/conntrack -L
	tcp      6 431999 ESTABLISHED src=196.200.216.99 dst=196.200.219.140 sport=58516 dport=22
	src=196.200.219.140 dst=196.200.216.99 sport=22 dport=58516 [ASSURED] mark=0 use=1

What does this mean?

---

## Connection Tracking

	sudo /usr/sbin/conntrack -L
	tcp      6 431999 ESTABLISHED src=196.200.216.99 dst=196.200.219.140 sport=58516 dport=22
	src=196.200.219.140 dst=196.200.216.99 sport=22 dport=58516 [ASSURED] mark=0 use=1

* ESTABLISHED is the connection state
  * What are valid states?
* src=196.200.216.99 is the source address of the tracked connection
* dst=196.200.219.140 is the destination address
  * Which one is the address of this host? Will it always be?
* sport=58516: source port
* dport=22: destination port
* Another set of addresses: what is this?

---

## Connection Tracking

How do we use it?

* `iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT`
  * You normally want this!

Can you see any problems?

---

## Connection Tracking Problems

What happens if someone hits your server with this?

	sudo hping3 --faster --rand-source -p 22 196.200.219.140 --syn

Or if you run a server that has thousands of clients?

---

## Connection Tracking Problems

Add a rule to block all connection tracking to a particular port:

	sudo /sbin/iptables -t raw -A PREROUTING -p tcp --dport 22 -j NOTRACK

Write your rules so that connection tracking is **not needed** (allow traffic both ways).

You probably want to do this for your DNS server. How?

---

## Connection Tracking Problems

Add a rule to block all connection tracking to a particular port:

	sudo /sbin/iptables -t raw -A PREROUTING -p tcp --dport 22 -j NOTRACK

Write your rules so that connection tracking is **not needed** (allow traffic both ways).

You probably want to do this for your DNS server. How?

	sudo /sbin/iptables -t raw -A PREROUTING -p udp --dport 53 -j NOTRACK

---

## FIN

Any questions?

(yeah, right!)
