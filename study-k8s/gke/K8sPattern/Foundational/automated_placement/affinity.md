[ GKE Notes ](https://cloud.google.com/kubernetes-engine/docs/how-to/gke-zonal-topology)


kc describe node nodenmae 
                    topology.kubernetes.io/region=us-central1
                    topology.kubernetes.io/zone=us-central1-c

 kc get nodes gke-cpsbatth-cluster-default-pool-f1bcd934-22lr -o template --template={{.metadata.labels}}
 kc get nodes gke-cpsbatth-cluster-default-pool-f1bcd934-22lr > /tmp/2.json ;  cat /tmp/2.json  | jq .metadata.labels

Preset labels
The preset labels that Kubernetes sets on nodes are:

kubernetes.io/arch
kubernetes.io/hostname
kubernetes.io/os
node.kubernetes.io/instance-type (if known to the kubelet – Kubernetes may not have this information to set the label)
topology.kubernetes.io/region (if known to the kubelet – Kubernetes may not have this information to set the label)
topology.kubernetes.io/zone (if known to the kubelet – Kubernetes may not have this information to set the label)
