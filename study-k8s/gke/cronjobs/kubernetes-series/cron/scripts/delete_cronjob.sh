#!/usr/bin/env bash

echo "preparing..."
export GCLOUD_PROJECT=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export INSTANCE_ZONE=us-central1-c
export PROJECT_NAME=cron
export CLUSTER_NAME=${PROJECT_NAME}-cluster
export CONTAINER_NAME=${PROJECT_NAME}-container
. ./env.sh

echo "setup"
gcloud config set compute/zone ${INSTANCE_ZONE}

echo "delete cronjob"
kubectl delete cronjob endpoints-cronjob
