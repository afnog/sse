#!/bin/bash

for i in {1..40}; do
	hostname=pc$i.sse.ws.afnog.org
	ipaddr=196.200.219.$[200+$i]

	macaddr=`echo $hostname | md5sum | sed -e 's/^\(..\)\(..\)\(..\)\(..\).*/5254.\1\2.\3\4/'`
	cat <<EOF
ip dhcp pool $hostname
 host $ipaddr
 hardware-address $macaddr
 client-name $hostname
EOF
done

exit 0
