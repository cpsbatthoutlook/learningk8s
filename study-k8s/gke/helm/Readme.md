
[ Helm deep dive 3 - Package mgmt ]( https://learn.acloud.guru/course/helm-deep-dive-v3/dashboard )

# Why Helm
* Release tracking
* Least Invasive changes : Only alter subset of who changes, doesn't tear down whole package
* Running vs Desired state
* Helm Charts : Define k8s components along with config to instantiate a released object

- depends on kubectl for k8s mgmt, RBAC rules impact

# Charts
[ Chart structure ](https://helm.sh/docs/topics/charts/)
* _*.tpl or _*.yaml will not produce output to manifest files

## Why Charts [ values + templates ]
* Reusability
* Pluggable
* Versatality: no hardcore version or requirements
* Maintanability


# Setup GKE Cluster
```
export GCLOUD_PROJECT=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export INSTANCE_ZONE=us-central1-c
export PROJECT_NAME=cpsbatth
export CLUSTER_NAME=${PROJECT_NAME}-cluster
export CONTAINER_NAME=${PROJECT_NAME}-container

echo "setup"
gcloud config set compute/zone ${INSTANCE_ZONE}

echo "enable services"
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com

echo "creating container engine cluster"
gcloud container clusters create ${CLUSTER_NAME} --preemptible --zone ${INSTANCE_ZONE} --scopes cloud-platform --num-nodes 3

echo "confirm cluster is running"
gcloud container clusters list

echo "get credentials"
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${INSTANCE_ZONE}
```

# [ Helm Cheat codes ](https://helm.sh/docs/intro/cheatsheet/ ) , [ Helm commands ](https://helm.sh/docs/helm/helm/)

## Helm repo
* helm repo add bitnami https://charts.bitnami.com/bitnami
* helm repo update bitnami
* helm repo remove bitnami
* helm repo list 
* helm repo search repo|hub <keyword>

## Helm package
* helm create pkg1
* helm lint|template pkg1
* helm pull pkg1 [--untar=true | --verify | --version 1.1.0 ]
* helm package <pkg1_path>

## Helm charts add/rm/update/rollback
* helm install pkg1 deploy_pkg1  [ --namespace ns | --set k=v1,k2=v2 | --values yaml-file/url | --dry-run | --debug | --verify ]
* helm show all|values repo/pkg
* helm status|history pkg1
* helm uninstall deploy_pkg1


