#!/bin/sh

LB_LOCATION=196.200.216.76

# No cookies sent back
echo "Testing with stateless connections that do not use a cookie"
curl >/dev/null -v http://$LB_LOCATION:8080/tiles/tile-0.jpg http://$LB_LOCATION:8080/tiles/tile-1.jpg http://$LB_LOCATION:8080/tiles/tile-2.jpg


echo
echo "########################################################"
echo "Testing with stateful connections that do use cookie"
echo "########################################################"
echo
curl >/dev/null --cookie-jar tamutamu --cookie tamutamu -v http://$LB_LOCATION:8080/tiles/tile-0.jpg http://$LB_LOCATION:8080/tiles/tile-1.jpg http://$LB_LOCATION:8080/tiles/tile-2.jpg
