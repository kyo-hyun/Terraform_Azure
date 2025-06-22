#!/bin/bash
apt update
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
#mkdir /var/www/html/$(hostname)
echo $(hostname) > /var/www/html/index.html