#!/bin/bash
apt-get update
apt-get install -y iptables-persistent
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# NAT 설정
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# iptables 저장
sh -c 'iptables-save > /etc/iptables/rules.v4'

# iptables 서비스 활성화
systemctl enable netfilter-persistent
systemctl start netfilter-persistent