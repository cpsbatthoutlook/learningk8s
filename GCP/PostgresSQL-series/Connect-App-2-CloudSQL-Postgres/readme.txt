
https://www.cloudskillsboost.google/focuses/57387?parent=catalog
#Connect an App to a Cloud SQL for PostgreSQL Instance


### Prepare the source database for migration.
In Google Shell:
gcloud auth list ## You can list the active account name with this command:
gcloud config list project  ## Project iD 
gcloud services enable artifactregistry.googleapis.com  ## Enable artifactory

## https://github.com/cpsbatthoutlook/learningk8s.git

## Create SA and bind to cloudSQL admin role
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"  \
    --role="roles/cloudsql.admin"

                    Updated IAM policy for project [qwiklabs-gcp-00-62a06ba6db29].
                    bindings:
                    - members:
                    - user:student-01-096ef7750c76@qwiklabs.net
                    role: roles/appengine.appAdmin
                    - members:
                    - serviceAccount:qwiklabs-gcp-00-62a06ba6db29@qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com
                    role: roles/bigquery.admin
                    - members:
                    - serviceAccount:601086256562@cloudbuild.gserviceaccount.com
                    role: roles/cloudbuild.builds.builder
                    - members:
                    - serviceAccount:service-601086256562@gcp-sa-cloudbuild.iam.gserviceaccount.com
                    role: roles/cloudbuild.serviceAgent
                    - members:
                    - serviceAccount:cloudsql-service-account@qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com
                    role: roles/cloudsql.admin
                    - members:
                    - serviceAccount:service-601086256562@compute-system.iam.gserviceaccount.com
                    role: roles/compute.serviceAgent
                    - members:
                    - serviceAccount:service-601086256562@container-engine-robot.iam.gserviceaccount.com
                    role: roles/container.serviceAgent
                    - members:
                    - serviceAccount:601086256562-compute@developer.gserviceaccount.com
                    - serviceAccount:601086256562@cloudservices.gserviceaccount.com
                    - user:student-01-096ef7750c76@qwiklabs.net
                    role: roles/editor
                    - members:
                    - serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com
                    - serviceAccount:qwiklabs-gcp-00-62a06ba6db29@qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com
                    - user:student-01-096ef7750c76@qwiklabs.net
                    role: roles/owner
                    - members:
                    - serviceAccount:qwiklabs-gcp-00-62a06ba6db29@qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com
                    role: roles/storage.admin
                    - members:
                    - user:student-01-096ef7750c76@qwiklabs.net
                    role: roles/viewer
                    etag: BwX6VE6eegE=
                    version: 1

## Create and export keys to local file
  gcloud iam service-accounts keys create $CLOUDSQL_SERVICE_ACCOUNT.json \
    --iam-account=$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID

                    {
                    "type": "service_account",
                    "project_id": "qwiklabs-gcp-00-62a06ba6db29",
                    "private_key_id": "e37707d515fcdeaa17cd4ba66f90eb463bf3bc1c",
                    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCyhHYIc2aT6LWk\nMqMZ76La6r1Ufyw1nVZ8y2ctSeWADzdO5PnqZkuQtfeyslyfClP4OcqXxA3Ji5fz\nLw5Co1xudl1+JueYvel657YeA+5D87i2mglYJF66oJQdzAa8ya48Sm6ZVPlZL9dm\nStij3nx+upqxXfsLUpyj0Aw7cErcy+iHsFDvVLgmmGSkHMoagszUc9gqo1dBS6ab\no/JolIfYt6ZZ8dXSXnjXtq0tLG+6FYfJQEOutDy8KGzQosPdlCyFw7UrGWUrZjzH\neprDNRShbdvH9nrSSEy8WJiRjurzpUkKI53hDn8MUiXcWBcYqvvfW1/OEpfgf+yp\njkb2IuI/AgMBAAECggEAELKXH787jwYrR0p9OwXRI8zlHKwwhGtNFaso4XGSB+Jk\nd/qu7Z/X3ZdHre1FAJNEu2kcbAmoiHuIIPT7znvdP2/O2ufkrcLFvftCa5hOhwia\n9GmACkCMo8Q1Vnwo/SuYIoeLxMfP8umoqibCEMHUvz3RDloOC0cU47WoDz83oWNB\nNRy7D5/P5wVZpdFhui/28qT0CQMG7SQu06ySx+TSMDnmD5IaEMRaOQEke5pqfCPL\ninHaIbnABGEixajUTh4fUH+RtYqk8w6v/R9DXEUKRUHqQodcLf3ERCSaBjOPU0wU\nCOJanZ806Pk+kZGJ5IYPn6o9wP//4GsPd7lrAntRkQKBgQDh9r/HMg0mcrjnf/4R\nJNvUwYpaTqsREhno/LwaDwo8djrjAJkbburr/IW2tYfnREpuJ1yoRVAy9gk2apbU\n+sYNOV/3D5wFi7VXG5c3BpvEnnnBTtsNlsQ6pzHAziKynxyvG5BRJcNobQpWbVyq\ncVznmST4wGD/wYsiT7yt8wlUUwKBgQDKPywqrLSWWFy/E3Sv9P80xSfa/VW9XZZN\n9KA/EHlAkQGjIYvGtrT9zpsPKMJDh6fd0cYEAD1LQETVZPo6RK1SOM7lEQjWaCm2\nUkxxNBrAbAS+qXuzKzsky7K86zKGY5e/OhCFx37EbWkSYrMdjdUMGbM2DooNCV4z\nuZVYs/085QKBgEWr3h/eF93l+4stlLnWgo2MC0ui++3shd6nppvmTUKtNaTud0bV\nIUwX9WaLfFbbYJOsQU6E6KB96gNERDNxCwXizesQfgvbstMj57EIsZijQGlRFguP\nk/t9t8J6DIrEsoRvXEUY/rJBBLH3UF4hTAMA3jxwnLffBjZTHZsI17SPAoGAcSXg\nlstiiM5MrRW8bYiakrJOduTOaBAIu/pFAKM9wtKdYN+urHChV3GULGn4LQGi96WZ\nq7lakVQWbnB80caEVQC1N1BNam6CD5+BZr/oy4hjKyv0qatg/lf72leXP7pONkzM\n25tdn5U6eG/Bl6I28/sY2QBPWbXI/xUvqZ2g6sUCgYEAj/8JOvPuunUY5hw9TcPt\nL0HkqwERwNTfKHBOm90QZoBIe6Sp11tYwP05Ju1mPonDIPsOIwa0rMYinCg0IwnI\nU+XHAn25zwiol7WelI5L7FHUKSlWdCXC7yU9khyHMlltu0aY9zSBDzunlyNigNhy\nRXWDdlN95zS2O1CNKqAVgmM=\n-----END PRIVATE KEY-----\n",
                    "client_email": "cloudsql-service-account@qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com",
                    "client_id": "112172930026102196804",
                    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                    "token_uri": "https://oauth2.googleapis.com/token",
                    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
                    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cloudsql-service-account%40qwiklabs-gcp-00-62a06ba6db29.iam.gserviceaccount.com"
                    }

#Create a Kubernetes cluster
ZONE=us-central1-a
gcloud container clusters create postgres-cluster --zone=$ZONE --num-nodes=2

## create k8s secrets
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=$CLOUDSQL_SERVICE_ACCOUNT.json
kubectl get secret
    
kubectl create secret generic cloudsql-db-credentials --from-literal=username=postgres \
    --from-literal=password=supersecret!     --from-literal=dbname=gmemegen_db

            student_01_096ef7750c76@cloudshell:~ (qwiklabs-gcp-00-62a06ba6db29)$ kubectl describe  secret cloudsql-db-credentials
            Name:         cloudsql-db-credentials
            Namespace:    default
            Labels:       <none>
            Annotations:  <none>
            Type:  Opaque
            Data
            ====
            password:  12 bytes
            username:  8 bytes
            dbname:    11 bytes
            student_01_096ef7750c76@cloudshell:~ (qwiklabs-gcp-00-62a06ba6db29)$ kubectl describe  secret cloudsql-instance-credentials
            Name:         cloudsql-instance-credentials
            Namespace:    default
            Labels:       <none>
            Annotations:  <none>
            Type:  Opaque
            Data
            ====
            credentials.json:  2387 bytes
              

## Download generic App 
gsutil -m cp -r gs://cloud-training/gsp919/gmemegen .
cd gmemegen

export REGION=us-central1
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export REPO=gmemegen

gcloud auth configure-docker ${REGION}-docker.pkg.dev  ## Docker authentication
gcloud artifacts repositories create $REPO --repository-format=docker --location=$REGION  ## create repository
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1 .   ## build
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1  # Store in repository
gcloud artifacts repositories list

        student_01_096ef7750c76@cloudshell:~/ (qwiklabs-gcp-00-62a06ba6db29)$ gcloud artifacts repositories list
        Listing items under project qwiklabs-gcp-00-62a06ba6db29, across all locations.

        ARTIFACT_REGISTRY

        REPOSITORY: gmemegen
        FORMAT: DOCKER
        MODE: STANDARD_REPOSITORY
        DESCRIPTION:
        LOCATION: us-central1
        LABELS:
        ENCRYPTION: Google-managed key
        CREATE_TIME: 2023-04-27T17:15:46
        UPDATE_TIME: 2023-04-27T17:19:27
        SIZE (MB): 346.692
        student_01_096ef7750c76@cloudshell:(qwiklabs-gcp-00-62a06ba6db29)$ docker images
        REPOSITORY                                                                      TAG       IMAGE ID       CREATED              SIZE
        us-central1-docker.pkg.dev/qwiklabs-gcp-00-62a06ba6db29/gmemegen/gmemegen-app   v1        b0374719b457   About a minute ago   941MB
        
        


Edit YAML file  to replace project_id variable with actual value
kubectl create -f gmemegen_deployment.yaml ## deploy 
kubectl expose deployment gmemegen --type "LoadBalancer" --port 80 --target-port 8080  

        NAME                            READY   STATUS    RESTARTS   AGE
        pod/gmemegen-57c4f9c4f9-llfzr   2/2     Running   0          55s

        NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
        service/gmemegen     LoadBalancer   10.92.7.194   34.72.46.19   80:31865/TCP   45s
        service/kubernetes   ClusterIP      10.92.0.1     <none>        443/TCP        16m

        NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
        deployment.apps/gmemegen   1/1     1            1           55s

        NAME                                  DESIRED   CURRENT   READY   AGE
        replicaset.apps/gmemegen-57c4f9c4f9   1         1         1       55s

export LOAD_BALANCER_IP=$(kubectl get svc gmemegen -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n default)
echo gMemegen Load Balancer Ingress IP: http://$LOAD_BALANCER_IP

POD_NAME=$(kubectl get pods --output=json | jq -r ".items[0].metadata.name")
kubectl logs $POD_NAME gmemegen | grep "INFO"


##Connect to DB and query
Console > DBase > SQL > postgres-gmemegen > connect > put password supersecret!

gcloud sql connect postgres-gmemegen --user=postgres --quiet


\c gmemegen_db
select * from meme;

