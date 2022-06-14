Deploy single app + RS + Nodeport 

#--- cLUSTERip
vagrant@kmaster:/data/learningk8s/study-k8s/kube/tut/action-plan/1-deploy-single-app$ kc apply -f deploy-single-app.yaml
deployment.apps/first-app created
service/svc-first-app created
service/svc-first-app-np created

NAME                             READY   STATUS      RESTARTS   AGE     IP            NODE     NOMINATED NODE   READINESS GATES
pod/first-app-6db7c55f44-df2q9   1/1     Running     0          22s     10.244.2.88   knode2   <none>           <none>
pod/first-app-6db7c55f44-trzls   1/1     Running     0          22s     10.244.3.97   knode3   <none>           <none>

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/svc-first-app   ClusterIP   10.109.75.171   <none>        80/TCP    4s    app=first-app
service/svc-first-app-np   NodePort    10.101.27.195   <none>        80:30762/TCP   17s   app=first-app

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                SELECTOR
deployment.apps/first-app   2/2     2            2           22s   first-app    nginx:stable-alpine   app=first-app

NAME                                   DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES                SELECTOR
replicaset.apps/first-app-6db7c55f44   2         2         2       22s   first-app    nginx:stable-alpine   app=first-app,pod-template-hash=6db7c55f44
