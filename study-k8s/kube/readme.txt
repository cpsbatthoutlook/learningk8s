##Vagrant download   
https://download.virtualbox.org/virtualbox/6.1.2/VirtualBox-6.1-6.1.2_135662_el7-1.x86_64.rpm

apt-get -y update && apt-get install -y apt-transport-https
# Ensure iptables tooling does not use the nftables backend

apt-get install -y iptables arptables ebtables
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

#Install Docker, kubelet, adm, ctl, ansible #Refer YAML


#https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF


kubeadm init --pod-network-cidr=192.168.56.0/16 --apiserver-advertise-address=192.168.56.110

#run Kubectl tool configuration
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

##POD Network overlay  :  https://kubernetes.io/docs/concepts/cluster-administration/addons/
#Calico CNI  #https://medium.com/@Alibaba_Cloud/how-to-install-and-deploy-kubernetes-on-ubuntu-16-04-6769fd1646db
kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml


##Join nodes
kubeadm join 192.168.0.15:6443 --token rz8tqj.5y735c7lv94ezvtf     --discovery-token-ca-cert-hash sha256:990cd2990cc933cefa8d08e802a9a93712bac01b47a4b78a489c43c8f3ab41b7