
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/drupal

# https://artifacthub.io/packages/helm/bitnami/drupal


## Require NFS Server with External Provisioner  { https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner }
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=192.168.0.121     --set nfs.path=/k8s_share
