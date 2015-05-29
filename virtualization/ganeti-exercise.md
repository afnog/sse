---
vim: autoread
jekyll: process
layout: default
root: ..
---

# Ganeti Exercise

[Ganeti](https://code.google.com/p/ganeti/) is a virtual machine cluster
management tool developed by Google. The solution stack uses either Xen or KVM
as the virtualization platform, LVM for disk management, and optionally DRBD
for disk replication across physical hosts.

We will install Ganeti in a virtual machine, configure it to use the Xen
hypervisor, and use it to create and manage some virtual machines.

Normally you would install this on your physical hosts. We are using it in a
VirtualBox virtual machine which is pretending to be our physical host, because
we don't have enough physical boxes for everyone. This forces us to use Xen
(which is slower than KVM) because we can't use KVM inside a VirtualBox virtual
machine. You could use either for a real deployment. The installation process
is slightly different. KVM is not covered here.

## Installing the first host machine

Install VirtualBox or make sure you are running version 4.3 or higher.

Open VirtualBox Preferences > Network > Host-Only Adaptors. Ensure that you
have at least two listed: vboxnet0 and vboxnet1. If not, click on the Add
button to the right of the list to create them.

Double-click on *vboxnet0* and check that the IP addresses are as follows:

* IP address: 192.168.56.1
* Subnet mask: 255.255.255.0

And check that the DHCP server is enabled and configured for:

* Server address: 192.168.56.1
* Server mask: 255.255.255.0
* Lower address bound: 192.168.56.100
* Upper address bound: 192.168.56.200

![Enabling the DHCP server](virtualbox-disable-host-network-dhcp.png)

If you have made any changes, then **exit and restart VirtualBox**, otherwise
this change will not take effect, as we discovered after an hour of debugging!

Create a new VM called Ganeti Demo. Give it 2 GB RAM and a 40 GB VDI disk,
dynamically sized.

### Starting Installation

Start the VM and attach the Ubuntu 14.04 Server 64-bit CD. Read the following sections
**before** you start the installation, and use them at the appropriate times during the
installation.

### Partitioning

The server should use LVM for disk space, so instead of the default *Guided Partitioning*, choose *Manual*, then *SCSI3*, then:

* Select *pri/log free space*, *Create a new partition*, 40 GB, *Primary*, *Beginning*, *Done*.
* Select the new partition, choose *Use as > Physical volume for LVM*.
* Select *Configure LVM volumes*
* Enter a name for the new main volume group, for example `Disk1`.
* Create a logical volume of 8 GB, *Name > Root, Use as > ext4 filesystem, Mount point > / (root)*.
* Create a logical volume of 4 GB, *Name > Swap, Use as > swap*.
* Leave the rest of the volume group as unallocated free space.
* Finish and Write changes to disk.

### Proxy Server

When asked for a proxy server, enter this one (to save a LONG install time):

* http://197.4.11.251:3142

Please enter this carefully and check it. Using the wrong value will make it
impossible for you to install any packages.  Of course, if you are not at the
AfNOG workshop then this server will no longer exist, so use a local proxy
server or leave it blank.

### After Installation

After installation, shut down the machine and reconfigure its network interfaces in VirtualBox

* Adapter 1: Do not change, leave set to NAT.
* Adapter 2: Host-only network, vboxnet0, enable Promiscuous Mode.

![Configuring Network Adaptor 1](virtualbox-configure-adaptor-2.png)

Then start the machine again. Log in on the console and edit `/etc/network/interfaces` to look like this:

	# The loopback network interface
	auto lo
	iface lo inet loopback

	# The primary network interface
	auto eth0
	iface eth0 inet dhcp

	auto eth1
	iface eth1 inet manual

	auto xenbr0
	iface xenbr0 inet static
		address 192.168.56.10
		netmask 255.255.255.0
		bridge_ports eth1
		bridge_stp off
		bridge_fd 0

Then `reboot` the host, log in again and run the following commands:

	sudo apt-get install patch
	cd /
	wget -O- http://197.4.11.251/utils.patch | sudo patch -p0
	sudo maas-region-admin createsuperuser

This will create a new administrator user, for which you will have to enter a username and password
and an email address. Then run:

	sudo http_proxy=http://197.4.11.251:3128/ maas-import-pxe-files

The last command will take some time to run, you can leave it running.

Open http://192.168.57.1/MAAS in a browser on your laptop and you should be able to log in.

Go to *Clusters > Cluster master > Add interface* and configure it like this:

* Interface: eth1
* Management: Manage DHCP and DNS
* IP: 192.168.57.1
* Subnet mask: 255.255.255.0
* Router IP: 192.168.57.1
* IP range low: 192.168.57.100
* IP range high: 192.168.57.200

And click on *Save interface*.

Click on the cog icon in the top right, find the box marked *Proxy for HTTP and HTTPS traffic*,
and enter `http://197.4.11.251:3128`. Click on the Save button.

Then use the console to reboot the server.

## Install a Node

In VirtualBox create a new VM called MAAS Node 1. Give it 1 GB RAM and a 40 GB VDI disk,
dynamically sized.

Configure its network Adapter 1 to use a Host-Only network, and select *vboxnet1*. This
client should only have a single network adaptor.

Start the client and immediately press F12 to select a boot device, then press `L` to boot
from the LAN. This should boot from your MAAS Controller. It should get to a login screen
(saying `maas-enlisting-node login:`), sit there for about 15 seconds (with the network connection
active, as you can see from flashing network lights in VirtualBox), and then shut itself down.


