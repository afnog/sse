# VM setup using Libvirt and KVM

Using Ubuntu 16.04. Follow [server.md] first to configure the server.

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

Follow [guest.md] to configure the gold master guest, but **leave the network configuration alone**
(configured by DHCP, the default).

Shut down the master and make a copy:

	sudo virsh shutdown SSE-Gold
	sudo mkdir -p /data/vm
	sudo cp SSE-Gold.img /data/vm/SSE-Gold-Master.img

Clone some VMs, with specific MAC addresses:

	for pc in {1..40}; do
		hostname=pc$pc
		domainname=$hostname.sse.ws.afnog.org
		macaddr=`echo $domainname | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:54:\1:\2:\3:\4/'`
		image=/data/vm/$hostname.img
		sudo qemu-img create -f qcow2 -o backing_file=/data/vm/SSE-Gold-Master.img $image
		sudo virt-install --connect qemu:///system     --virt-type kvm --name $hostname \
			--os-variant=debian8 --ram 512 --vcpus 1 --disk path=$image,format=qcow2 \
			--network=bridge=br0 --import --noautoconsole \
			--serial tcp,host=:$[2200+$pc],mode=bind,protocol=telnet --noautoconsole
	done

Edit your user's crontab and add the following line to make your containers auto-start:

	@reboot lxc-autostart

Stop the container and make a lot of copies:

	lxc-stop --name debian8 -t 30
	NUM_PCS=30
	for i in `seq 1 $NUM_PCS`; do
		lxc-copy --name debian8 --newname pc$i.sse.ws.afnog.org
		sudo sed -i -e "s/100/$[100+$i]/" .local/share/lxc/pc$i.sse.ws.afnog.org/rootfs/etc/network/interfaces
	done
	lxc-autostart

Optional: time how long it takes for them all to start completely (enough to get an IP address):

	lxc-autostart -k -t 5
	lxc-autostart & time while lxc-ls --fancy | awk '{ print $5 }' | grep -q -- -; do sleep 1; done

And try to reduce it with unionfs mounts (experimental):

	lxc-autostart -k -t 5
	ROOT=/home/inst/.local/share/lxc
	for i in `seq 1 $NUM_PCS`; do
		sudo umount $ROOT/pc$i.sse.ws.afnog.org/rootfs
		test -d $ROOT/pc$i.sse.ws.afnog.org/rootfs.orig || mv $ROOT/pc$i.sse.ws.afnog.org/rootfs{,.orig}
		mkdir -p $ROOT/pc$i.sse.ws.afnog.org/rootfs

		echo "none $ROOT/pc$i.sse.ws.afnog.org/rootfs" \
			"aufs br=$ROOT/pc$i.sse.ws.afnog.org/rootfs.rw=rw:$ROOT/debian8/rootfs=ro 0 0" \
		| sudo tee -a /etc/fstab

		sudo mount $ROOT/pc$i.sse.ws.afnog.org/rootfs
		sudo sed -i -e "s/100/$[100+$i]/" $ROOT/pc$i.sse.ws.afnog.org/rootfs/etc/network/interfaces
	done
	lxc-autostart
