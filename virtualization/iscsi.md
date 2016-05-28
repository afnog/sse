# Install iSCSI Target on Debian Jessie

From [http://www.server-world.info/en/note?os=Debian_8&p=iscsi]:

	apt install iscsitarget iscsitarget-dkms
	dd if=/dev/zero of=/iscsi_disks/disk01.img count=0 bs=1 seek=8G

Sudo edit `/etc/default/iscsitarget` and set:

	ISCSITARGET_ENABLE=true

Sudo edit `/etc/iet/ietd.conf` and add the following lines:

Target iqn.1992-01.com.example:target00
    # provided devicce as a iSCSI target
    Lun 0 Path=/iscsi_disks/disk01.img,Type=fileio
    # iSCSI Initiator's IP address you allow to connect
    initiator-address 196.200.219.131
    # authentication info ( set anyone you like for "username", "password" )
    incominguser username password


