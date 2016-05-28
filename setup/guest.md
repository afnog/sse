# Guest Configuration

Using Debian 8 (Jessie). Setup the guest for AfNOG, starting from a (virtual) console:

	adduser afnog
	apt install nano sudo openssh-server vim iputils-ping
	usermod -G sudo afnog
	ifconfig 
	# Get the IP address assigned by the DHCP server

You should now be able to SSH in as user `afnog` to complete the installation. 

	ssh afnog@<dynamic-ip>
	mkdir .ssh
	sudo mkdir /root/.ssh

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
	ssh afnog@196.200.219.100 sudo cp .ssh/authorized_keys /root/.ssh/authorized_keys

(Unless already present in `/etc/apt/apt.conf`:) sudo edit `/etc/apt/apt.conf.d/01proxy` and add:

	Acquire::http::Proxy "http://196.200.219.2:3142";

Run `apt update` and `apt upgrade` on the guest.

