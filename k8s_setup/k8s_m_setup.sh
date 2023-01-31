#!/usr/bin/env bash
PRV_IP=$(ip -f inet addr show eth0| grep 'inet' | awk '{ print $2}' | cut -d "/" -f 1)
sudo kubeadm init --token 777777.7777777777777777 --apiserver-advertise-address=$(PRV_IP) --pod-network-cidr=172.16.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo apt-get -y install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl


echo "alias k=kubectl" | sudo tee -a $HOME/.bashrc
echo "complete -o default -F __start_kubectl k" | sudo tee -a $HOME/.bashrc
source $HOME/.bashrc 


sudo curl -O https://projectcalico.docs.tigera.io/manifests/calico.yaml 
sudo sed -i -e 's?192.168.0.0/16?172.16.0.0/16?g' calico.yaml
kubectl apply -f calico.yaml
