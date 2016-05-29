---
vim: autoread
jekyll: process
layout: default
---

# AfNOG {{page.year}} Workshop on Network Technology

## Track SS-E: Scalable Internet Services

<div class="sectionjumps" markdown="1">
Jump within this page:

* [Introduction](#introduction)
* [Instructors](#instructors)
* [Timetable](#timetable)
* [Topics](#topics)
* [Management](#management)
</div><!-- sectionjumps -->

<p><a href="https://www.flickr.com/photos/65789103@N06/18071392728/" class="group-photo"><img
      src="images/Class_Group_Photo.jpg"
      alt="[SS-E Group Photo]"></a></p>

## Introduction

This course on Scalable Internet Services is part of the
[AfNOG {{page.year}} Workshop on Network Technology](http://www.ws.afnog.org/afnog{{page.year}}/index.html),
held in conjunction with the [AfNOG meeting](http://www.afnog.org/)
in Tunisia, May-June {{page.year}}.

We use hands-on training in a well-equipped classroom over a five-day period to teach skills required for the configuration and operation of large scale Internet services.

### Who should attend

Technical staff who are now providing Internet Services, or those who will be involved in the establishment and/or provisioning of a basic national Internet Services in the country.

### Prerequisites

Experience using and administering *NIX Servers, Name Servers, Web Servers and Mail Servers.

### Instructors

<table class="instructors">
	<thead><tr><th>Name</th><th>Initials</th><th>From</th></tr></thead>
	<tbody>
		<!-- sorted by surname -->
		<tr id="JA"> <td>Joe Abley</td>      <td>JA</td> <td>Canada</td> </tr>
		<tr id="AB"> <td>Ayitey Bulley</td>  <td>AB</td> <td>Ghana</td> </tr>
		<tr id="KC"> <td>Kevin Chege</td>    <td>KC</td> <td>Kenya</td> </tr>
		<tr id="FK"> <td>Frank Kuse</td>     <td>FK</td> <td>Ghana</td> </tr>
		<tr id="EN"> <td>Michuki Mwangi</td> <td>MM</td> <td>Kenya</td> </tr>
		<tr id="CW"> <td>Chris Wilson</td>   <td>CW</td> <td>UK</td> </tr>
		<tr id="EO"> <td>Emmanuel Odoom</td> <td>EO</td> <td>?</td> </tr>
	</tbody>
</table>

### Participants

<!-- sorted by surname -->

|First Names	|Surname	|Organisation				|Country
|:-             |:-             |:-                                     |:-
|Amel		|HAMIMY		|SudREN					|Sudan

### Timetable

|		|Monday			|Tuesday		|Wednesday		|Thursday		|Friday
|:-             |:-                     |:-                     |:-                     |:-                     |:-
|		|30/05			|31/05			|01/06			|02/06			|03/06
|09:00-11:00	|[Introduction][]	|[Data Security][]	|[Postfix][]		|[RADIUS][]		|[Load Balancing][]
|-
|Tea break
|11:30-13:00	|[DNS Fundamentals][]		|[DNS][]		|[Postfix][]		|[RADIUS][]		|[Virtualisation][]
|-
|Lunch
|14:00-16:00	|[Network Security][]	|[DNS][]		|[OpenLDAP][]		|[Dovecot][]		|[Virtualisation][]
|-
|Tea break
|16:30-18:30	|[DNS][]		|[Apache][], [Postfix][]|[OpenLDAP][]		|[SquirrelMail][]	|Expert Panel and [Closing Survey][]
|-
|Supper
|**Evening Sessions:** <br /> 20:00-22:00	|General Help	|Closed	|[DNSSEC][]	|[Ansible][] |Closing Ceremony
{: .timetable width="80%"}

<div class="topics" markdown="1">
## Topics

<!-- Please keep these topics in alphabetical order (except for Introduction first), thanks! -->

### Introduction
[Introduction]: #introduction-1

#### [Chris Wilson](#CW)

* [Presentation](intro/index.html)
* [Opening Survey](https://www.surveymonkey.com/s/JW98WTD)
* [Survey Results](intro/opening-survey-results.pdf)

### Apache
[Apache]: #apache

#### [Evelyn Namara](#EN)

* [Presentation/PowerPoint](apache/apache.ppt)
* [Presentation/PDF](apache/apache.pdf)
* [Exercise1 - Apache Installation/SSL](apache/apache_sse_exercises_apache+ssl.txt)
* [Exercise2 - MySQL/PHP/Wordpress Install](apache/apache_sse_exercises_Mysql & PHP configs.txt)
* [Exercise3 - Wordpress Configuration](apache/apache_sse_exercises_wordpress.txt)

### Backups
[Backups]: #backups

#### [Joe Abley](#JA)

* [Backups Presentation (OpenOffice Impress)](backups/regnauld-afnog2006-backups.sxi)
* [Backups Presentation (PDF)](backups/regnauld-afnog2006-backups.pdf)
* [Backups Exercise](backups/backups1-exercise1.txt)

### Closing Survey
[Closing Survey]: #closing-survey

#### [Chris Wilson](#CW)

* [Survey link](https://www.surveymonkey.com/s/623JR5J) (online)
* [Survey results/PDF](intro/closing-survey-results.pdf)

### Configuration Management

#### [Laban Mwangi](#LM)

* [Exercise](config-mgmt/Readme.md)

### Data Security
[Data Security]: #data-security

#### [Joe Abley](#JA)

* [Presentation (PowerPoint)](pgp/pgp-presentation1.pptx)
* [Presentation (PDF)](pgp/pgp-presentation1.pdf)
* [Exercise](pgp/pgp-exercise1.txt)
* [Key File](pgp/pgp-presentation1.key)
* [Old NANOG Presentation](pgp/nanog29-jabley-pgp.pdf)

### DNS
[DNS]: #dns

#### [Joe Abley](#JA)

##### DNS Fundamentals
[DNS Fundamentals]: #dns-fundamentals

* [PowerPoint](dns/dns1-presentation.ppt)
* [PDF](dns/dns1-presentation.pdf)
* [Exercise](dns/dns1-exercise.txt)

##### DNS Resolvers
[DNS Resolver]: #dns-resolvers

* [PowerPoint](dns/dns2-presentation.pptx)
* [PDF](dns/dns2-presentation.pdf)
* [Exercise 1](dns/dns2-exercise1.txt)
* [Exercise 2](dns/dns2-exercise2.txt)
* [Exercise 3](dns/dns2-exercise3.txt)

##### DNS Authoritative Name Servers
[DNS Authoritative]: #dns-authoritative-name-servers

* [PowerPoint](dns/dns3-presentation.ppt)
* [PDF](dns/dns3-presentation.pdf)
* [Exercise](dns/dns3-exercise.txt)

##### DNSSEC
[DNSSEC]: #dnssec

Goal: DNSSEC High Level Awareness.

* [Presentation/PDF](dns/DNSSEC_High-Level_Awareness.pdf)
* [Presentation/Keynote](dns/DNSSEC_High-Level_Awareness.key)
* [Exercise/Text](dns/dns5-exercise.txt)

### Ganeti
[Ganeti]: #ganeti

#### [Chris Wilson](#CW)

* Ganeti Presentation: to be written
* [Ganeti Exercise](virtualization/ganeti-exercise.html)

### Internet Protocols

#### [Chris Wilson](#CW)

Goal: to understand the contents and layering of common Internet protocols

* [Exercise](ip/exercise.html)

### Load Balancing
[Load Balancing]: #load-balancing

#### [Frank Kuse](#FK)

* [Presentation/PDF](loadbalancing/docs/sse-LB-overview.pdf)
* [Presentation/OpenOffice](loadbalancing/docs/sse-LB-overview.odp)

### MAAS
[MAAS]: #maas

#### [Chris Wilson](#CW)

* MAAS Presentation: to be written
* [MAAS reference](https://williamlsd.wordpress.com/2014/04/26/installing-local-cloud-infrastructure-using-ubuntu-14-04-lts-maas/)
* [MAAS Exercise](virtualization/maas-exercise.html)

### Monitoring
[Monitoring]: #monitoring

#### [Kevin Chege](#KC)

* [Monitoring IP Services](nagios/nagios-presentation.pdf)
* [Nagios Exercise-1](nagios/nagios-exercise1.txt)

### RADIUS
[RADIUS]: #radius

#### [Frank Kuse](#FK)

* [Presentation/powerpoint](radius/radius_presentation.ppt?raw=true)
* [Presentation/PDF](radius/radius_presentation_140528_cw.pdf?raw=true)

### Postfix
[Postfix]: #postfix

#### [Kevin Chege](#KC)

+ understanding email
+ Some Email Best Practices
+ Postfix and Dovecot

* [Email Overview](postfix/01_email_preso.pdf)
* [Email Best Practices, Postfix and Mail Gateways](postfix/postfix-mailgateway-debian.pdf)

##### Spam Filtering
[Spam Filtering]: #spam-filtering

* [Debian Mail Gateway Part 1](postfix/mailgateway-pt1.txt)
* [Debian Mail Gateway Part 2](postfix/mailgateway-pt2.pdf)
* [Debian Mail Gateway Part 3](postfix/mailgateway-pt3.txt)
* [Test Your Mail Gateway](postfix/test_mailgateway.pdf)
* [Postfix Mail Forward HowTo](postfix/postfix_mailforward.txt)

### Virtualization
[Virtualization]: #virtualization

#### [Chris Wilson](#CW)

* [Intro Presentation (OpenOffice Impress)](virtualization/sse-virtualization-overview-2013.odp)
* [Intro Presentation (PDF)](virtualization/sse-virtualization-overview-2013_150527.pdf)
* [KVM Presentation (OpenOffice Impress)](virtualization/afnog_2015_virtualization_kvm_cw.odp)
* [KVM Presentation (PDF)](virtualization/afnog_2015_virtualization_kvm_cw_150527.pdf)

</div><!-- .topics -->

## Management

Details for project management of the SS-E workshop.

### Editing this page

Please [file an issue](https://github.com/afnog/sse/issues) requesting to be added as an administrator of the [AfNOG organisation on GitHub](https://github.com/afnog).

### Mailing list

The instructors group on Google Groups:

* Email address: [afnog-sse@googlegroups.com](mailto:afnog-sse@googlegroups.com)
* Web interface: [https://groups.google.com/forum/#!forum/afnog-sse](https://groups.google.com/forum/#!forum/afnog-sse)

There is a [wiki page on course development](https://github.com/afnog/sse/wiki/Operating-System-Choices).

### Equipment

To host this track you will probably need the following equipment:

* 2 x Mac Minis or similar, quad core i7 2Ghz+, 16GB Ram, 250 GB SSD (to host 16 virtual machines each)
* Projector: VGA required, HDMI optional, screen/wall. Mac VGA and HDMI adaptors.
* Wifi: ideally wired and wireless on the same SSID with /24.
* Wired Ethernet ports: probably 4-8 ports for people with broken wireless and for instructors in our classroom.
* Power strips: 12 x 4 socket.
* Spare machines: 4 x reasonable desktop/laptop with 1 GB RAM and permission to reformat and install Ubuntu or FreeBSD.
* Sun shading: to be able to read the projected screen and not overheat in our
rooms.
* White board, pens and eraser: at least 3 pens in 2 different colours.

### Administration

All done by CW unless anyone else wants to.

* Student numbers and names
* Classroom setup, networking, virtual machine images, cable management
* Notices - door, timetable, complaints box, wifi password
* Introductory talk - welcome, topic poll, complaints box
* Time management during the workshop (breaks, lunch, etc)
* Set alarms for break times
* Ensure that every topic has an instructor and enough time allocated
* Ensure that participants are receiving any assistance necessary
* Student name verification for certificates
* Coordinate the class group photo
* Liaise with the secretariat on any other issues that may be required
* Ensure that all course materials are placed on the workshop folder for CD burning at the end of the workshop
* Ensure that the participants complete and return the feedback form
* Download and serve any files needed, e.g. FreeBSD ISO images (for virtualisation) and packages (for pkg_add mirror)

### TODO

## Meta (about this site)

### Quick Start (editing)

* Request write access to the repositories below, or clone them (and use the clone URLs instead)
* Install SparkleShare
* Add `git@github.com:afnog/sse.git` to it
* Add `git@github.com:afnog/afnog.github.io.git` to it
* Install Jekyll: `sudo gem install jekyll execjs therubyracer`
* Open a command prompt and go to ~/SparkleShare/sse
* Run `make serve`
* Edit the Markdown files in `~/SparkleShare/sse/.../*.md`
* View the results in your browser at http://localhost:4000/.../*.html

### Source code (Markdown)

* Latest master is in [GitHub](https://github.com/afnog/sse).
* Edit online using GitHub's web editor, or:
* Clone an offline copy with Markdown source (no HTML) at `git@github.com:afnog/sse.git`.
* The syntax is parsed with Kramdown, which adds some useful [extensions](http://kramdown.gettalong.org/quickref.html).

### Generated HTML

* HTML files are auto-generated from Markdown by Jekyll - do not edit by hand!
* All files except those starting with `---` ([front matter](http://jekyllrb.com/docs/frontmatter/)) are copied literally from the source (`sse`) repository.
* Possibly outdated copy in [GitHub](https://github.com/afnog/afnog.github.io),
  [browsable online](http://afnog.github.io/sse/) at http://afnog.github.io/sse/.
* Clone an offline copy (HTML, not Markdown) at `git@github.com:afnog/afnog.github.io.git`.
* Some variables are stored in `_config.yml`, e.g. the year, and used with `{{page.year}}` in HTML and Markdown files.

### Presentations

Presentations use a special format to invoke [remark](http://remarkjs.com/)
on the Markdown source files:

* The Markdown source is called `presentation.md` (so there can be only one
  per directory).
* In the same directory is a file called `index.md`, which tells Jekyll to
  use a specific layout (template file) to generate the HTML:
  `_layouts/presentation.html`.
* This file is generic and the same for all presentations. It loads the Remark
  source code, and then loads the `presentation.md` file from the same
  directory using AJAX. So the URL that you use to load it is very important
  in locating the correct `presentation.md` file.
* This means that you cannot use Kramdown extensions in presentations. No
  presentation.html files are generated because the `presentation.md` files
  deliberately do not have a "front matter" section which Jekyll requires.

### Generating the HTML

If you're using Ruby 1.8, you may need to
[install Ruby 1.9](https://leonard.io/blog/2012/05/installing-ruby-1-9-3-on-ubuntu-12-04-precise-pengolin/)
first.

**Warning**: This command by default will overwrite ../afnog.github.io/sse,
since it assumes that you have both https://github.com/afnog/sse/ and
https://github.com/afnog/afnog.github.io/ checked out side-by-side (for example
in [SparkleShare](http://sparkleshare.org/)).

If you want it to overwrite a different directory (where it will write the
generated HTML files), you can specify it as a command-line argument to Make:

	make DST_DIR=/tmp/site

You will need to install Jekyll to generate the HTML files:

	sudo gem install jekyll execjs therubyracer

Then run `make` to build them once, in the destination directory:

	make

Or run `make watch` to tell Jekyll to stay running, watch for source files
changing, and generate a new HTML file when they do (ideal for modifying
presentations on the fly):

	make watch

### Publishing the HTML

You can use `make sync` to run `lsyncd` (which you must have installed, for
example with `brew install lsyncd`) to automatically `rsync` the content to the
workshop server, http://www.ws.afnog.org.  You will need to check the
`SYNC_HOST` and `SYNC_DIR` in the `Makefile`, which must point to the
destination host and directory **which will be overwritten**.

	make sync
