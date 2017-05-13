---
vim: autoread
jekyll: process
layout: default
root: ../..
---

# VM setup using LXC

Using Ubuntu 16.04. Follow [server setup](../server/index.html) first to configure the server.

Following https://help.ubuntu.com/lts/serverguide/lxc.html, but modified for VLAN bridging:

	sudo apt install lxc

	mkdir -p ~/.config/lxc
	LXC_DEFAULTS=~/.config/lxc/default.conf
	echo "lxc.id_map = u 0 100000 65536" > $LXC_DEFAULTS
	echo "lxc.id_map = g 0 100000 65536" >> $LXC_DEFAULTS
	echo "lxc.network.type = veth" >> $LXC_DEFAULTS
	echo "lxc.network.link = br0" >> $LXC_DEFAULTS
	echo "lxc.start.auto = 1" >> $LXC_DEFAULTS
	# Limit RAM used by containers:
	echo 'lxc.cgroup.memory.limit_in_bytes = 512M' >> $LXC_DEFAULTS
	echo 'lxc.cgroup.memory.memsw.limit_in_bytes = 1G' >> $LXC_DEFAULTS

	# Allow up to 60 unprivileged users to use br0 as a veth (bridged network) device:
	echo "$USER veth br0 60" | sudo tee -a /etc/lxc/lxc-usernet

Disable the lxc-net `dnsmasq` to stop it binding to port 67, preventing our own `dnsmasq`
from doing the same, by editing `/etc/default/lxc-net` and setting:

	USE_LXC_BRIDGE="false"

Create `/etc/dnsmasq.d/afnog` with the following contents:

	server=<your host IP address>
	interface=br0
	dhcp-range=196.200.219.20,196.200.219.80,12h

Edit `/etc/default/grub` and set:

	GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"

as seen [here](https://github.com/docker/docker/issues/4250#issuecomment-35566530), 
otherwise the `lxc.cgroup.memory.memsw.limit_in_bytes` setting will not work, and will prevent
you from starting any LXC containers. 

For this to work, you also need to edit `/etc/pam.d/common-session*, find the lines for
`pam_cgso.so` and add `,devices` to the end, as described
[here](http://comments.gmane.org/gmane.linux.kernel.containers.lxc.general/11395), like this:

	session optional        pam_cgfs.so -c freezer,memory,name=systemd,devices

Then `sudo update-grub` and `sudo reboot` to activate swap accounting.

Create a gold master guest image. According to the
[LXC documentation](https://linuxcontainers.org/lxc/getting-started/), "most
distribution templates simply won't work with (unprivileged containers).
Instead you should use the "download" template which will provide you with
pre-built images of the distributions that are known to work in such an
environment."

	lxc-create -t download -n debian8 -- --dist debian --release jessie --arch i386
	lxc-ls --fancy
	chmod a+x .local
	chmod a+x .local/share
	lxc-start --name debian8
	lxc-attach --name debian8

Follow [guest setup](../guest/index.html) to configure the gold master guest.

Add the following line to `/etc/sysctl.conf` on the host, to ensure that the host kernel
[allows sufficient AIO handles](http://unix.stackexchange.com/questions/116520/mysql-server-wont-install-to-a-new-os-debian-ubuntu)
for all the guests to run MySQL InnoDB:

	fs.aio-max-nr = 1000000

Edit your user's crontab and add the following line to make your containers auto-start:

	@reboot lxc-autostart

Ensure that systemd on the host gives
[sufficient tasks](http://unix.stackexchange.com/questions/253903/creating-threads-fails-with-resource-temporarily-unavailable-with-4-3-kernel)
to LXC containers started by `at` and `cron`, by editing `/etc/systemd/system.conf`,
uncommenting `DefaultTasksMax` and setting it to at least 12288.
See [here](https://news.ycombinator.com/item?id=11675133) for more information on this problem.

The following commands are useful for dealing with `systemd` and control groups:

* `systemd-cgls`
* `systemd-cgtop`
* `systemctl`
* `systemctl list-jobs`
* `systemctl status`
* `systemctl show`
* `/sys/fs/cgroup/memory/user/inst/*/lxc`
* `journalctl`
* `journalctl -f`
* `systemctl cancel`

You may also have issues logging into `sshd` with password authentication due to 
[this issue](https://github.com/lxc/lxc/issues/661#issuecomment-222444916). The solution
is to edit `/etc/pam.d/sshd` and `/etc/pam.d/cron` in the guest, find the line that says:

	session    required     pam_loginuid.so

and change it to:

	session    optional     pam_loginuid.so

And there is an issue with
[systemd, dbus and OOM_ADJUST in the container](https://github.com/systemd/systemd/issues/719#issuecomment-223057529)
which requires us to comment-out the `OOMScoreAdjust=-900` line in `/lib/systemd/system/dbus.service`. The `dbus` package
is not installed by default, so this file does not exist, but installing certain applications (e.g. `mutt`) will
install it and break the system. Even a simple `apt install dbus` hangs during package installation,
and it can't be safely removed either.

Since we cannot preconfigure `dbus` (because `dbus.service` is overwritten on package installation) and 
we cannot easily fix the problem in `systemd` (as the actual change that fixes the issue has not been
identified), we prevent the installation of `dbus` in all containers instead, by creating 
`/etc/apt/preferences.d/no-dbus.pref` (in the gold image) with these contents:

	# https://github.com/systemd/systemd/issues/719#issuecomment-223057529
	# http://askubuntu.com/questions/75895/how-to-forbid-a-specific-package-to-be-installed

	Package: dbus 
	Pin: version *
	Pin-Priority: -1

	Package: dbus:amd64
	Pin: version *
	Pin-Priority: -1

Stop the container and make a lot of copies:

	lxc-stop --name debian8 -t 30
	NUM_PCS=40
	LXC_ROOT=/home/inst/.local/share/lxc
	for i in `seq 1 $NUM_PCS`; do
		hostname=pc$i
		domainname=$hostname.sse.ws.afnog.org
		lxc-copy --name debian8 --newname $hostname
		macaddr=`openssl rand -hex 4 | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/52:56:\1:\2:\3:\4/'`
		echo "lxc.network.hwaddr = $macaddr" >> $LXC_ROOT/pc$i/config
	done
	lxc-autostart

To run a command on all containers (for example `hostname`):

	for i in `seq 1 $NUM_PCS`; do
		hostname=pc$pc
		domainname=$hostname.sse.ws.afnog.org
		lxc-attach -n $hostname -- hostname
	done

Give them all unique IP addresses by doing this with:

	lxc-attach -n $hostname -- sed -e "s/196.200.219.100/196.200.219.$[i+100]/" /etc/network/interfaces

Optional: time how long it takes for them all to start completely (enough to get an IP address):

	lxc-autostart -k -t 5
	lxc-autostart & time while lxc-ls --fancy | awk '{ print $5 }' | grep -q -- -; do sleep 1; done

And try to reduce it with unionfs mounts (experimental). This caused some issues: in particular locking
in /var/mail did not work with Dovecot, and modifying the underlying filesystem after creating the
union mounts (removing a package) resulted in inconsistencies between the package database and the files
visible in the cloned PCs, so best avoided. It's probably worth checking out
[overlayfs](https://www.flockport.com/experimenting-with-overlayfs-and-lxc/) and 
[btrfs subvolumes](https://www.flockport.com/supercharge-lxc-with-btrfs/) for future deployments.

	lxc-autostart -k -t 5
	LXC_ROOT=/home/inst/.local/share/lxc
	for i in `seq 1 $NUM_PCS`; do
		hostname=pc$pc
		domainname=$hostname.sse.ws.afnog.org
		sudo umount $LXC_ROOT/$hostname/rootfs
		test -d $LXC_ROOT/$hostname/rootfs.orig || mv $LXC_ROOT/$hostname/rootfs{,.orig}
		mkdir -p $LXC_ROOT/$hostname/rootfs{,.rw}

		echo "none $LXC_ROOT/$hostname/rootfs" \
			"aufs br=$LXC_ROOT/$hostname/rootfs.rw=rw:$LXC_ROOT/debian8/rootfs=ro 0 0" \
		| sudo tee -a /etc/fstab

		sudo mount $LXC_ROOT/$hostname/rootfs
		sudo sed -i -e "s/100/$[100+$i]/" $LXC_ROOT/$hostname/rootfs/etc/network/interfaces
		echo $domainname | sudo tee $LXC_ROOT/$hostname/rootfs/etc/hostname

		# Dovecot has problems locking the mailbox when hosted on AUFS. Work around it
		# by mounting a ramdisk for /var/mail in all containers:
		echo 'none /var/mail tmpfs defaults 0 0' | sudo tee -a $LXC_ROOT/$hostname/rootfs/etc/fstab
		lxc-start -n $hostname
	done
	lxc-autostart
