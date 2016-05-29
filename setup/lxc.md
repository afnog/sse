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

Create a gold master guest image:

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

Ensure that systemd gives [sufficient tasks](http://unix.stackexchange.com/questions/253903/creating-threads-fails-with-resource-temporarily-unavailable-with-4-3-kernel)
to LXC containers started by `at`, by editing `/etc/systemd/system.conf`, uncommenting `DefaultTasksMax` and setting it to at least 12288.

Stop the container and make a lot of copies:

	lxc-stop --name debian8 -t 30
	NUM_PCS=30
	LXC_ROOT=/home/inst/.local/share/lxc
	for i in `seq 1 $NUM_PCS`; do
		hostname=pc$pc
		domainname=$hostname.sse.ws.afnog.org
		lxc-copy --name debian8 --newname $hostname
		macaddr=`openssl rand -hex 4 | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:56:\1:\2:\3:\4/'`
		echo "lxc.network.hwaddr = $macaddr" >> $LXC_ROOT/pc$i.sse.ws.afnog.org/config
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
