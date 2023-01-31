#!/usr/bin/env bash

sudo hostnamectl set-hostname master-k8sHo

PRI_IP=$(ip -f inet addr show eth0| grep 'inet' | awk '{ print $2}' | cut -d "/" -f 1)
echo " [Private IP] $PRI_IP"

cat <<EOF | sudo tee -a /etc/resolv.conf
nameserver 1.1.1.1 
nameserver 8.8.8.8 
EOF

sudo apt-get update
sudo apt-get install \
   ca-certificates \
   curl \
   gnupg \
   lsb-release 
  
sudo apt-get install -y net-tools

#sudo systemctl stop firewalld
#sudo systemctl disable firewalld
sudo ufw disable

# echo "$PRI_IP master-k8sHo" | sudo tee -a /etc/hosts
# for (( i=1; i<=3; i++  )); do echo "192.168.0.10$i worker$i-k8sHo" | sudo tee -a /etc/hosts; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# docker is unnecessary but installed to use
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

#sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml 
sudo systemctl restart containerd

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

#-----------------------------------------------------------------------------------------
# The commented out code is unnecessary, but I wrote it
#
#
# #sudo mkdir /etc/docker
# cat <<EOF | sudo tee /etc/docker/daemon.json
# {
#    "exec-opts": ["native.cgroupdriver=systemd"],
#    "log-driver": "json-file",
#    "log-opts": {
#       "max-size": "100m"
#    },
#    "storage-driver": "overlay2"
# }
# EOF

# sudo systemctl enable docker
# sudo systemctl start docker

# sudo mkdir -p /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt-get install containerd.io
#-----------------------------------------------------------------------------------------


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.25.0-00 kubeadm=1.25.0-00 kubectl=1.25.0-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl restart kubelet

sudo kubeadm init --token 777777.7777777777777777 --pod-network-cidr=172.16.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo apt-get -y install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl


echo "alias k=kubectl" | sudo tee -a $HOME/.bashrc
echo "complete -o default -F __start_kubectl k" | sudo tee -a $HOME/.bashrc
source $HOME/.bashrc 
sudo systemctl kubelet restart

sudo curl -O https://projectcalico.docs.tigera.io/manifests/calico.yaml 
sudo sed -i -e 's?192.168.0.0/16?172.16.0.0/16?g' calico.yaml
kubectl apply -f calico.yaml
sudo su
