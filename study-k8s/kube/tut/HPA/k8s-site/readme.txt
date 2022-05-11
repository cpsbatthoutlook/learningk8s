https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/


## Create a php based image with memory intensive tasks
##  Create Dockerfile and push it to Docker hub
## Create Deploy script and use this image to push the pods
## create @scaler from cmd-line
    kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10


## Increase load from busybox 
kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
Hit enter for command prompt
while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done


==== on multiple metrics  ====
#Get the declaration
kubectl get hpa.v2beta2.autoscaling -o yaml > /tmp/hpa-v2.yaml

## use it