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

	sudo apt install lxc

	mkdir -p ~/.config/lxc
	echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
	echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
	echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
	echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
	echo "$USER veth lxcbr0 2" | sudo tee -a /etc/lxc/lxc-usernet

	lxc-create --template debian --name debian8
	lxc-ls
	lxc-start --name debian8
