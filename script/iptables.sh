#!/bin/bash
apt update
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
echo $(hostname) > /var/www/html/index.html

# 즉시 반영
sudo sysctl -w net.ipv4.ip_forward=1

# 재부팅 후에도 유지되도록 설정
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

# 1. 기존 규칙 초기화 (필요시)
sudo iptables -F
sudo iptables -t nat -F

# 2. Forwarding 규칙: 모든 트래픽 허용 (eth1 -> eth0)
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT

# 3. NAT 설정: eth0를 통해 나가는 패킷의 소스 주소를 VM의 IP로 변환
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE