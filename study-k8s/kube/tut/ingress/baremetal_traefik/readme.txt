https://richard-nunez.medium.com/my-journey-to-kubernetes-onto-bare-metal-part-7-traefik-a464d2f610f

KEPT GETTING ERRORS "E0518 18:00:16.972374       1 reflector.go:138] pkg/mod/k8s.io/client-go@v0.21.0/tools/cache/reflector.go:167: Failed to watch *v1.Endpoints: failed to list *v1.Endpoints: endpoints is forbidden: User "system:serviceaccount:traefik:traefik-ingress-controller" cannot list resource "endpoints" in API group"" at the cluster scope
"

##
## https://github.com/traefik/traefik/tree/v1.7  : REFERENCE
##
https://richard-nunez.medium.com/my-journey-to-kubernetes-onto-bare-metal-part-7-traefik-a464d2f610f
https://doc.traefik.io/traefik/

##Working Cluster
## RBAC :  https://github.com/traefik/traefik/blob/v1.7/examples/k8s/traefik-rbac.yaml
## DS: https://github.com/traefik/traefik/tree/v1.7/examples/k8s/traefik-ds.yaml
## 
kc apply -f 1-traefik-ns.yaml  2-traefik-ds.yaml  3-traefik-rbac.yaml   ## Changed the apiVersion definitioin by removing beta
##
Create Storage :  kc apply -f 4-pv.yaml  ## on NFS share
##
Create Traefik Deploy, MW and Svc: kc apply -f 5-mw.yaml 6-deploy.yaml 7-svc.yaml 8-opt-metric.yaml
##
Expost Traefik internally/extdernally:  kc apply -f 9-access-internal-dashboard.yaml
## 
Access dashboard (not working via Metallb) : http://http://192.168.0.52:8080/dashboard
## Output
NAME                                   READY   STATUS    RESTARTS   AGE   IP             NODE     NOMINATED NODE   READINESS GATES
pod/traefik-56cb8995f4-ql5nv           1/1     Running   0          26m   10.244.1.32    node1    <none>           <none>
pod/traefik-ingress-controller-27wg8   1/1     Running   0          47m   10.244.3.116   node3    <none>           <none>
pod/traefik-ingress-controller-5c6vv   1/1     Running   0          47m   10.244.2.99    node2    <none>           <none>
pod/traefik-ingress-controller-5tpg8   1/1     Running   0          47m   10.244.6.7     jnode5   <none>           <none>
pod/traefik-ingress-controller-dvfg5   1/1     Running   0          47m   10.244.4.8     jnode3   <none>           <none>
pod/traefik-ingress-controller-rqwf4   1/1     Running   0          47m   10.244.1.31    node1    <none>           <none>
pod/traefik-ingress-controller-vp9c4   1/1     Running   0          47m   10.244.5.6     jnode4   <none>           <none>

NAME                              TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE   SELECTOR
service/traefik                   LoadBalancer   10.102.66.72    192.168.0.51   80:32159/TCP,443:32377/TCP   24m   app=traefik
service/traefik-dashboard         ClusterIP      10.99.178.233   <none>         8080/TCP                     24m   app=traefik
service/traefik-ingress-service   ClusterIP      10.107.251.20   <none>         80/TCP,8080/TCP              47m   k8s-app=traefik-ingress-lb
service/traefik-internal          LoadBalancer   10.110.8.231    192.168.0.52   80:31816/TCP,443:32492/TCP   21m   app=traefik
service/traefik-metrics           ClusterIP      10.107.107.38   <none>         8082/TCP                     22m   app=traefik

NAME                                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE   CONTAINERS           IMAGES         SELECTOR
daemonset.apps/traefik-ingress-controller   6         6         6       6            6           <none>          47m   traefik-ingress-lb   traefik:v1.7   k8s-app=traefik-ingress-lb,name=traefik-ingress-lb

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES         SELECTOR
deployment.apps/traefik   1/1     1            1           26m   traefik      traefik:v2.2   app=traefik

NAME                                 DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
replicaset.apps/traefik-56cb8995f4   1         1         1       26m   traefik      traefik:v2.2   app=traefik,pod-template-hash=56cb8995f4


## Cluster Info
Client Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:46:05Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.4
Server Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:38:19Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}





