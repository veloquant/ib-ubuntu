#!/bin/bash
set -e

Xvfb $DISPLAY -ac -screen 0 1024x768x24 &

LATEST_GATEWAY_VER=`find Jts/ibgateway/ -maxdepth 1 -type d | grep -oP '\d+$' | sort -d | tail -1`
DOCKER_HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`
echo '[IBGateway]' > ~/Jts/jts.ini
echo "TrustedIPs=127.0.0.1,${DOCKER_HOST_IP}" >> ~/Jts/jts.ini

x11vnc -ncache 10 -ncache_cr -display $DISPLAY -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6
/opt/ibc/scripts/ibcstart.sh $LATEST_GATEWAY_VER -g --ibc-ini=/opt/ibc/config.ini --user=${IB_USER} --pw=${IB_PW}
cat ~/Jts/jts.ini
