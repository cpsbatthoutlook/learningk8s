Baremetal journey: Kis

https://richard-nunez.medium.com/my-journey-to-kubernetes-onto-bare-metal-part-3-utilities-7f4aac4c111b

## Setup a NFS Server
## Install Helm and Add repo
   helm repo add bitnami  https://charts.bitnami.com/bitnami
   helm repo add stable   https://kubernetes-charts.storage.googleapis.com
   helm repo add loki     https://grafana.github.io/loki/charts
   helm repo add gitlab   https://charts.gitlab.io/
   helm repo add halkeye  https://halkeye.github.io/helm-charts

##    Namespace - nfs-client
##     Helm : nfs-client-provisioner : helm install nfs-client stable/nfs-client-provisioner --set nfs.server=192.168.0.121 --set nfs.path=/k8s_share/vol1 --namespace nfs-client
##
##
