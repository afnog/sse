# VM setup using LXC

Using Ubuntu 16.04. Follow [server.md] first to configure the server.

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

Now we can setup the guest:

	adduser afnog
	apt install nano sudo openssh-server vim ping
	usermod -G sudo afnog
	ifconfig 
	# Get the IP address assigned by the DHCP server

You should now be able to SSH in as user `afnog` to complete the installation. 

	ssh afnog@<dynamic-ip>

Sudo edit `/etc/network/interfaces` and make it look like this:

	auto lo
	iface lo inet loopback

	auto eth0
	iface eth0 inet static
		# Please check the following values are appropriate for your network:
		address 196.200.219.100
		netmask 255.255.255.0
		gateway 196.200.219.1

Restart networking (on the guest) and reconnect using the new IP (196.200.219.100).

Copy an SSH key into the guest:

	scp ~/.ssh/id_rsa.pub afnog@196.200.219.100:.ssh/authorized_keys

Sudo edit `/etc/apt/apt.conf.d/01proxy` and add:

	Acquire::http::Proxy "http://196.200.219.2:3142";

Check that you can run `apt update` on the guest.

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
