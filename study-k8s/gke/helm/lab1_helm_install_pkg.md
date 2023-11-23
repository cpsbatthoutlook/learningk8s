# LEARNING OBJECTIVES
Login to k8s primary node and install helm, deploy a pkg, and clearnup
## Install and Configure Helm
- ssh cloud_user@ 
- cd /tmp && wget https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz && tar xfz helm*.tar.gz 
- mv linux*/helm /usr/local/bin && chmod 755 /usr/local/bin/helm 

## Add repo & install pkg
- helm repo add bitnami https://charts.bitnami.com/bitnami 
- helm repo update bitnami 
## Create a Helm Release
- helm install test bitnami/wordpress

## Verify the Release and Clean Up
- helm show values bitnami/wordpress
- helm history|status test
- helm uninstall test pkg1