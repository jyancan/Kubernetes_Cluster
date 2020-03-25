#!/bin/bash
export HTTPS_PROXY=http://10.30.17.74:443
yum update -y
yum -y install epel-release
yum -y install figlet

figlet MASTER

echo "[TASK 1] Add hosts to etc/hosts"
cat >>/etc/hosts<<EOF
10.66.30.11 kubemaster1
10.66.30.12 kubework1
10.66.30.13 kubework2
10.66.30.14 kubework3
10.66.30.15 kubework4
EOF

echo "[TASK 2] Disable SELINUX"
sed -i -e s/enforcing/disabled/g /etc/sysconfig/selinux
sed -i -e s/permissive/disabled/g /etc/sysconfig/selinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "[TASK 3] Disable Firewall"
systemctl disable firewalld
systemctl stop firewalld

echo "[TASK 4] Update iptables"
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "[TASK 5] Disable Swap"
swapoff -a && sed -i '/swap/d' /etc/fstab

echo "[TASK 6] Install Docker"
yum install -y yum-utils nfs-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install containerd.io
#https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum install -y docker-ce docker-ce-cli

echo "[TASK 7] Add Kubernetes Repositories"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "[TASK 8] Install kubelet/kubeadm/kubectl"
yum install -y kubelet kubeadm kubectl

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
