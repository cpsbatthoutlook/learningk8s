
https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-gcp_config_connector-manual.html  ## Didn't work Tanzu components issues
https://itnext.io/creating-a-cloudsql-using-config-connector-694a9f63358f  ## uses ACC

Overview:
A useable database instance consists of a SQLInstance, a SQLDatabase, and a SQLUser. Realistically, in addition to that we will also want another set of Secrets:
 one Secret per SQLInstance to hold the password for the instance’s admin role
 one Secret per SQLUser to hold that user’s password
In the simplest case, with one SQLInstance, one SQLDatabase, and one SQLUser, we need to manage the following set of interrelated resources:

[ SQL-DB -> SQL-instance -> sql-admin-creds ] 
^
|
[sql-user -> sql-user-creds]


OR

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
   --no-enable-basic-auth --cluster-version "1.27.2-gke.1200" --release-channel "regular" \
   

gcloud iam service-accounts create "${SA_NAME}" --description "${LABELS}"
gcloud projects add-iam-policy-binding "${GCP_PROJECT}" --role="roles/editor" \
    --member="serviceAccount:${SA_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com" 
gcloud iam service-accounts add-iam-policy-binding "${SA_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com" \
    --member="serviceAccount:${GCP_PROJECT}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    --role="roles/iam.workloadIdentityUser"

# Create cluster as per : https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-gcp_config_connector-prerequisites.html#get-nat-ip


# Configure a stable egress IP
## Configure the ip-masq-agent
cat <<'EOF' | kubectl -n kube-system create cm ip-masq-agent --from-file=config=/dev/stdin
nonMasqueradeCIDRs:
- 0.0.0.0/0
EOF

kubectl -n kube-system rollout restart daemonset ip-masq-agent

## Set up a Cloud NAT service
gcloud compute routers create "${NAT_NAME}-router" --region "${REGION}" --network default
gcloud compute routers nats create "${NAT_NAME}-config" --router-region "${REGION}" \
    --router "${NAT_NAME}-router" --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges

## Get NAT-IP
gcloud compute routers get-status "${NAT_NAME}-router" --region "${REGION}" --format=json \
  | jq -r '.result.natStatus[].autoAllocatedNatIps[]'






### Database instance #https://cloud.google.com/config-connector/docs/reference/resource-docs/sql/sqldatabase
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLDatabase
metadata:
  labels:
    label-one: "value-one"
  name: sqldatabase-sample
spec:
  charset: utf8mb4
  collation: utf8mb4_bin
  instanceRef:
    name: sqldatabase-dep
---
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLInstance
metadata:
  name: sqlinstance-sample-postgreshighavailability
spec:
  databaseVersion: POSTGRES_9_6
  region: us-central1
  settings:
    tier: db-custom-1-3840
    availabilityType: ZONAL
---
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLUser
metadata:
  name: sqluser-sample
spec:
  instanceRef:
    name: sqluser-dep
  host: "%"
  password:
    valueFrom:
      secretKeyRef:
        name: sqluser-dep
        key: password
---
apiVersion: v1
kind: Secret
metadata:
  name: sqluser-dep
data:
  password: cGFzc3dvcmQ=
---















------- Archive --------------

## Verify if Tanzu exists: kubectl api-resources | grep secrettemplate *ITS NOT*
##Create Config Connector <DIDNOT WORK>
cat <<EOF | kubectl apply -f -
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: "${SA_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com"
EOF

kubectl create namespace "${SI_NAMESPACE}"
kubectl annotate namespace "${SI_NAMESPACE}" "cnrm.cloud.google.com/project-id=${GCP_PROJECT}"
kubectl wait -n cnrm-system --for=condition=Ready pod --all
gcloud services enable serviceusage.googleapis.com

#---- Create Secret .. secret.yaml
kind: List
apiVersion: v1
items:
- kind: Password
  apiVersion: secretgen.k14s.io/v1alpha1
  metadata:
    name: sql-admin-creds
    #namespace: service-instances
  spec: &passwordSpec
    length: 64
    secretTemplate:
      type: Opaque
      stringData:
        password: $(value)
- kind: Password
  apiVersion: secretgen.k14s.io/v1alpha1
  metadata:
    name: sql-user-creds
    namespace: service-instances
  spec: *passwordSpec

alias kc=kubectl
kc apply -f secret.yaml
kc get passwords,secrets sql-user-creds sql-admin-creds

#---- Postgres db instance
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLInstance
metadata:
  name: sql-instance
  #namespace: service-instances
spec:
  databaseVersion: POSTGRES_14
  #! If you have deployed your cluster into a different region, you might want
  #! to change this and deploy the SQLInstance into the same region as the
  #! cluster, to avoid traffic going across regions.
  region: us-cental1
  rootPassword:
    valueFrom:
      secretKeyRef:
        key: password
        name: sql-admin-creds
  settings:
    tier: db-g1-small
    ipConfiguration:
      authorizedNetworks:
      - name: cluster-NAT-IP
        #! Update this value with your NAT IP address in CIDR notation (e.g. 8.8.8.8/32). See above.
        value: 34.135.35.71
      ipv4Enabled: true
---
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLDatabase
metadata:
  name: sql-database
  #namespace: service-instances
spec:
  charset: UTF8
  collation: en_US.UTF8
  instanceRef:
    name: sql-instance
---
apiVersion: sql.cnrm.cloud.google.com/v1beta1
kind: SQLUser
metadata:
  name: sql-user
  #namespace: service-instances
spec:
  instanceRef:
    name: sql-instance
  password:
    valueFrom:
      secretKeyRef:
        key: password
        name: sql-user-creds


