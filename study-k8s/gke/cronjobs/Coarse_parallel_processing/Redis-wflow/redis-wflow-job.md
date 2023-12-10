
### Setup the Artifacts and build image
```
export GCLOUD_PROJECT=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export REPO=myrepo
export IMG=job-wq-2

gcloud artifacts repositories create ${REPO} --repository-format=docker \
    --location=${INSTANCE_REGION} --description="Docker repository"

gcloud artifacts repositories list

gcloud builds submit --region=${INSTANCE_REGION} --tag ${INSTANCE_REGION}-docker.pkg.dev/${GCLOUD_PROJECT}/${REPO}/${IMG}
```

### Run the setup
```
kc apply -f redis.py  #POD and Svc
```

### [Prepare the Queue](https://hevodata.com/learn/kubernetes-batch-job/)
```
 kc run -i --tty temp --rm --image redis --command "/bin/sh"
# redis-cli -h redis
redis:6379> rpush job2 "apple"
redis:6379> rpush job2 "banana"
redis:6379> lrange job2 0 -1
1) "apple"
.
.
9) "orange"
```
### Run the job
