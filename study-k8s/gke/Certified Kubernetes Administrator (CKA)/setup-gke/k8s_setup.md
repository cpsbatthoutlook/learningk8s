## Building a Kubernetes 1.27 Cluster with kubeadm
```
You have been provided with three "Ubuntu 20.04.5 LTS" servers. Build a simple Kubernetes cluster with one control plane node and two worker nodes.

Install and use kubeadm to build a Kubernetes cluster on these servers.
Install Kubernetes version 1.27.0.
Use containerd for your container runtime.
The cluster should have one control plane node and two worker nodes.
Use the Calico networking add-on to provide networking for the cluster.
```

### Common

```
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay # containerd config
modprobe br_netfilter
```

```
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system #K8s network
```


```
##Install containerd
apt-get update && apt-get install -y containerd.io
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd
systemctl status containerd
swapoff -a
# Install dependencies
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update
apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00
apt-mark hold kubelet kubeadm kubectl ##Turn off auto-update
```


### On Control plane
Install k8s
```
## issue to be resolved:
apt remove containerd && apt update && apt install containerd.io && rm /etc/containerd/config.toml && systemctl restart containerd
kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.27.0  ## Errors "unknown service runtime.v1.RuntimeService"
USER=cloud_user
HOME=/home/${USER}
su - $USER
mkdir -p $HOME/.kube
su - 
cp -i /etc/kubernetes/admin.conf ${USER}/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
su - cloud_user
kubectl cluster-info ; kubectl get all 
```
Install Calico networking
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
kubectl get nodes
kubeadm token create --print-join-command
```
### On Worker nodes
```
kubeadm join 10.0.1.101:6443 --token wix2j4.up55f34zk02c6cdk \
        --discovery-token-ca-cert-hash sha256:12112518b874995c72d31fdbff3952e176e2c4d5cc029ea3ca3813291932cd33
## Errors of validate service connection: CRI v1 ru
apt remove containerd && apt update && apt install containerd.io && rm /etc/containerd/config.toml && systemctl restart containerd
kubectl get nodes
```