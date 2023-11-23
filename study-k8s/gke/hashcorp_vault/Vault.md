GKE External Hashicorp vault: https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-external-vault


## Create cluster
gcloud services enabled container.googleapis.com compute.googleapis.com containerregistry.googleapis.com  
##Didn't work## gcloud container clusters create learn-vault --num-nodes=2 --preemptible

URI_GAPI="https://www.googleapis.com/auth"
GCP_PROJECT="playground-s-11-0d834a82"
gcloud beta container --project "${GCP_PROJECT}" clusters create learn-vault --zone "us-central1-c" --no-enable-basic-auth \
 --cluster-version "1.27.3-gke.100" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
 --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true  --num-nodes "3" --enable-ip-alias --node-locations "us-central1-c" \
 --scopes "${URI_GAPI}/devstorage.read_only","${URI_GAPI}/logging.write","${URI_GAPI}/monitoring","${URI_GAPI}/servicecontrol","${URI_GAPI}/service.management.readonly","${URI_GAPI}/trace.append" \
 --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --network "projects/${GCP_PROJECT}/global/networks/default" --subnetwork "projects/${GCP_PROJECT}/regions/us-central1/subnetworks/default" \
 --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled \
 --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade \
 --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-managed-prometheus --enable-shielded-nodes 


gcloud container clusters list
gcloud container clusters get-credentials learn-vault --location us-central1-c
alias kc=kubectl


git clone https://github.com/hashicorp/vault-guides.git

## Install the helm chart for Vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm repo list
helm search repo vault --versions
helm install vault hashicorp/vault --set='server.ha.enabled=true'  --set='server.ha.raft.enabled=true'
	helm status vault
	helm get manifest vault   
#------------------------
kc get all
NAME                                        READY   STATUS    RESTARTS   AGE
pod/vault-0                                 0/1     Running   0          79s
pod/vault-1                                 0/1     Running   0          79s
pod/vault-2                                 0/1     Running   0          79s
pod/vault-agent-injector-7655d66c96-xwwxx   1/1     Running   0          79s
NAME                               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
service/kubernetes                 ClusterIP   10.108.0.1     <none>        443/TCP             16m
service/vault                      ClusterIP   10.108.2.62    <none>        8200/TCP,8201/TCP   79s
service/vault-active               ClusterIP   10.108.8.124   <none>        8200/TCP,8201/TCP   79s
service/vault-agent-injector-svc   ClusterIP   10.108.10.61   <none>        443/TCP             79s
service/vault-internal             ClusterIP   None           <none>        8200/TCP,8201/TCP   79s
service/vault-standby              ClusterIP   10.108.5.214   <none>        8200/TCP,8201/TCP   79s
NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/vault-agent-injector   1/1     1            1           79s
NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/vault-agent-injector-7655d66c96   1         1         1       79s
NAME                     READY   AGE
statefulset.apps/vault   0/3     79s
#------------------------

kc exec vault-0 -- vault status  ## Get vault status ### Sealed             true
kc exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json  ## Initiate and  unseal the Vault pod
cloud_user_p_6b41678f@cloudshell:~ (playground-s-11-d9b39d2f)$ more cluster-keys.json  | jq -c
{"unseal_keys_b64":["Mxu9k9Yflh59JALzXgX4MBb3Y9xoFWf6Gces/jc85xM="],"unseal_keys_hex":["331bbd93d61f961e7d2402f35e05f83016f763dc681567fa19c7acfe373ce713"],"unseal_shares":1,"unseal_threshold":1,"recovery_keys_b64":[],"recovery_keys_hex":[],"recovery_keys_shares":0,"recovery_keys_threshold":0,"root_token":"hvs.PfGp2ajFo5hlheECjcO3LpyC"}
cloud_user_p_6b41678f@cloudshell:~ (playground-s-11-d9b39d2f)$ 

cat cluster-keys.json | jq -r ".unseal_keys_b64[]"  ##Display the unsealed key
export VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")  #Create a variable
kc exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY ## Unseal the POD ###Sealed                  false
kc exec vault-0 -- vault status  ## Get vault status
###
cat cluster-keys.json | jq -r ".root_token"
export CLUSTER_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
kc exec vault-0 -- vault login $CLUSTER_ROOT_TOKEN
kc exec vault-0 -- vault operator raft list-peers
Node                                    Address                        State     Votert operator raft list-peers
----                                    -------                        -----     -----
b672a2b5-a0ce-13f7-56c9-6c517ff054ee    vault-0.vault-internal:8201    leader    true

kc exec vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kc exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
kc exec vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
kc exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY
kc exec vault-0 -- vault operator raft list-peers
Node                                    Address                        State       Voter
----                                    -------                        -----       -----
b672a2b5-a0ce-13f7-56c9-6c517ff054ee    vault-0.vault-internal:8201    leader      true
260184da-280f-4387-f5fd-85a26157ea33    vault-1.vault-internal:8201    follower    true
dec5aa51-ddb9-b929-c0e6-cc1af00452e5    vault-2.vault-internal:8201    follower    false
### Set secrets
kc exec --stdin=true --tty=true vault-0 -- /bin/sh
  vault secrets enable -path=secret kv-v2
  vault kv put secret/devwebapp/config username='giraffe' password='salsa'
  vault kv get secret/devwebapp/config
#------
======== Secret Path ========
secret/data/devwebapp/config
======= Metadata =======
Key                Value
---                -----
created_time       2023-08-09T21:41:56.533697519Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1
====== Data ======
Key         Value
---         -----
password    salsa
username    giraffe
#------

  exit

##Configure the GKE authentication
kc exec --stdin=true --tty=true vault-0 -- /bin/sh
  vault auth enable kubernetes
  vault write auth/kubernetes/config \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
  vault policy write devwebapp - <<EOF
   path "secret/data/devwebapp/config" { capabilities = ["read"]}
EOF
  vault write auth/kubernetes/role/devweb-app bound_service_account_names=internal-app \
        bound_service_account_namespaces=default  policies=devwebapp  ttl=24h
  exit

##Deploy web application
kc create sa internal-app
---devwebapp.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: devwebapp
  labels:
    app: devwebapp
  annotations:
    vault.hashicorp.com/agent-inject: "true"
    vault.hashicorp.com/role: "devweb-app"
    vault.hashicorp.com/agent-inject-secret-credentials.txt: "secret/data/devwebapp/config"
spec:
  serviceAccountName: internal-app
  containers:
    - name: devwebapp
      image: jweissig/app:0.0.1
---devwebapp.yaml 
kc apply -f devwebapp.yaml
kc exec -it devwebapp -c devwebapp -- cat /vault/secrets/credentials.txt


### Delete cluster
gcloud container clusters delete learn-vault --location=us-central1-c


  