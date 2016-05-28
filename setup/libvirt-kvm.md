# VM setup using Libvirt and KVM

Using Ubuntu 16.04. Follow [server.md] first to configure the server.

Install libvirt and KVM:

	sudo apt install libvirt-bin qemu-kvm virtinst libosinfo-bin
	osinfo-query os

	sudo virt-install --connect qemu:///system     --virt-type kvm --name SSE-Gold \
		--os-variant=debian8 --ram 512 --vcpus 1 --disk path=SSE-Gold.img,size=20 \
		--cdrom iso/debian-8.4.0-i386-DVD-1.iso --network=bridge=br0 \
		--graphics type=vnc,port=5901,listen=0.0.0.0,password=foo

Connect to the server using a VNC client to complete the installation. E.g. 196.200.223.144:5901.

During installation, say Yes to using a network mirror, and set the HTTP proxy to
http://196.200.223.144:3142/. For Software Selection, enable only SSH Server and
standard system utilities, disable the desktop.

Following https://help.ubuntu.com/lts/serverguide/lxc.html, but modified for VLAN bridging:

	sudo apt install lxc

	mkdir -p ~/.config/lxc
	echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
	echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
	echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
	echo "lxc.network.link = br0" >> ~/.config/lxc/default.conf
	echo "lxc.start.auto = 1" >> ~/.config/lxc/default.conf
	# Allow up to 60 unprivileged users to use br0 as a veth (bridged network) device:
	echo "$USER veth br0 60" | sudo tee -a /etc/lxc/lxc-usernet

Create a gold master server:

	# lxc-create --template debian --name debian8
	lxc-create -t download -n debian8 -- --dist debian --release jessie --arch i386
	lxc-ls --fancy
	chmod a+x .local
	chmod a+x .local/share
	lxc-start --name debian8
	lxc-attach --name debian8

Follow [guest.md] to configure the gold master guest.

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