#!/bin/sh
LB_LOCATION=196.200.216.76
curl >/dev/null -v http://$LB_LOCATION:8080/tiles/tile-0.jpg http://$LB_LOCATION:8080/tiles/tile-1.jpg http://$LB_LOCATION:8080/tiles/tile-2.jpg
