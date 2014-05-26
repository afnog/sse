#!/bin/sh
set -e
SERVER_ID=$(pwd | egrep -o "[0-9]$")
PORT=$(($SERVER_ID + 8000))
IP_ADDR=$(ifconfig | grep "inet.*broadcast" | awk '{print $2}' | head -n 1)
echo "Starting an HTTP server on port $PORT. Browse the URL http://$IP_ADDR:$PORT to access this server directly."
python -m SimpleHTTPServer $PORT
