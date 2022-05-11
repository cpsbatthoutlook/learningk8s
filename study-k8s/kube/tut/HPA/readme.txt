Prerequisite:  Metric servers should be running
kubectl > 1.2



Get the JAR file with high cPU steps for ~15sec 
Build the doc with openjdk
Build the docker image and push it to dockerhub
create a deployment with replicas=2
create a HPA with 4<replicas<5 with cpuThreshold of 40%
Monitor the sets
