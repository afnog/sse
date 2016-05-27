# VM setup using LXC

Installed Ubuntu Desktop (not Server) 16.04 AMD64.

Following https://help.ubuntu.com/lts/serverguide/lxc.html:

	sudo apt install squid

Edit `/etc/squid/squid.conf` and add the following lines:

	# after this existing line:
	#acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
	# add these lines:
	acl localnet src 196.200.208.0/20
	http_access allow localnet

Then restart Squid

	sudo apt install lxc vlan

	mkdir -p ~/.config/lxc
	echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
	echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
	echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
	# echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
	echo "lxc.network.link = br0" >> ~/.config/lxc/default.conf
	# echo "$USER veth lxcbr0 2" | sudo tee -a /etc/lxc/lxc-usernet
	echo "$USER veth br0 2" | sudo tee -a /etc/lxc/lxc-usernet

	# https://help.ubuntu.com/lts/serverguide/network-configuration.html#bridging
	sudo apt install bridge-utils

Edit `/etc/network/interfaces` and make it look like this, to enable bridging for LXC containers:

	auto lo
	iface lo inet loopback

	auto br0
	iface br0 inet static
		# Please check the following values are appropriate for your network:
		address 196.200.223.144
		netmask 255.255.255.0
		gateway 196.200.223.1
		bridge_ports enp1s0f0
		bridge_fd 0
		bridge_hello 2
		bridge_maxage 12
		bridge_stp off

	iface enp1s0f0 inet static
		address 0.0.0.0

Then bring the interface down and up again:

	sudo ifdown enp1s0f0
	sudo ifup br0

Check that you can access the Internet, and then reboot the box and check that it comes up OK.

	# lxc-create --template debian --name debian8
	lxc-create -t download -n debian8 -- --dist debian --release jessie --arch i386
	lxc-ls
	chmod a+x .local
	chmod a+x .local/share
	lxc-start --name debian8
	lxc-attach --name debian8

Now we can setup the guest:

	adduser afnog
	apt install nano sudo openssh-server vim ping
	usermod -G sudo afnog

You should now be able to SSH in as user `afnog` to complete the installation:

	sudo vi /etc/network/interfaces

Make it look like this:

	auto lo
	iface lo inet loopback

	auto eth0
	iface eth0 inet static
		# Please check the following values are appropriate for your network:
		address 196.200.219.101
		netmask 255.255.255.0
		gateway 196.200.219.1
