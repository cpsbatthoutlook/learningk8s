## [Coarse Parallel Processing Using a Work Queue](https://kubernetes.io/docs/tasks/job/coarse-parallel-processing-work-queue/#create-an-image)

### Start a [message queue service](https://github.com/kubernetes/kubernetes/tree/release-1.3/examples/celery-rabbitmq)
```
kc apply -f rabbitmq.yaml
kc run -i --tty temp --image ubuntu:18.04  
```
#### Test
```
kc run -i --tty temp --image ubuntu:18.04
apt-get -y update
apt-get install -y curl ca-certificates amqp-tools python dnsutils

#test the service rabbitmq-service.default.svc.cluster.local
nslookup rabbitmq-service
env | grep RABBIT | grep HOST ## alternative if KubeDNS is not working

## Xchange msgs
export BROKER_URL=amqp://guest:guest@rabbitmq-service:5672
/usr/bin/amqp-declare-queue --url=$BROKER_URL -q foo -d  ##Create queue
/usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b Hello   ## Put msg
/usr/bin/amqp-consume --url=$BROKER_URL -q foo -c 1 cat ## Get back
```

[OR](https://hevodata.com/learn/kubernetes-batch-job/)
```
 kc run -i --tty temp --image redis --command "/bin/sh"
# redis-cli -h redis
redis:6379> rpush job2 "apple"
redis:6379> rpush job2 "banana"
redis:6379> lrange job2 0 -1
1) "apple"
2) "banana"
3) "cherry"
4) "date"
5) "fig"
6) "grape"
7) "lemon"
8) "melon"
9) "orange"
```

### Create and fill queue
#### Fill 8 messages in Job1
```
/usr/bin/amqp-declare-queue --url=$BROKER_URL -q job1  -d
for f in apple banana cherry date fig grape lemon melon
do
  /usr/bin/amqp-publish --url=$BROKER_URL -r job1 -p -b $f
done
```

#### [Create image](https://cloud.google.com/build/docs/build-push-docker-image)

You can build it using [Config file as well](https://github.com/GoogleCloudPlatform/cloud-build-samples/blob/main/quickstart-build/cloudbuild.yaml)
```
export GCLOUD_PROJECT=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export REPO=myrepo

gcloud artifacts repositories create ${REPO} --repository-format=docker \
    --location=${INSTANCE_REGION} --description="Docker repository"

gcloud artifacts repositories list

gcloud builds submit --region=${INSTANCE_REGION} --tag ${INSTANCE_REGION}-docker.pkg.dev/${GCLOUD_PROJECT}/${REPO}/wq-1:latest
```
source: gs://playground-s-11-c16f1dab_cloudbuild/source/1701366349.606363-67b9a178b66d49e8a0b56a97a053eef3.tgz
image: us-central1-docker.pkg.dev/playground-s-11-c16f1dab/quickstart-docker-repo/job-wq-1:tag1

*Optional* If you are using Google Container Registry, tag your app image with your project ID, and push to GCR
```
docker tag job-wq-1 gcr.io/${GCLOUD_PROJECT}/job-wq-1
gcloud docker -- push gcr.io/${GCLOUD_PROJECT}/job-wq-1
 gcloud artifacts docker images list ${INSTANCE_REGION}-docker.pkg.dev/${GCLOUD_PROJECT}/${REPO}
 # Scan
 gcloud artifacts docker images scan ${INSTANCE_REGION}-docker.pkg.dev/${GCLOUD_PROJECT}/${REPO}/wq-1:latest --remote

```
### Start job that works on the tasks from Queue

```
kc apply -f ./job.yaml
kc wait --for=condition=complete --timeout=300s job/job-wq-1
kc describe jobs/job-wq-1
```