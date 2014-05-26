#!/bin/sh

echo "This exercise will layer7 lb connections to 2 backend servers in a round robin fashion"
haproxy -V -db -f haproxy.conf
