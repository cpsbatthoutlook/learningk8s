## Run Cluster
cd ~/learningk8s/study-k8s/gke/cronjobs/kubernetes-series/cron/scripts
. ./env.sh
gcloud container clusters create ${CLUSTER_NAME} --preemptible --zone ${INSTANCE_ZONE} --scopes cloud-platform --num-nodes 3
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${INSTANCE_ZONE}
cd ~/learningk8s/study-k8s/gke/cm
Run:  gcloud builds submit --tag gcr.io/${GCLOUD_PROJECT}/${CONTAINER_NAME}-cm
## gets the output of gcr.io/playground-s-11-fa24472e/cpsbatth-container-cm


#-https://learn.acloud.guru/handson/266bbea4-26e1-4a9c-82e8-97245c26c07f
Using ConfigMaps on GKE

gcloud config list project
gcloud config list compute/zone
gcloud config list compute/ [-all]
gcloud config list --all 

PR=using-config-239-da3a40cb
RE=us-central1

gcloud beta container --project "${PR}" clusters create "cluster-1" --no-enable-basic-auth --cluster-version "1.27.2-gke.1200" \
 --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "25" \
  --metadata disable-legacy-endpoints=true --scopes\ "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/${PR}/global/networks/default" \
 --subnetwork "projects/${PR}/regions/${RE}/subnetworks/default" --zone "${RE}-c" --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair \
 --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-managed-prometheus --enable-shielded-nodes \
 --node-locations "${RE}-c" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled 



#----------------
Create and Connect to a GKE Cluster
  Using the main navigation menu, under COMPUTE, select Kubernetes Engine.>  Click ENABLE. >   Once enabled, click CREATE.
  To the right of In the Standard: You manage your cluster, click CONFIGURE.
  At the top, choose USE A SETUP GUIDE, and choose My first cluster. >   Click CREATE NOW.
  Once the cluster has been created, click the three vertical dots and choose Connect.
  Under Command-line access, click Run in Cloud Shell.

Build the Container and Create the Deployment
Clone
  git clone https://github.com/linuxacademy/content-google-certified-pro-cloud-developer
Change to the /flask-configmaps/ directory inside the cloned lab repo:
  cd content-google-certified-pro-cloud-developer/flask-configmaps/
Use gcloud builds to create the container image, replacing <your-project-id> with the ID of your project:
  gcloud config set project $PR
  gcloud builds submit --tag gcr.io/${PR}/flask-configmaps
  gcloud container clusters get-credentials cluster-1 --zone=${RE}-c --project $PR

Click the Open Editor button above the terminal to open the Cloud Shell Editor, and open the Editor in a new window.
In the File menu, click New File  deployment.yaml 
In the new file, paste the following, replacing <your-project-id> with the ID of your project:
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: flask-deployment
      spec:
        selector:
          matchLabels:
            app: flask
        template:
          metadata:
            labels:
              app: flask
          spec:
            containers:
            - name: flask
              image: gcr.io/<your-project-id>/flask-configmaps
              ports:
              - containerPort: 8080
In the File menu, click Save All.

Return to the Cloud Shell terminal tab and click Open Terminal.Clear the screen and change back to the home directory:
  kubectl apply -f deployment.yaml
Create a load balancer service and expose the deployment:
  kubectl expose deployment flask-deployment --port=80 --target-port=8080 --type=LoadBalancer
After a few minutes, an external IP address should be provisioned for the service. View the service and external IP:
  kubectl get services
Copy the external IP and paste it in a new browser tab to confirm the deployment is working.

Use a ConfigMap to Add Environment Variables
  Return to the Cloud Shell terminal.
  Create a new ConfigMap called animal-config using the literal values dogs=10 and cats=5:
    kubectl create configmap animal-config --from-literal=dogs=10 --from-literal=cats=5
    kc describe cm animal-config
  Return to the tab with the Cloud Shell Editor.
  Update the deployment.yaml file to create environment variables from this ConfigMap by adding the following under the container image, at the same indentation level. If you are using copy and paste, you may have to correct some indentation. Just make sure that env starts at the same indentation level as the image directive above it.
      env:
        - name: NUM_DOGS
          valueFrom:
            configMapKeyRef:
              name: animal-config
              key: dogs
        - name: NUM_CATS
          valueFrom:
            configMapKeyRef:
              name: animal-config
              key: cats
  In the File menu, click Save.

  Return to the Cloud Shell terminal tab and reapply the deployment:
    kubectl apply -f deployment.yaml
  Reload the web page where the external IP address was pasted. The app should now display the environment variables.

Use a ConfigMap to Add a Configuration File
  Return to the Cloud Shell Editor tab.
  In the File menu, click New File.
  Name the file animals.cfg and click OK, , paste in the following:
    catfood=kibble
    dogfood=mixer
    fussy_dog=derek
    latest_feed=10pm
  In the File menu, click Save.
  Return to the Cloud Shell terminal.

  Create a new ConfigMap called animal-configfile using the file you just created:
    kubectl create configmap animal-configfile --from-file=animals.cfg
  Return to the Cloud Shell Editor tab.

  Update the deployment.yaml file to create a volume from this ConfigMap and mount it into the Pod. Add the following under the container image, at the same indentation level. If you are using copy and paste, you may have to correct some indentation. Just make sure that volumeMounts starts at the same indentation level as the image directive above it.
    volumeMounts:
    - name: animal-configfile-volume
      mountPath: /data
  Add the volume to the end of the deployment.yaml file. The volumes directive should start at the same indentation level as the containers directive:
    volumes:
      - name: animal-configfile-volume
        configMap:
          name: animal-configfile
  In the File menu, click Save.
  Return to the Cloud Shell terminal and reapply the deployment:
    kubectl apply -f deployment.yaml
  Reload the web page where the external IP address was pasted. The app should now display the contents of the config file as well.
