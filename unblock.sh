#!/bin/sh

echo "Deleting old routes"
ndmc -c "show ip route" | grep Wireguard0 | awk ' { print "ndmc -c \"no ip route", $1, "\"" }'  | awk '{system($0)}'

echo "Adding new routes"
while read -r addr || [ -n "$addr" ]; do

  [ -z "$addr" ] && continue
  [ "${addr:0:1}" = "#" ] && continue

  for ipaddr in $(nslookup "$addr" | grep -v localhost | grep -v "::" | grep Address | awk '{print $3}' ); do
    echo "ip route $ipaddr/32 Wireguard0 !$addr" | awk ' { print "ndmc -c \"", $0, "\"" } ' | awk ' { system($0) } '
  done
done < /storage/unblocker/unblock.txt
