# VM setup using Libvirt and KVM

Using Ubuntu 16.04. Follow [server setup](../server/) first to configure the server.

Install libvirt and KVM:

	sudo apt install libvirt-bin qemu-kvm virtinst libosinfo-bin

Create a gold master guest image:

	osinfo-query os

	sudo virt-install --connect qemu:///system     --virt-type kvm --name SSE-Gold \
		--os-variant=debian8 --ram 512 --vcpus 1 --disk path=SSE-Gold.img,size=20 \
		--cdrom iso/debian-8.4.0-i386-DVD-1.iso --network=bridge=br0 \
		--graphics type=vnc,port=5901,listen=0.0.0.0,password=foo

Connect to the server using a VNC client to complete the installation. E.g. 196.200.223.144:5901.

During installation, say Yes to using a network mirror, and set the HTTP proxy to
http://196.200.223.144:3142/. For Software Selection, enable only SSH Server and
standard system utilities, disable the desktop.

Follow [guest.md](guest.md) to configure the gold master guest, but **leave the network configuration alone**
(configured by DHCP, the default).

Shut down the master and make a copy:

	sudo virsh shutdown SSE-Gold
	sudo mkdir -p /data/vm
	sudo cp SSE-Gold.img /data/vm/SSE-Gold-Master.img

Clone some VMs, with specific MAC addresses:

	for pc in {1..32}; do
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

Once they have all booted, fix their hostnames:

	for pc in {1..32}; do
		ssh -to StrictHostKeyChecking=no root@196.200.219.$[200+$pc] \
		"echo pc$pc.sse.ws.afnog.org | sudo tee /etc/hostname; 
		"'sudo hostname `cat /etc/hostname`'
	done
