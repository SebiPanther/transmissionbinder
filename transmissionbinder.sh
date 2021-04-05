#!/bin/bash
network_device=eth0
source_file=/etc/transmission-daemon/settings.json

ip_addr=$(ifconfig $network_device | awk '$1 == "inet" {print $2}')

echo Curren IP of $network_device: $ip_addr

echo Stopping Service...
service transmission-daemon stop

echo Changing settings...
json=$(cat $source_file)
echo Old IP in $source_file: $(jq -r ".\"bind-address-ipv4\"" <<< $json)

jq ".\"bind-address-ipv4\" = \"$ip_addr\"" <<< $json > $source_file

echo New IP in $source_file: $(jq -r ".\"bind-address-ipv4\"" $source_file)

echo Starting Service...
service transmission-daemon start
