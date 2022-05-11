== RUN container directly as sergice ===

https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-type-nodeport

s=my-svc
#Run deployment
kubectl run ${s} --image=k8s.gcr.io/echoserver:1.4 -n chander
#Run Service as ClusterIP (default)
kubectl expose deploy $s -n chander --name=clusterip --port=80 --target-port=8080  

#Test curl -i --connect-timeout 5 localhost:8080

#Run same service as nodeport
kc expose deploy $s -n chander --name=nodeport --port=80 --target-port=8080 --type=NodePort
## patch  (to see the client ip is th elocal server not local Node)
 patch -p '{"spec":{"externalTrafficPolicy":"Local"}}'  service/nodeport -n chander


#Run same service as LoadBalancer
kc expose deploy $s -n chander --name=lb --port=80 --target-port=8080 --type=LoadBalancer
## patch  (to see the client ip is th elocal server not local Node)
 patch -p '{"spec":{"externalTrafficPolicy":"Local"}}'  service/nodeport -n chander

??? inGRESS Controller ??



###  ###  ###
Typical usages are as follows. To launch Ghost serving on port 2368 and create a service along with it, enter:
$ kubectl run ghost --image=ghost:0.9 --port=2368 --expose

To launch MySQL with the root password set, enter:
$ kubectl run mysql --image=mysql:5.5 --env=MYSQL_ROOT_PASSWORD=root

To launch a busybox container and execute the command sleep 3600 on start, enter:
$ kubectl run myshell --image=busybox --command -- sh -c "sleep 3600"




