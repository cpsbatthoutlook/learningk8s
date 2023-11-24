## Control Plane HA
multiple Control plane [CP] nodes accessed via LB & kubelet talks to LB end point to connect with cluster
etcd design pattern for multi-CP:
* every CP has its own etcd
* external etcd on multiple nodes 

## Mgmt tools
* kubectl: official cmd line option.
* kubeadm: for k8s clusters
* helm:  templating/pkg mgmt for k8s objects
* minikube: single-node k8s cluster.
* kompose: Xlate Docker compose files > k8s objects
* Kustomize: similar to helm, config mgmt tool for managing k8s object configurations


## Upgrade the k8s nodes
 Upgrade all Kubernetes components on all three servers to Kubernetes version 1.27.2.

### Draining k8s nodes
gracefully terminate pods
```
kc cordon <node>  #rejet pods to run
kc drain <node> --ignore-daemonsets --force
kc uncordon <node> #allow pods to run

```

### Control plane

```
kc get nodes 
ka version
kc drain k8s-control --ignore-daemonset

sudo su - 
 apt-get update && \
 apt-get install -y --allow-change-held-packages kubeadm=1.27.2-00
 apt-get install -y --allow-change-held-packages kubelet=1.27.2-00 kubectl=1.27.2-00

 ka upgrade plan v1.27.2 && ka upgrade apply v1.27.2
 sctl daemon-reload &&  sctl restart kubelet
 kc uncordon k8s-control
 
```

### Nodes

```

sudo su - 
 apt-get update && \
 apt-get install -y --allow-change-held-packages kubeadm=1.27.2-00
 apt-get install -y --allow-change-held-packages kubelet=1.27.2-00 kubectl=1.27.2-00

kc drain k8s-worker1 --ignore-daemonset
 ka upgrade plan v1.27.2 && ka upgrade apply v1.27.2
 sctl daemon-reload &&  sctl restart kubelet
 kc uncordon k8s-worker1 k8s-worker12
```

### Backing up etcd
if lost, all the k8s configurations/object have to be created by hand

```
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save file1
ETCDCTL_API=3 etcdctl snapshot restore file1
```

#### Lab

* Look up the value for the key cluster.name in the etcd cluster:
```
ETCDCTL_API=3 etcdctl get cluster.name \
  --endpoints=https://10.0.1.101:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key
```
* Backup etcd and provide certificate
```
ETCDCTL_API=3 etcdctl snapshot save /home/cloud_user/etcd_backup.db \
  --endpoints=https://10.0.1.101:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key
```
* Reset etcd by removing all data
```
 systemctl stop etcd &&  rm -rf /var/lib/etcd
```

* Restore data: first in a temp etcd cluster
```
sudo ETCDCTL_API=3 etcdctl snapshot restore /home/cloud_user/etcd_backup.db \
  --initial-cluster etcd-restore=https://10.0.1.101:2380 \
  --initial-advertise-peer-urls https://10.0.1.101:2380 \
  --name etcd-restore   --data-dir /var/lib/etcd

chown -R etcd:etcd /var/lib/etcd
sctl start etcd

ETCDCTL_API=3 etcdctl get cluster.name \
  --endpoints=https://10.0.1.101:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key
```




```




