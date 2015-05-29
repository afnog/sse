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

### Hostname

You must use a fully qualified hostname, for example `ganeti.pcXX.sse.ws.afnog.org`.

### Partitioning

The server should use LVM for disk space, so instead of the default *Guided Partitioning*, choose *Manual*, then *SCSI3*, then:

* Select *pri/log free space*, *Create a new partition*, 40 GB, *Primary*, *Beginning*, *Done*.
* Select the new partition, choose *Use as > Physical volume for LVM*.
* Select *Configure LVM volumes*
* Enter a name for the new main volume group, for example `xenvg`.
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

While the installation proceeds, familiarise yourself with the terminology of
[Ganeti](http://docs.ganeti.org/ganeti/2.13/html/admin.html).

### Network Re-Configuration

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

	auto xen-br0
	iface xen-br0 inet static
		address 192.168.56.10
		netmask 255.255.255.0
		bridge_ports eth1
		bridge_stp off
		bridge_fd 0

Edit `/etc/hostname` and put the fully-qualified hostname (FQDN) in there.

Edit `/etc/hosts` and ensure that it contains the IP address and hostname of
your host. You will also need to choose a name (hostname) and IP address for
your cluster, which must be different. For example:

	127.0.0.1       localhost
	192.168.56.10   ganeti1.sse.ws.afnog.org
	192.168.56.11   cluster1.sse.ws.afnog.org

Normally you would add DNS entries for all of these. Feel free to use the DNS
for the cluster name, instead of editing `/etc/hosts`. Your hostname should
really be in the DNS as well, but for the purposes of this exercise
(non-production deployment) it doesn't matter too much.

Edit `/etc/default/grub` and add the following line:

	GRUB_CMDLINE_XEN_DEFAULT="dom0_mem=min:384M,max:384M"

This restricts the master domain to 256 MB RAM, which will make it slow, but give us more RAM free
for guests. In your own configurations you should probably allocate more RAM to the host (domain 0)!

Then run the following commands:

	sudo update-grub
	sudo apt-get dist-upgrade	
	sudo apt-get install ganeti2 ganeti-htools ganeti-instance-debootstrap xen-hypervisor-amd64

Edit `/etc/xen/xend-config.sxp` and change the following setting:

	(enable-dom0-ballooning no)

Then `reboot` the host and log in again.

Start following the [Ganeti installation tutorial](http://docs.ganeti.org/ganeti/2.13/html/install.html),
skipping the following sections:

* Anything to do with KVM (we're using Xen instead)
* Installing RBD: skip to [Installing Gluster](http://docs.ganeti.org/ganeti/2.13/html/install.html#installing-gluster) instead.
* KVM userspace access
* Configuring the network
* Configuring LVM
* Installing Ganeti: skip to [#Initializing the Cluster](#initializing-the-cluster) below.

### Initializing the Cluster

Run the following command, substituting the cluster name you added to
`/etc/hosts` instead of `cluster1...`:

	sudo gnt-cluster init --vg-name Main --enabled-hypervisors=xen-pvm -H xen-pvm:xen_cmd=xl cluster1.sse.ws.afnog.org

**Note:** Normally you would use either `xen-hvm` or `kvm` as the hypervisor,
instead of `xen-pvm` above. In this case we must use `xen-pvm` because we are
doing this inside a virtual machine, so we can't use the virtualisation CPU
instructions because VirtualBox is already using them to run the Ganeti host
node (VirtualBox guest).

Create the file `/etc/ganeti/vnc-cluster-password` containing the password that
you want to use for VNC access to consoles.

### Testing the Setup

Check that the `gnt-node list` command shows your node:

	$ sudo gnt-node list
	Node                     DTotal DFree MTotal MNode MFree Pinst Sinst
	ganeti1.sse.ws.afnog.org  40.0G 28.8G   2.0G  1.9G  126M     0     0

> **Warning:** If you see question marks in all the columns after the node name, like this:
>
>	$ sudo gnt-node list
>	Node                     DTotal DFree MTotal MNode MFree Pinst Sinst
>	ganeti1.sse.ws.afnog.org      ?     ?      ?     ?     ?     0     0
>
> that means that Ganeti cannot retrieve information about your node. Check the node daemon logfile
> `/var/log/ganeti/node-daemon.log` for possible error messages. For example, if you find this error:
>
>	ERROR Can't retrieve xen hypervisor information (exited with exit code 1): ERROR:  A different toolstack (xl) have been selected!
>
> that means that Ganeti is trying to use the old `xm` command to get information, instead of the new `xl` command,
> and not getting any information. You probably forgot to add the option `-H xen-pvm:xen_cmd=xl` when you created
> the cluster. You can fix it by modifying the cluster settings on the node:
>
>	sudo gnt-cluster modify -H xen-pvm:xen_cmd=xl
>
> and check that the `gnt-node list` now shows the correct information for your node.
{: .warning}

You should also make sure that the `MFree` column shows at least 1 GB free (not
126 MB as in the example output above). This ensures that there is enough RAM
free in the hypervisor to create new guests. Otherwise you won't be able to do
much with your new hypervisor. If it doesn't show enough free RAM, check that
you have [reconfigured GRUB and run
`update-grub`](http://askubuntu.com/a/191489/49566).

Add an entry to `/etc/hosts` for a host to use for burnin testing, for example `burnin.example`.

Run the `burnin` test to make sure that everything is working properly:

	sudo /usr/lib/ganeti/tools/burnin -o debootstrap+default -t plain --disk-size 1024 burnin.example -vv

Continue following the installation instructions from [Testing the setup](http://docs.ganeti.org/ganeti/2.13/html/install.html#testing-the-setup)

### Install the Web Manager

Download the [latest release](https://code.osuosl.org/projects/ganeti-webmgr/files), for example 0.11.0. We have a local copy which you can download here:

	wget http://197.4.11.251/ganeti_webmgr-0.11.0.tar.gz

Then run the following commands to install it:

	sudo apt-get install fabric python-virtualenv
	sudo mkdir -p /var/www
	tar xzvf ganeti_webmgr-0.11.0.tar.gz
	sudo mv ganeti_webmgr-0.11.0 /var/www/ganeti
	cd /var/www/ganeti
	sudo mv requirements/production.txt requirements/prod.txt
	wget http://197.4.11.251/ganeti.patch | sudo patch -p0
	sudo fab deploy

