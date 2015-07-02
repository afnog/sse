# Class Virtualisation Setup

Practical exercise: install FreeBSD 10 in a virtual machine on your own PC.

## System Requirements

You will need:

* A laptop or desktop (Windows, Macintosh, Linux or FreeBSD)
* About 2 GB RAM
* About 20 GB free disk space
* Administrative rights (root access)
* A CD or DVD drive or wireless card

If your laptop doesn't meet these specs: Work with a partner. (We may be able to provide a few spare machines, but not guaranteed.)

## CD or Wireless?

If possible, please use a FreeBSD CD/DVD/ISO image.

* Disks available on loan, please ask and sign for.
* Please return your disk after the session, sorry!
* We can copy the ISO image and VirtualBox onto a USB stick for you.

If you don't have a CD drive:

* You can install over the wireless network 
* Bandwidth is limited and shared between all of us
* Using CD or DVD  or ISO will be much faster for you
* Using CD or DVD or ISO will speed up wireless install for everyone who really needs it.

## Installing VirtualBox

We have local copies for:

* [Windows](VirtualBox-4.3.10-93012-Win.exe)
* [Mac OS X](VirtualBox-4.3.10-93012-OSX.dmg)

For other platforms, please visit:
* http://www.virtualbox.org/wiki/Downloads

Linux versions are at:
* https://www.virtualbox.org/wiki/Linux_Downloads

## Running VirtualBox

On Windows:
* Start/Programs/Oracle VM VirtualBox

On Mac OS X:
* Hard Disk/Applications/Oracle VM VirtualBox

On FreeBSD:
* Open a terminal and type VirtualBox

On Linux:
* Applications/System Tools/Oracle VM VirtualBox, or
* Search for VirtualBox (Ubuntu Unity), or
* Open a terminal and type VirtualBox

## VirtualBox Main Window

![VirtualBox Main Window](images/virtualbox-main-window.png)

* List of virtual machines (Probably empty!)
* Settings of the selected virtual machine
* Screen preview
* Toolbar buttons to control VMs: New, Settings, Start

## Creating a Virtual Machine

![VirtualBox New VM wizard](images/virtualbox-new-vm-wizard.png)

* Click *New* to create a new virtual machine
* Type FreeBSD as the name
* Choose _BSD_ as the type, and _FreeBSD (32 bit)_ as the version
* Virtual RAM:
  * Use less than half your machine's total RAM
  * 512MB is an acceptable minimum
* Virtual hard disk:
  * Dynamic expanding, 20 GB 

## Hold your horses!

* Don't start it yet!
* Need to change settings for IO APIC (to make FreeBSD work)

![Enable the IO APIC option](images/virtualbox-enable-io-apic.png)

* Click Settings
* Click System
* Click motherboard
* Enable IO APIC
* Ok/close

## Go!

The First Run Wizard appears:

![VirtualBox first run wizard](images/virtualbox-first-run-wizard.png)

This allows you to boot from an Operating System install CD or CD image (ISO file), which
you can obtain on a USB stick or CD from us, or download it from the NOC.

## Boot Device

![VirtualBox BIOS screen](images/virtualbox-bios-screen.png)

When you see the prompt _Press F12 to select boot device_, press F12.

If you miss it, open the VirtualBox menu and choose Machine/Reset menu to try again.

## Boot Menu

![VirtualBox boot menu](images/virtualbox-boot-menu.png)

* If booting from real CD, insert the disk now.
* Choose Devices/CD or DVD Device menu
* Select your CD-ROM image
* Press C to boot from CD-ROM, or
* Press L to boot from LAN (Network)

## FreeBSD Booting

![FreeBSD boot loader](images/virtualbox-freebsd-bootloader.png)

* Shows that FreeBSD is booting successfully from the ISO file (or the network)
* Allows you to interrupt the boot process and reconfigure FreeBSD
* Don't need to do anything, just let it continue booting after 10 seconds

## FreeBSD Installer

![FreeBSD installer welcome screen](images/freebsd-installer-welcome.png)

* New installer as of FreeBSD 9.1
* Text “windows”
* Buttons at the bottom
* TAB key to switch buttons
* Enter key to activate the selected button
* Up and Down arrows to select item from menu
* Select OK to activate/continue to next screen

## Standard Install

![FreeBSD partitioning wizard](images/freebsd-partitioning.png)

* Choose *Install* from the welcome screen
* Accept defaults most of the way through
* Set hostname
* Do guided partioning and let FreeBSD use the whole disk.
* Set root password and
* Create a new user
* Then you should be complete. 

## Keymap

Depends on your physical keyboard. Only used on the console, not by SSH, so not critical if it's wrong. Common choices would be:

* United States of America ISO-8895-1 (# on 3 key)
* United Kingdom ISO-8859-1 (£ on 3 key)
* French ISO-8859-1 (Azerty layout)

## Other useful KVM commands

* virsh list --all
* virsh autostart FreeBSD-Gold

## Questions

* How big are the disk images?
	* How big could they become?
* What hostname do the machines have?
	* How would you set it automatically?
* 	Use DHCP, set hostname="" in /etc/rc.conf
* How can you manage them in bulk?
	* How do you deal with OS updates?
	* What is the system clock set to?
	* What happens to system logs?
	* What are the SSH keys of these systems?

## AfNOG gold image

These steps are to create a new gold image for training (each year).

## Installation in KVM

We now use KVM instead of VirtualBox for the virtual servers for classrooms,
because it's more efficient, so we can run more virtual boxes per host (16
on a quad core Mac Mini i7 with 16 GB RAM).

	qemu-img create -f qcow2 FreeBSD-Gold.img 20G
	virt-install --connect qemu:///system \
	    --virt-type kvm \
	    --name FreeBSD-Gold \
	    --os-variant=freebsd8 \
	    --ram 1024 \
	    --vcpus 1 \
	    --disk path=FreeBSD-Gold.img,format=qcow2 \
	    --cdrom ~/Downloads/FreeBSD-10.0-RELEASE-i386-bootonly.iso \
	    --network=user,hostfwd=tcp::2222-:22

Note 1: not all versions of QEmu/libvirt support the `--network hostfwd`
option. Without it, you won't be able to SSH into the guest from the host
or the LAN.

Note 2: you may want to try `--network=network=default`, assuming that your
host is configured to forward packets, allow forwarding for the `virbr0`
interface, and NAT packets from `virbr0` to the LAN. For example the
following might work:

	sed -i -e 's/(net.ipv4.ip_forward)=.*/\1=1/' /etc/sysctl.conf
	sysctl -p
	iptables -I FORWARD -i virbr0 -s 192.168.122.0/24 -j ACCEPT
	iptables -t nat -I POSTROUTING -s 192.168.122.0/24 -j MASQUERADE

Note 3: if you're using VLANs on your physical LAN interface and you want
to bridge the virtual machines onto a particular VLAN, you can create a bridge
device for it like this in `/etc/network/interfaces`:

	iface br219 inet dhcp
		bridge_ports eth0.219

And have your virtual machine join it automatically, tagging its untagged
traffic, by running `virt-install` with the option `--network=bridge=br219`.

## Deleting the virtual machine

If you make a mistake and you need to delete it and run `virt-install` again,
you'll need to run the following commands first:

	virsh destroy FreeBSD-Gold
	virsh undefine FreeBSD-Gold
	rm FreeBSD-Gold.img

## Installing FreeBSD

* Keymap: UK ISO-8859-1
* Hostname: freebsd-gold.sse.ws.afnog.org
* Distributions: unselect Games, select Ports
* Networking: configure IPv4, use DHCP, no IPv6
* Mirror: ftp://ftp.uk.freebsd.org (or closer if possible)
* Guided partitioning, use entire disk
* Accept the defaults
* Enable `ntpd` to synchronise virtual machine time with global time
* Set the root password to `afnog`
* Create a user called `afnog` (password `afnog`) and invite them to the `wheel` group

## Post-Installation Step 1

The minimum necessary to get text console access, which is much more comfortable.

* Log into the guest
* Become root using `su`
* Make a backup of `/etc/ttys`
* Edit `/etc/ttys` (carefully, you might make the system unbootable)
* Find the line starting with `ttyu0`
* Change `dialup` on that line to `xterm`
* Change `off` on that line to `on`
* Save changes and run `init q`

On the host, try to connect to this console using:

	virsh console FreeBSD-Gold

Press Enter and you should see a `login:` prompt.

## Post-Installation Step 2

Hopefully with the help of a text console from step 1, run the following
commands on the guest:

	pkg
	pkg install sudo bash
	echo 'fdesc /dev/fd fdescfs rw 0 0' >> /etc/fstab
	mount /dev/fd
	echo 'afnog ALL=(ALL) ALL: ALL' >> /usr/local/etc/sudoers
	chsh -s /usr/local/bin/bash afnog
	mkdir -p /root/.ssh /home/afnog/.ssh
	scp chris@10.0.2.2:.ssh/id_rsa.pub /root/.ssh/authorized_keys
	cp /root/.ssh/authorized_keys /home/afnog/.ssh
	echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
	/etc/rc.d/sshd restart

Please test that you can login to the host using SSH to the `root` and `afnog`
accounts.

## Restarting the Guest

After shutting down the guest, you can start it again for testing or to make
changes using this commands:

	virsh start FreeBSD-Gold

## Creating Clones

To run a big class you'll need a lot of virtual machine clones. Here's how to
create 32 clones using the gold image and `libvirt`.

First, configure your DHCP server to give each guest the correct IP address
when it boots, so you can log in and manage it. For example, if you're using
ISC DHCP daemon:

	for pc in {1..32}; do
		hostname=pc$pc
		ipaddr=196.200.219.$pc

		macaddr=`echo $hostname | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:54:\1:\2:\3:\4/'`
		cat <<EOF
	host $hostname {
	hardware ethernet $macaddr;
	fixed-address $ipaddr;
	}
	EOF
	done

And here's how to create the `libvirt` configurations (note, 32 is too many
guests for a single host, you probably want to put `1..16` on one host and
`17..32` on another, with 16 GB RAM each):

	for pc in {1..32}; do
		hostname=pc$pc
		macaddr=`echo $hostname | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:54:\1:\2:\3:\4/'`
		image=/data/vm/$hostname.img
		sudo qemu-img create -f qcow2 \
			-o backing_file=FreeBSD-Gold.img \
			$image
		virt-install --connect qemu:///system \
			--virt-type kvm --name $hostname \
			--os-variant=freebsd8 --ram 512 --vcpus 1 \
			--disk path=$image,format=qcow2 \
			--network=bridge=br219,mac=$macaddr \
			--graphics type=vnc,listen=0.0.0.0 --import
	done

