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

alias kc=kubectl 
