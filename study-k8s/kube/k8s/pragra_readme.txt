  #All nodes
bash /kube/k8s/prepare-k8s.sh
ansible-playbook /kube/k8s/pre-install.yml
bash /kube/k8s/post1-vagrant.sh
bash /kube/k8s/post2-vagrant.sh

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.0.177

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')

kubeadm token create --print-join-command > ~/join.sh
/kube/k8s/copy_files.sh /root/join.sh
ssh node1 /root/join.sh
ssh node2 /root/join.sh

bash /kube/k8s/post-k8s.sh


===========================================================

  ## Docker cGroup issue (to be checked)
  #https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
  # Setup daemon.
  cat > /etc/docker/daemon.json <<EOF
  {
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {"max-size": "100m"}, "storage-driver": "overlay2" 
  }
  EOF

  sysctl -a
  sysctl net.bridge.bridge-nf-call-iptables=1
  kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.0.181 ## as oer https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  alias kc=kubectl
  kc cluster-info
      Kubernetes master is running at https://192.168.0.181:6443
      KubeDNS is running at https://192.168.0.181:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

  ##network https://kubernetes.io/docs/concepts/cluster-administration/addons
  on master, node1, node2
  cd /tmp && wget https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
  kubectl apply -f kube-flannel.yml

##Weave
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

  ##Join cluster
  ansible nodes -m script -a "/tmp/join.sh executable:/bin/bash"
  ansible all -m service -a "name=docker enabled=true"

  ##Ops view ## https://kubernetes-operational-view.readthedocs.io/en/latest/getting-started.html
  go to master
  git clone https://github.com/hjacobs/kube-ops-view.git
  kc apply -f /home/ubuntu/kube-ops-view/deploy
  kc proxy --address=192.168.0.181 --port=8888
  Access http://192.168.0.181:8888/api/v1/proxy/namespaces/default/services/kube-ops-view/

##Dashboard  https://github.com/kubernetes/dashboard#kubernetes-dashboard
curl -o dashboard.yaml  https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc3/aio/deploy/recommended.yaml
kc apply -f dashboard.yaml
kc  edit svc kubernetes-dashboard -n kubernetes-dashboard ##change to NodePort
try http://192.168.0.181:32536/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/




  ## Logs of kubeadm join 
  [preflight] Running pre-flight checks
          [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
  [preflight] Reading configuration from the cluster...
  [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
  [kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.17" ConfigMap in the kube-system namespace
  [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
  [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
  [kubelet-start] Starting the kubelet
  [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

  This node has joined the cluster:
  * Certificate signing request was sent to apiserver and a response was received.
  * The Kubelet was informed of the new secure connection details.

  Run 'kubectl get nodes' on the control-plane to see this node join the cluster



  ## Output Service and POD NEtwork details
  root@master:/tmp# kubectl -n kube-system get cm kubeadm-config -oyaml
  apiVersion: v1
  data:
    ClusterConfiguration: |
      apiServer:
        extraArgs:
          authorization-mode: Node,RBAC
        timeoutForControlPlane: 4m0s
      apiVersion: kubeadm.k8s.io/v1beta2
      certificatesDir: /etc/kubernetes/pki
      clusterName: kubernetes
      controllerManager: {}
      dns:
        type: CoreDNS
      etcd:
        local:
          dataDir: /var/lib/etcd
      imageRepository: k8s.gcr.io
      kind: ClusterConfiguration
      kubernetesVersion: v1.17.2
      networking:
        dnsDomain: cluster.local
        podSubnet: 10.244.0.0/16
        serviceSubnet: 10.96.0.0/12
      scheduler: {}
    ClusterStatus: |
      apiEndpoints:
        master:
          advertiseAddress: 192.168.0.181
          bindPort: 6443
      apiVersion: kubeadm.k8s.io/v1beta2
      kind: ClusterStatus
  kind: ConfigMap
  metadata:
    creationTimestamp: "2020-02-04T23:00:59Z"
    name: kubeadm-config
    namespace: kube-system
    resourceVersion: "150"
    selfLink: /api/v1/namespaces/kube-system/configmaps/kubeadm-config
    uid: 7f4209ff-a3e3-4931-9d3f-08e453b6088f

