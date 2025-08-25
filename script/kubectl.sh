#!/bin/bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p /home/khkim/bin
cp ./kubectl /home/khkim/bin/kubectl
export PATH=/home/khkim/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> /home/khkim/.bashrc
chown -R khkim:khkim /home/khkim

# az cli 설치
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Helm 스크립트 설치
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# 스크립트에 실행 권한 부여
chmod 700 get_helm.sh

# Helm 설치
./get_helm.sh

# Helm 저장소 추가
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# 저장소 업데이트
helm repo update