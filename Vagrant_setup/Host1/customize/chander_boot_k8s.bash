#!/bin/bash

echo "Running here" && sudo ip route change default via 192.168.0.1
#sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf
echo sudo service systemd-resolved restart &&  sudo service systemd-resolved restart && echo sudo ifconfig enp0s3 down
sudo ifconfig enp0s3 down && echo Good

