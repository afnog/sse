# Virtualization with OpenStack

.height_8em[[![Virtualization](vmw-virtualization-defined.jpg)](http://www.vmware.com/virtualization/virtualization-basics/how-virtualization-works)]

### Chris Wilson, AfNOG 2015

You can access this presentation at: http://afnog.github.io/sse/virtualization/
([edit](https://github.com/afnog/sse/firewalls/virtualization.md))

---

## What will we do?

.fill[[![OpenStack Havana Architecture](openstack_havana_conceptual_arch.png)](http://docs.openstack.org/kilo/install-guide/install/apt/content/ch_overview.html)]

---

## Why are we doing it?

Rapid deployments

* Redundancy
* Fault tolerance
* Scalability
* Managed by [Juju](https://jujucharms.com/)

???

Juju can provision virtual machines on:

* commercial providers (e.g. EC2)
* our OpenStack cluster
* bare metal (MAAS)

---

## How will we do it?

* Create 3 virtual machines
* Install Ubuntu and OpenStack "Kilo" components
* Roughly following the instructions at:
http://docs.openstack.org/kilo/install-guide/install/apt/content/index.html
* Requirements: A PC with 4 GB RAM, 20 GB free disk space

---

## Install VirtualBox

* You can find installers and packages at: https://www.virtualbox.org/wiki/Downloads

---

## Create a Virtual Machine

* Named "Trusty OpenStack Compute"
  * One of our three virtual machines, the Compute Node
* Allocate 1 GB RAM, 20 GB disk space
* Install Ubuntu
  * Normally would use the server edition and drive from command line
  * In a virtual machine, the GUI makes it easier to manage

---

## Install Ubuntu

---
class: center, middle, inverse

## FIN

Any questions?
