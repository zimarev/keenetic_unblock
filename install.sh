#!/bin/sh

echo "Installing packages"
opkg update
opkg install busybox cron wget

echo "Creating directory structure"
cd /storage || echo "Directory /storage not found" && exit
mkdir unblocker

echo "Downloading files"
wget -O /storage/unblocker/unblock.txt https://raw.githubusercontent.com/zimarev/keenetic_unblock/master/unblock.txt
wget -O /storage/unblocker/unblock.sh https://raw.githubusercontent.com/zimarev/keenetic_unblock/master/unblock.sh
chmod +x /storage/unblocker/unblock.sh

echo "Creating link to cron"
ln -s /storage/unblocker/unblock.sh /opt/etc/cron.hourly/unblock.sh

echo "Starting cron and script itself"
/bin/sh /opt/etc/cron.hourly/unblock.sh
/opt/etc/init.d/S10cron start

echo "DONE"
