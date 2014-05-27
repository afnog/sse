---
jekyll: process
---

# AfNOG 2014 Workshop on Network Technology

## Track SS-E: Scalable Internet Services

Jump within this page:

* [Introduction](#introduction)
* [Instructors](#instructors)
* [Timetable](#timetable)
* [Topics](#topics)
* [Management](#management)


<p><a href="photos/Class_Group_Photo.jpg" class="group-photo"><img
      src="photos/Class_Group_Photo_600.jpg"
      alt="[SS-E Group Photo]"></a></p>

## Introduction

This course on Scalable Internet Services is part of the [AfNOG 2014 Workshop on Network Technology](http://www.ws.afnog.org/afnog2014), held in conjunction with the [AfNOG meeting](http://www.afnog.org/)
in Djibouti, May-June 2014.</p>

We use hands-on training in a well-equipped classroom over a five-day period to teach skills required for the configuration and operation of large scale Internet services.

### Who should attend

Technical staff who are now providing Internet Services, or those who will be involved in the establishment and/or provisioning of a basic national Internet Services in the country.

### Prerequisites

Experience using and administering *NIX Servers, Name Servers, Web Servers and Mail Servers.

### Instructors

<!-- sorted by surname -->

<table class="instructors">
	<thead><tr><th>Name</th><th>Initials</th><th>From</th></tr></thead>
	<tbody>
		<tr id="JA"> <td>Joe Abley</td>      <td>JA</td> <td>Canada</td> </tr>
		<tr id="KC"> <td>Kevin Chege</td>    <td>KC</td> <td>Kenya</td> </tr>
		<tr id="LM"> <td>Laban Mwangi</td> <td>LM</td> <td>Kenya</td> </tr>
		<tr id="EN"> <td>Evelyn Namara</td>  <td>EN</td> <td>Uganda</td> </tr>
		<tr id="CW"> <td>Chris Wilson</td>   <td>CW</td> <td>UK</td> </tr>
	</tbody>
</table>

### Participants

<!-- sorted by surname -->

<table class="participants">
	<thead><tr><th>Name</th><th>Country</th></tr></thead>
	<tbody>
		<tr><td>Frank Kwetei Quaynor</td><td>Ghana</td></tr>
	</tbody>
</table>

### Timetable

<table class="timetable" width="80%">
	<colgroup>
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</colgroup>
	<thead>
		<tr>
			<th></th>
			<th>Monday</th>
			<th>Tuesday</th>
			<th>Wednesday</th>
			<th>Thursday</th>
			<th>Friday</th>
		</tr>
		<tr>
			<td></td>
			<td>26/05</td>
			<td>27/05</td>
			<td>28/05</td>
			<td>29/05</td>
			<td>30/05</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="time">
				09:00-11:00
			</td>
			<td class="mon">
				<a href="#introduction">SSE Intro/ee bootcamp</a>
			</td>
			<td class="tue">
				<a href="#dns">DNS</a>
			</td>
			<td class="wed">
				<a href="#dns">DNS</a>
			</td>
			<td class="thu">
				<a href="#dns">DNS</a>
			</td>
			<td class="fri">
				<a href="#dns">DNS</a>
			</td>
		</tr>
		<tr class="break">
			<td></td>
			<td colspan="5">Tea Break</td>
		</tr>
		<tr>
			<td class="time">
				11:30-13:00
			</td>
			<td class="mon">
				<a href="#apache">Apache</a>
			</td>
			<td class="tue">
				<a href="#loadbalancing">Load Balancing</a>
			</td>
			<td class="wed">
				<a href="#radius">RADIUS</a>
			</td>
			<td class="thu">
				<a href="#postfix">Postfix</a>
			</td>
			<td class="fri">
				<a href="#monitoring-and-logging">Monitoring and Logging</a>
			</td>
		</tr>
		<tr class="break">
			<td></td>
			<td colspan="5">Lunch</td>
		</tr>
		<tr>
			<td class="time">
				14:00-16:00
			</td>
			<td class="mon">
				<a href="#security">Nagios</a>
			</td>
			<td class="tue">
				<a href="#cryptography">Cryptography</a>
			</td>
			<td class="wed">
				<a href="#firewalls">Firewalls</a>
			</td>
			<td class="thu">
				<a href="#configuration-management">Configuration Management</a>
			</td>
			<td class="fri">
				<a href="#ip-exploration">IP Exploration</a>
			</td>
		</tr>
		<tr class="break">
			<td></td>
			<td colspan="5">Tea Break</td>
		</tr>
		<tr>
			<td class="time">
				16:30-18:30
			</td>
			<td class="mon">
				<a href="#apache">Apache</a>
			</td>
			<td class="tue">
				<a href="#virtualization">Virtualization</a>
			</td>
			<td class="wed">
				<a href="#ldap">LDAP</a>
			</td>
			<td class="thu">
				<a href="#imap-imaps">IMAP/IMAPS</a>
			</td>
			<td class="fri">
				<a href="#security-and-availability">Security and Availability</a><br />
				<a href="#closingsurvey">Closing Survey</a>
			</td>
		</tr>
		<tr class="break">
			<td>18:30-20:30</td>
			<td colspan="5">Dinner</td>
		</tr>
		<tr>
			<td class="time">
				Evening Sessions (20:00-22:00)
			</td>
			<td colspan="3">Closed</td>
			<td class="thu">Closed</td>
			<td class="fri">Closed</td>
		</tr>
	</tbody>
</table>

## Topics

### Introduction
#### [Chris Wilson](#CW)
###### [Presentation](http://afnog.github.io/sse/intro/presentation)
###### [Opening Survey](https://www.surveymonkey.com/s/7Q88MH7)
###### [Survey Results](http://afnog.github.io/sse/intro/opening-survey-results.pdf)

### Apache
#### [Evelyn Namara](#EN)
###### Apache Presentation/PowerPoint
###### [Exercise1 - Apache Installation/SSL](http://afnog.github.io/sse/apache/apache_sse_exercises_apache+ssl.txt)
###### [Exercise2 - MySQL/PHP/Wordpress Install](http://afnog.github.io/sse/apache/apache_sse_exercises_Mysql & PHP configs.txt)
###### [Exercise3 - Wordpress Configuration](http://afnog.github.io/sse/apache/apache_sse_exercises_wordpress.txt)

+ Installing Apache22 from FreeBSD ports
+ Configure Apache with basic configuration 
+ Start Apache http daemon and connect to local box
+ Verify local ssl certificate works 
+ Configuring Apache with SSL 
+ Example SSL Apache configuration file 
+ Sample config for Virtual Hosting
+ Install MySQL, PHP, Wordpress	
+ Configuring Wordpress

### Cryptography
#### [Chris Wilson](#CW)
###### Presentation [HTML](http://afnog.github.io/sse/crypto/presentation)/[PDF](http://afnog.github.io/sse/crypto/presentation.pdf)

### DNS
#### [Joe Abley](#JA)
##### Fundamentals
###### [PowerPoint](dns/dns1-presentation.ppt)
###### [PDF](dns/dns1-presentation.pdf)
###### [Exercise](dns/dns1-exercise.txt)

Goal: to understand overall purpose and structure of DNS

+ IP addresses vs. names
+ DNS as a distributed, hierarchical database
+ Domain names and resource records:
  - A, PTR, MX, CNAME, TXT, SOA/NS
+ Domain name lookup responses
+ Reverse DNS
+ DNS as client-server model
  - Resolver
  - Cache
  - Authoritative server
+ Testing DNS (dig)
+ Understanding output from dig 
+ Practical Exercises:
  - Configure Unix resolver
  - Use dig { A, other (e.g. MX), non-existent answer, reverse lookup }
  - Use tcpdump to show queries being sent to cache

##### DNS Caching and Debugging
###### [PowerPoint](dns/dns2-presentation.ppt)
###### [PDF](dns/dns2-presentation.pdf)
###### [Exercise 1](dns/dns2-exercise1.txt)
###### [Exercise 2](dns/dns2-exercise2.txt)
###### [Exercise 3](dns/dns2-exercise3.txt)

Goal: to understand operation of a recursive nameserver

+ Recap of previous session
+ DNS as a distributed database.
+ Resource record NS: referral of answer
+ Caching nameserver and root servers
+ Caching used to reduce load (esp. top level servers)
+ Issue of stale data in caches (problems with distributed systems).
  - TTL records on each record
  - Negative TTL in SOA
+ Recursion and caching (dig +norec)
+ Demo: www.ticscali.co.uk
+ Practical Exercise:
  - Debugging DNS Worksheet (with dig +norec ):
    . Students work on their own examples
+ Configuring a caching n Load Balancingameserver 
  - check /var/named/etc/namedb/named.conf
  - run tcpdump
  - rndc start
  - change /etc/resolv.conf to point to your nameserver
  - query two times - { Look at 'aa' flag, TTL, query time }
  - rndc flush
  - cache is authoritative for 127.0.0.1
+ What sort of hardware would you choosing when building a DNS cache?		
+ Improving the configuration of a cache NS 
+ Managing a caching nameserver 
+ Practical Exercise:
  - Building your own cache nameserver
  - Improving the configuration of the cache NS
+ Question and Answer session
+ Summary

##### Configuring Authoritative Name Servers
###### [PowerPoint](dns/dns3-presentation.ppt)
###### [PDF](dns/dns3-presentation.pdf)

Goal: to properly configure an authoritative nameserver	

+ Recap of caching NS	
+ DNS Replication 
+ Outside world cannot tell the difference between master and slave 
+ When does replication take place? 
+ Two (2) Dangers with serial numbers 
+ Configuration of Master & Slave NS 
  - Format of Resource Records { SOA and NS } 
+ Ten (10) Common DNS Operational and Configuration Errors (RFC1912) 

##### Exercises
###### [Exercise](dns/dns3-exercise.txt)

Setting up authoritative name services for a domain

+ Master & Slave nameserver exercises 

##### Delegation and Reverse DNS
###### [PowerPoint](dns/dns4-presentation.ppt)
###### [PDF](dns/dns4-presentation.pdf)

+ How do you delegate a subdomain?
+ Glue records
+ Reverse DNS
  - Subnets smaller than /24
+ DNS Landmarks
  - Key organisations and people
+ The Root Zone
+ Top-Level Domains
  - Generic and Country Code TLDs
+ Registries, Registrars, Registrants
+ Nameserver Vendors
+ Conferences, Industry Groups
+ Mailing Lists
+ DNS Summary
+ Further reading

### DNSSEC
#### [Joe Abley](#JA)
###### [Presentation/PDF](dns/DNSSEC_High-Level_Awareness.pdf)
###### [Presentation/Keynote](dns/DNSSEC_High-Level_Awareness.key)
###### [Exercise/Text](dns/dns5-exercise.txt)

DNSSEC High Level Awareness

### RADIUS
#### [Chris Wilson](#CW)
###### [Presentation/OpenOffice](radius/presentation.odp)
###### [Presentation/PDF]

### Virtualization

#### [Laban Mwangi](#LM)
([PDF](https://github.com/afnog/sse/raw/master/virtualisation/docs/sse-virtualization-overview-2014.pdf)/[OpenOffice](https://github.com/afnog/sse/raw/master/virtualisation/docs/sse-virtualization-overview-2014.odp))
###### Virtualization Exercise ([TXT](virtualisation/Readme.md))
###### Virtualization with KVM ([PDF](virtualisation/afnog_2013_virtualization_kvm_cw_130610.pdf)/[OpenOffice](virtualisation/afnog_2013_virtualization_kvm_cw.odp))

### Load Balancing
#### [Laban Mwangi](#LM)
###### [Presentation/PDF](loadbalancing/docs/sse-LB-overview.pdf)
###### [Presentation/OpenOffice](loadbalancing/docs/sse-LB-overview.odp)

### Monitoring
#### [Kevin Chege](#KC)
###### [Monitoring IP Services](nagios/nagios.pdf)
###### [Nagios Exercise-1] (monitoring/nagios-exercise1.txt)
###### [Nagios Exercise-2] (monitoring/nagios-exercise2.txt)
###### [Smokeping Exercise] (monitoring/smokeping-exercise1.txt)

### Exim
#### [Chris Wilson](#CW)
###### [Presentation/PDF](exim/afnog_2013_exim_presentation_130613.pdf)  
###### [Presentation/OpenOffice](exim/afnog_2013_exim_presentation.odp)
###### [EICAR Anti-Virus Test File](exim/eicar)
###### [Sample spam message](exim/spam.txt)

### Mail
#### [Michuki Mwangi](#MM)
##### Introduction to POP and IMAP
###### [Presentation and Exercise/PDF](mail/dovecot-intro.pdf)
###### [Presentation and Exercise/PowerPoint](mail/dovecot-intro.ppt)

+ Dovecot - Server for POP and IMAP
  - What is Dovecot?
  - Installing dovecot from ports
  - Configuring Dovecot
  - Configuring POP3s and IMAPs

###### [Presentation and Exercise/PDF](mail/dovecot-scaling.pdf)
###### [Presentation and Exercise/PowerPoint](mail/dovecot-scaling.ppt)
###### [Dovecot Basic Mysql Schema](mail/dovecot-mysql-schema.sql)

+ Dovecot - Virtual Users
  - Configuring Dovecot for Virtual users with Mysql
  - Configuring Exim for Virtual Users 

##### Webmail using Squirrelmail
###### [Presentation/PDF](mail/squirrelmail.pdf)
###### [Presentation/PowerPoint](mail/squirrelmail.ppt)

+ Squirrelmail - Webmail IMAP
  - What is Squirrelmail
  - Installing Squirrelmail from ports/source
  - Configuring squirrelmail
  - Redirecting http to https

##### Scaling mail services
###### [Mail Server Clustering](mail/clustering.htm)
###### [Mail Server Scalability](mail/scalability.htm)

+ Mailserver scalability
  - Linear password files 
  - Linear mbox files 
  - Too many files in one directory 
  - CPU limits 
  - Disk performance 
  - Keep your SMTP (smarthost) and POP3 services separate 
+ Notes and Clustering and NFS
  - Using Network File System (NFS)
  - Using Proxies 
  - Load balancing 
  - Database backends
  - FreeBSD NFS 

### Security and Availability
#### [Joel Jaeggli](#JJ)
###### [Presentation/PDF](security/sse-sec-and-availability.pdf)
###### [Presentation/ODP](security/sse-sec-and-availability.odp)

### Closing Survey
#### [Joel Jaeggli](#JJ)
###### [Survey link](http://www.surveymonkey.com/s/7TD2J7T) (online)
###### [Survey results](survey/2013_exit_survey_results.pdf) (PDF)

## Management

Details for project management of the training

### Editing this page

Please [file an issue](https://github.com/afnog/sse/issues) requesting to be added as an administrator of the [AfNOG organisation on GitHub](https://github.com/afnog).

### Mailing list

The instructors group on Google Groups:

* Email address: afnog-sse@googlegroups.com
* Web interface: https://groups.google.com/forum/#!forum/afnog-sse

### Topics and Instructors

* Welcome - CW?
* DNS - JA?
* RADIUS - CW
* Apache - EN
* Virtualization - LM
* Load Balancing - LM
* Monitoring - KC
* Exim - CW
* Mail (Dovecot, Webmail, scalability) - KC
* Security and Availability - CW
* Closing Survey - CW

See the [wiki page](https://github.com/afnog/sse/wiki/Operating-System-Choices).

### Coordinating the lab-setup

Who is arriving when?

* CW on 22/05 around 14h
* EN on 24/05 
* KC on 25/05 early morning
* JA on 25/05 at 0900

### Administration

All done by CW unless anyone else wants to.

* Student numbers and names
* Classroom setup, networking, virtual machine images
* Notices - door, timetable, complaints box, wifi password
* Introductory talk - welcome, topic poll, complaints box
* Time management during the workshop (breaks, lunch, etc)
* Set alarms for break times
* Ensuring that every topic has an instructor and enough time allocated
* Ensuring that participants are receiving any assistance necessary
* Student name verification for certificates
* Coordinate the class group photo
* Liaise with the secretariat on any other issues that may be required
* Ensure that all course materials are placed on the workshop folder for CD burning at the end of the workshop
* Ensure that the participants complete and return the feedback form
* Download and serve any files needed, e.g. FreeBSD ISO images (for virtualisation) and packages (for pkg_add mirror)

#### TODO

* Student numbers and names
* Power strips: do we have enough? tape them down
* Set up desktop/backup PCs
* Distribute the Wifi password
* Nagios config for all PCs
* Phones to silent

### Meta (about this site)

Source code (Markdown):

* Latest master is in [GitHub](https://github.com/afnog/sse).
* Clone an offline copy with Markdown source (no HTML) at `git@github.com:afnog/sse.git`.

Generated HTML:

* Created with [gollum-site](https://github.com/dreverri/gollum-site) from the source code.
* Possibly outdated copy in [GitHub](https://github.com/afnog/afnog.github.io).
* [Browsable online](http://afnog.github.io/sse/) at http://afnog.github.io/sse/.
* Clone an offline copy (HTML, not Markdown) at `git@github.com:afnog/afnog.github.io.git`.

Generating the HTML:

If you're using Ruby 1.8, you may need to
[install Ruby 1.9](https://leonard.io/blog/2012/05/installing-ruby-1-9-3-on-ubuntu-12-04-precise-pengolin/)
first.

	sudo gem install jekyll execjs therubyracer
	jekyll




