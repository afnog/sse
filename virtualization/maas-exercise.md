# MAAS Exercise

MAAS is not a virtualisation system. It's an OS deployment tool. We will use it later to deploy
software quickly, such as OpenStack, which we can use for virtualisation.

MAAS is normally installed on physical machines. We don't have enough physical machines, so we
will use virtual machines in this lab.

## Install the MAAS Controller

Every MAAS setup requires a controller server. Needs about 20 GB disk space (for OS images to deploy)
and 2 GB RAM. (why?)

Install VirtualBox. 

> If you already have VirtualBox installed, please note that we are going to disable DHCP on the
> Host Network Adapter vboxnet1. Please check whether any of your virtual machines are using this adapter.
> If they are, please choose a different one in the following examples.

Open VirtualBox Preferences > Network > Host-Only Adaptors > vboxnet1 and disable the DHCP server.

Create a new VM called MAAS Controller. Give it 1 GB RAM and a 40 GB VDI disk,
dynamically sized.

### Starting Installation

Start the VM and attach the Ubuntu 14.04 Server 64-bit CD. Choose the *Multiple server installation
with MAAS* option:

![MAAS boot](maas-install-boot-marked.png)

### Partitioning

The MAAS server needs more memory than you might want, so we need to give it a big swap space.

Instead of the default *Guided Partitioning*, choose *Manual*, then *SCSI3*, then:

* Select *pri/log free space*, *Create a new partition*, 40 GB, *Primary*, *Beginning*, *Done*.
* Select *pri/log free space*, *Create a new partition*, 2.9 GB (approx), *Logical*, *Use as* > *Swap area*, *Done*.
* Finish and Write changes to disk.

### Proxy Server

When asked for a proxy server, enter this one (to save a LONG install time):

* http://197.4.11.251:3142

### After Installation

After installation, shut down the machine and reconfigure its network interfaces in VirtualBox

* Adapter 1: Bridged to your Wireless NIC (if that doesn't work, you can use the loopback interface
  with Internet Connection Sharing that you created for GNS3)

* Adapter 2: Host-only network, vboxnet0, enable Promiscuous Mode.

Then start the machine again. Log in on the console and edit /etc/network/interfaces to look
something like this:

	

sudo http_proxy=http://197.4.11.251:3128 maas-import-pxe-files

