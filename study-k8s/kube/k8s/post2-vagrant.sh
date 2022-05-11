#cd /etc/ansible &&  ansible-playbook  /kube/k8s/pre-install.yml
ansible all -a "swapoff -a"
#ansible all -a "sysctl net.bridge.bridge-nf-call-iptables=1 "
ssh node1 "sysctl net.bridge.bridge-nf-call-iptables=1 "
ssh node2 "sysctl net.bridge.bridge-nf-call-iptables=1 "
ssh master "sysctl net.bridge.bridge-nf-call-iptables=1 "


cat > /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {"max-size": "100m"}, "storage-driver": "overlay2"
}
EOF


bash copy_files.sh /etc/docker/daemon.json
#scp /etc/docker/daemon.json node1:/etc/docker/daemon.json
#scp /etc/docker/daemon.json node2:/etc/docker/daemon.json


