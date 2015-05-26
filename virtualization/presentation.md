class: center, middle

# Virtualization with OpenStack

.center.height_8em[[![Virtualization](vmw-virtualization-defined.jpg)](http://www.vmware.com/virtualization/virtualization-basics/how-virtualization-works)]

### Chris Wilson, AfNOG 2015

You can access this presentation at: http://afnog.github.io/sse/virtualization/
([edit](https://github.com/afnog/sse/firewalls/virtualization.md))

---
background: url(openstack_havana_conceptual_arch.png) center/70%

???

What are we going to do?

Create an OpenStack cluster using virtual host machines.

---

## Why?

???

* Enables rapid deployments of new virtual machines
* Build rendundant, fault-tolerant, scalable systems
* We will use Juju to deploy and manage VMs on our OpenStack hosts later
* Juju supports several commercial providers (e.g. EC2), OpenStack and MAAS (bare metal)

---

## How?

* Create 3 virtual machines
* Install Ubuntu and OpenStack "Kilo" components
* Roughly following the instructions at:
http://docs.openstack.org/kilo/install-guide/install/apt/content/index.html
* Requirements: A PC with 4 GB RAM, 20 GB free disk space

---

## Install VirtualBox

* You can find installers and packages at: https://www.virtualbox.org/wiki/Downloads

---
class: center, middle, inverse

## FIN

Any questions?
