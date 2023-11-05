#https://medium.com/google-cloud/kubernetes-cron-jobs-455fdc32e81a

#### Setup GKE cluster manually
gcloud container  clusters get-credentials cluster-1 --zone us-central1-c
gcloud services list
NAME: artifactregistry.googleapis.com   TITLE: Artifact Registry API
NAME: autoscaling.googleapis.com        TITLE: Cloud Autoscaling API
NAME: bigquery.googleapis.com   TITLE: BigQuery API
NAME: bigquerymigration.googleapis.com  TITLE: BigQuery Migration API
NAME: bigquerystorage.googleapis.com    TITLE: BigQuery Storage API
NAME: compute.googleapis.com    TITLE: Compute Engine API
NAME: container.googleapis.com  TITLE: Kubernetes Engine API
NAME: containerfilesystem.googleapis.com        TITLE: Container File System API
NAME: containerregistry.googleapis.com  TITLE: Container Registry API
NAME: deploymentmanager.googleapis.com  TITLE: Cloud Deployment Manager V2 API
NAME: dns.googleapis.com        TITLE: Cloud DNS API
NAME: iam.googleapis.com        TITLE: Identity and Access Management (IAM) API
NAME: iamcredentials.googleapis.com     TITLE: IAM Service Account Credentials API
NAME: logging.googleapis.com    TITLE: Cloud Logging API
NAME: monitoring.googleapis.com TITLE: Cloud Monitoring API
NAME: networkconnectivity.googleapis.com        TITLE: Network Connectivity API
NAME: oslogin.googleapis.com    TITLE: Cloud OS Login API
NAME: pubsub.googleapis.com     TITLE: Cloud Pub/Sub API
NAME: runtimeconfig.googleapis.com      TITLE: Cloud Runtime Configuration API
NAME: serviceusage.googleapis.com       TITLE: Service Usage API
NAME: storage-api.googleapis.com        TITLE: Google Cloud Storage JSON API
NAME: storage-component.googleapis.com  TITLE: Cloud Storage


##-------- sample_cronjob.yaml
apiVersion: batch/v1beta1
kind: CronJob # it is a Cron Job
metadata:
  name: endpoints-cronjob # name of the CronJob
spec:
  schedule: "* * * * *" # run every minute
  startingDeadlineSeconds: 10 # if a job hasn't starting in this many seconds, skip
  concurrencyPolicy: Allow # either allow|forbid|replace
  successfulJobsHistoryLimit: 3 # how many completed jobs should be kept
  failedJobsHistoryLimit: 1 # how many failed jobs should be kept
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: cron-container-cronjob
              image: gcr.io/PROJECT_NAME/cron-container-cronjob:latest
              # environment variables for the Pod
              env:
                - name: GCLOUD_PROJECT
                  value: PROJECT_NAME
                # endpoint to hit by cron job
                - name: FOREIGN_SERVICE
                  value: http://endpoints.default.svc.cluster.local/endpoint
                - name: NODE_ENV
                  value: production
              ports:
                - containerPort: 80



## Getting started : git clone https://github.com/jonbcampos/kubernetes-series.git
$ git clone https://github.com/jonbcampos/kubernetes-series.git
$ cd ~/kubernetes-series/cron/scripts
$ sh startup.sh
$ sh deploy.sh
$ sh check-endpoint.sh endpoints

#Issue:  google build fails for container 
