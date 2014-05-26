#!/bin/sh

echo "This exercise will layer7 lb connections to 2 backend servers in a round robin fashion. Connections will be stuck to one server"
haproxy -V -db -f haproxy.conf
