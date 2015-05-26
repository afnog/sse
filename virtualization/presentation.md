class: center, middle

# Virtualization with OpenStack

.height_8em[[![Virtualization](vmw-virtualization-defined.jpg)](http://www.vmware.com/virtualization/virtualization-basics/how-virtualization-works)]

### Chris Wilson, AfNOG 2015

You can access this presentation at: http://afnog.github.io/sse/virtualization/
([edit](https://github.com/afnog/sse/firewalls/virtualization.md))

---

## Why?

???

* Enables rapid deployments of new virtual machines
* Build rendundant, fault-tolerant, scalable systems
* We will use Juju to deploy and manage VMs on our OpenStack hosts later
* Juju supports several commercial providers (e.g. EC2), OpenStack and MAAS (bare metal)

---

## How?

.height_8em[[![OpenStack Havana Architecture](openstack_havana_conceptual_arch.png)](http://docs.openstack.org/kilo/install-guide/install/apt/content/ch_overview.html)]

* Create 3 virtual machines
* Install Ubuntu and OpenStack "Kilo" components
* Roughly following the instructions at:
http://docs.openstack.org/kilo/install-guide/install/apt/content/index.html

---



* Basic firewalls are packet filters
* Can't always make a decision based on one packet (examples?)
* Stateful firewalls (connection table)
* Application layer (L7) filtering/inspection/IDS
* Redundant firewalls with synchronisation
* VPNs and SSL "VPNs"

???

Decisions that can't be made based on one packet:

* Downloading a forbidden file type
* Downloading a virus
* Sending emails with a virus
* Established connections/Reply packets (information smuggling)
* P2P traffic (bittorrent, skype, etc)

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

???

No effect for now, because the policy is also ACCEPT. However you will see
*icmp* packets accounted against the rule, instead of the chain.

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
* Why did no packets match? the ACCEPT rule came first

---

## Rule precedence

Add a DROP rule **before** the ACCEPT rule:

	$ sudo iptables -I INPUT -p icmp -j DROP

	$ sudo iptables -L INPUT -nv
	Chain INPUT (policy ACCEPT 12 packets, 1560 bytes)
	 pkts bytes target     prot opt in     out     source       destination         
	    0     0 DROP       icmp --  *      *       0.0.0.0/0    0.0.0.0/0           
	   10   840 ACCEPT     icmp --  *      *       0.0.0.0/0    0.0.0.0/0           
	    0     0 DROP       icmp --  *      *       0.0.0.0/0    0.0.0.0/0           

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


* Theory followed by practical exercises
* Help us to help you!
* Complaints box
* Please set phones to silent
* Please close your laptops during theory sessions

???

Please tell us if you don't understand. You're not the only one.

Please don't distract others - tell us if you're bored!

Suggestion: if someone's phone rings, they have to do a dance for us :)

---

## Timetable

* 06:30-08:00: Breakfast at the hotel (Kempinski)
* 07:45, 08:00, 08:15 and 08:30: Buses to the venue (Palace du Peuple)
* 09:00: Workshops start
* 11:00: tea break
* 14:00-15:00: lunch at the venue (Palace du Peuple)
* 16:30: tea break
* 18:30: dinner at the venue (Palace du Peuple)
* 19:30, 19:45, 20:00 and 20:15: buses to hotel (Kempinski)

Updates on the [NSRC wiki](https://nsrc.org/workshops/2014/afnog/wiki/Timetable).

---

## Meals

* Breakfast at the hotel (Kempinski): 06:30-08:00
* Lunch at the Palace du Peuple: 14:00-15:00
* Dinner at the Palace du Peuple: 18:30-20:30

Please be back in class on time from breaks!

---

## Extra Charges

AfNOG will not pay for any extra charges on your hotel room, such as:

* phone calls
* food and drinks (including room service)
* laundry

Beware the hotel prices!

---

## Inventory

You should have received:

* Name badges
* Folder with notepad, pen, information pack

Take your name badge to meals at the Palace du Peuple!

---

## Gifts

At the end you will receive:

* A USB stick with some O'Reilly eBooks
* Possibly a FreeBSD CD-ROM

Please share with your colleagues back at home.

## Community

What did Sunday said about community?

???

* Who will you share your knowledge with?
* How can you continue to learn and improve your skills after the event?

Build a local community, be active, organise an event and invite people!

Make a plan, share the work, think about what you have to give and what you
can gain by sharing. Who is married here? Why did you get married? Is it
worth it?

---

## Electronic Resources

Web site: http://www.ws.afnog.org/afnog2014/

AfNOG Mailing List:

* Q&A on Internet operational and technical issues.
* No foul language or disrespect for other participants.
* No blatant product marketing.
* No political postings.

Please [subscribe](http://www.afnog.org/mailman/listinfo/afnog/) while at
the Workshop:

* So we can help you if you have problems subscribing.
* Please raise any questions related to the workshop content.

---

## Safety

Please be careful in class:

* trip on power cords
* pull cables out of sockets
* knock equipment off tables
* fall from leaning back too far in your chair

---

## Learning Environment

* 34 virtual servers (named pc1 – pc34)
  * DNS names are pc1.sse.ws.afnog.org (etc)
* Use your own laptops for:
  * Web browsing
  * Control your virtual machines
  * Virtualisation exercises
* Wireless Internet
  * Use the AIS network if possible, otherwise AIS-bgn
  * Password for both is "`success!`"

---

## Servers

* FreeBSD-10.0 OS installed
* sudo and bash installed, ports tree updated
* Use SSH to access your server (e.g. Putty for Windows)
* Login with afnog/afnog
* Use sudo to execute commands as root
* Don't change passwords
* Don't "close security holes"
* Don't `shutdown` your server (there's no power button!)
* Your servers are accessible over the Internet

---

## FIN

Any questions?
