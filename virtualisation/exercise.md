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

![VirtualBox Main Window](virtualbox-main-window.png)

* List of virtual machines (Probably empty!)
* Settings of the selected virtual machine
* Screen preview
* Toolbar buttons to control VMs: New, Settings, Start

## Creating a Virtual Machine

![VirtualBox New VM wizard](virtualbox-new-vm-wizard.png)

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

![Enable the IO APIC option](virtualbox-enable-io-apic.png)

* Click Settings
* Click System
* Click motherboard
* Enable IO APIC
* Ok/close

## Go!

The First Run Wizard appears:

![VirtualBox first run wizard](virtualbox-first-run-wizard.png)

This allows you to boot from an Operating System install CD or CD image (ISO file), which
you can obtain on a USB stick or CD from us, or download it from the NOC.

## Boot Device

![VirtualBox BIOS screen](virtualbox-bios-screen.png)

When you see the prompt _Press F12 to select boot device_, press F12.

If you miss it, open the VirtualBox menu and choose Machine/Reset menu to try again.

## Boot Menu

![VirtualBox boot menu](virtualbox-boot-menu.png)

* If booting from real CD, insert the disk now.
* Choose Devices/CD or DVD Device menu
* Select your CD-ROM image
* Press C to boot from CD-ROM, or
* Press L to boot from LAN (Network)

## FreeBSD Booting

![FreeBSD boot loader](virtualbox-freebsd-bootloader.png)

* Shows that FreeBSD is booting successfully from the ISO file (or the network)
* Allows you to interrupt the boot process and reconfigure FreeBSD
* Don't need to do anything, just let it continue booting after 10 seconds

## FreeBSD Installer

![FreeBSD installer welcome screen](freebsd-installer-welcome.png)

* New installer as of FreeBSD 9.1
* Text “windows”
* Buttons at the bottom
* TAB key to switch buttons
* Enter key to activate the selected button
* Up and Down arrows to select item from menu
* Select OK to activate/continue to next screen

## Standard Install

![FreeBSD partitioning wizard](freebsd-partitioning.png)

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

## AfNOG gold image

These steps are to create a new gold image for training (each year).

## Installation in KVM

  qemu-img create -f qcow2 FreeBSD-Gold.img 20G
  virt-install --connect qemu:///system \
    --virt-type kvm \
    --name FreeBSD-Gold \
    --os-variant=freebsd8 \
    --ram 1024 \
    --vcpus 1 \
    --disk path=FreeBSD-Gold.img \
    --cdrom ~/Downloads/FreeBSD-10.0-RELEASE-i386-bootonly.iso \
    --network=user

* Keymap: UK ISO-8859-1
* Hostname: freebsd-gold.sse.ws.afnog.org
* Distributions: unselect Games, select Ports
* Networking: configure IPv4, use DHCP, no IPv6
* Mirror: ftp://ftp.uk.freebsd.org (or closer if possible)
* Guided partitioning, use entire disk
* Accept the defaults
* Enable `ntpd` to synchronise virtual machine time with global time
