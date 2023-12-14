[reference](https://oreil.ly/W5aqH)

## Create RabbitMQ svc & controler
kc apply -f rabbitmq-service.yaml

kc apply -f rabbitmq-controller.yaml

## Run and fill the containers
kc  run -it --rm temp --image ubuntu:18.04
  nslookup rabbitmq-service
  apt-get update
  apt-get install -y curl ca-certificates amqp-tools python dnsutils

  export BROKER_URL=amqp://guest:guest@rabbitmq-service:5672
  /usr/bin/amqp-declare-queue --url=$BROKER_URL -q foo -d
  /usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b Hello
  /usr/bin/amqp-consume --url=$BROKER_URL -q foo -c 1 cat && echo  ## Get back

  /usr/bin/amqp-declare-queue --url=$BROKER_URL -q job1  -d  ##Create new job
  for f in apple banana cherry date fig grape lemon melon;do /usr/bin/amqp-publish --url=$BROKER_URL -r job1 -p -b $f ; done

 
### Setup the Artifacts and build image
```
export GCLOUD_PROJECT=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export REPO=myrepo
export IMG=job-wq-1

gcloud artifacts repositories create ${REPO} --repository-format=docker \
    --location=${INSTANCE_REGION} --description="Docker repository"

gcloud artifacts repositories list

gcloud builds submit --region=${INSTANCE_REGION} --tag ${INSTANCE_REGION}-docker.pkg.dev/${GCLOUD_PROJECT}/${REPO}/${IMG}
```

## Define and run Job
  kc apply -f job.yaml


### Caveat
If the number of completions is set to less than the number of items in the queue, then not all items will be processed.

If the number of completions is set to more than the number of items in the queue, then the Job will not appear to be completed, even though all items in the queue have been processed. It will start additional pods which will block waiting for a message.

There is an unlikely race with this pattern. If the container is killed in between the time that the message is acknowledged by the amqp-consume command and the time that the container exits with success, or if the node crashes before the kubelet is able to post the success of the pod back to the api-server, then the Job will not appear to be complete, even though all items in the queue have been processed.
