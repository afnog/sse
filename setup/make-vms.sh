#!/bin/bash

set -e

for pc in {2..32}; do
	hostname=pc$pc
	domainname=$hostname.sse.ws.afnog.org
	macaddr=`echo $domainname | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:54:\1:\2:\3:\4/'`
	image=/data/vm/$hostname.img
	sudo qemu-img create -f qcow2 -o backing_file=/data/vm/SSE-Gold-Master.img $image
	sudo virt-install --connect qemu:///system     --virt-type kvm --name $hostname \
		--os-variant=debian8 --ram 512 --vcpus 1 --disk path=$image,format=qcow2 \
		--network=bridge=br0,mac=$macaddr --import --noautoconsole \
		--serial tcp,host=:$[2200+$pc],mode=bind,protocol=telnet --noautoconsole
	sudo virsh autostart $hostname
done

