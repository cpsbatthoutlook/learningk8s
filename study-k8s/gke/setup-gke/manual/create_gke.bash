gcloud init
gcloud components install kubectl


GCP_PROJECT='playground-s-11-3e8f411a'
LABELS='test1=gke,test2=cloudsql'
CLUSTER_NAME='cluster1'
# The Google Cloud Service Account to be used by the Config Connector
SA_NAME="${CLUSTER_NAME}-sa"
# The cluster's node count We suggest to start at 6 nodes to host all the TAP systems and to ensure
# the (automatically provisioned and managed) control plane is also scaled accordingly.
NODE_COUNT=3
# The namespace you want to deploy the Config Connector / service instance objects into
SI_NAMESPACE="default"
# In this example we deploy a zonal cluster, thus you need to provide the
# zone you want your cluster to land in
REGION='us-central'
ZONE='us-central1-c'
# For Cloud NAT we need to provide the region we want to deploy the router
# to, this needs to be the region the zonal cluster resides in
REGION='us-central1'
# Will be used for the name of the Cloud NAT router and the NAT config we deploy on it
NAT_NAME="${REGION}-nat"

gcloud container --project "${GCP_PROJECT}" \
    clusters create "${CLUSTER_NAME}" --zone "${ZONE}" --release-channel "regular" \
    --machine-type "e2-medium" --disk-type "pd-standard"  --disk-size "70" \
    --metadata disable-legacy-endpoints=true --num-nodes "${NODE_COUNT}" --node-labels "${LABELS}" \
    --logging=SYSTEM --monitoring=SYSTEM --enable-ip-alias --enable-network-policy \
    --addons ConfigConnector,HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --workload-pool="${GCP_PROJECT}.svc.id.goog" --labels "${LABELS}" --image-type "COS_CONTAINERD"  \
   --no-enable-basic-auth --cluster-version "1.27.2-gke.1200" --release-channel "regular" 
   
echo Optoinal gcloud container node-pools create ${CLUSTER_NAME}-NP --cluster=[CLUSTER_NAME] \
  --region=[REGION] --node-taints agones.dev/agones-system=true:NoExecute \
  --node-labels agones.dev/agones-system=true --num-nodes=1 --machine-type=e2-medium #https://agones.dev/site/docs/installation/creating-cluster/gke/



gcloud container clusters list

gcloud iam service-accounts create "${SA_NAME}" --description "${LABELS}"
#gcloud projects add-iam-policy-binding "${GCP_PROJECT}" --role="roles/editor" \
    #--member="serviceAccount:${SA_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com" 
#gcloud iam service-accounts add-iam-policy-binding "${SA_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com" \
    #--member="serviceAccount:${GCP_PROJECT}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    #--role="roles/iam.workloadIdentityUser"

## Set up a Cloud NAT service
gcloud compute routers create "${NAT_NAME}-router" --region "${REGION}" --network default
gcloud compute routers nats create "${NAT_NAME}-config" --router-region "${REGION}" \
    --router "${NAT_NAME}-router" --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges

## Get NAT-IP
gcloud compute routers get-status "${NAT_NAME}-router" --region "${REGION}" --format=json \
  | jq -r '.result.natStatus[].autoAllocatedNatIps[]'

gcloud container clusters get-credentials cluster-1 --zone=${ZONE} --project $GCP_PROJECT
