https://gregoiredayet.medium.com/monitoring-and-alerting-on-your-kubernetes-cluster-with-prometheus-and-grafana-55e4b427b22d

#Didn't work# helm repo add stable https://kubernetes-charts.storage.googleapis.com/
##Didn't Work##helm repo add stablehelm https://charts.helm.sh/stable
##Didn't Work##helm repo update stablehelm

kc create ns monitoring

##Didn't Work##helm install prometheus stable/prometheus --namespace monitoring

#https://adamtheautomator.com/prometheus-kubernetes/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo  prometheus-community
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring [ --dry-run ]]
#
#  
kc port-forward --address 0.0.0.0 svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 
# ksm service metrics http://192.168.0.21:8080/ Internal state monitoring .. Also accessible for http://192.168.0.21:9090/targets?search=
kc port-forward -n monitor --address 0.0.0.0 svc/prometheus-kube-state-metrics 8080 Internal state monitoring 
#
# Grafana : Get the secrets first
# Reference: https://adamtheautomator.com/grafana-tutorial/  # #Getting started
kubectl get secret -n monitoring prometheus-grafana -o yaml   ,,  | base64 --decode
kubectl port-forward svc/prometheus-grafana -n monitoring --address 0.0.0.0  3000:80

#
kubectl -n  monitoring get all 
kubectl -n  monitoring get pods -l "release=prometheus"
#

#--------- pods -----------
    NAME                                                     READY   STATUS    RESTARTS        AGE     IP             NODE      NOMINATED NODE   READINESS GATES
    alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0               5m28s   10.244.2.22    knode2    <none>           <none>
    prometheus-grafana-cc56f546c-xs887                       3/3     Running   0               5m33s   10.244.3.9     knode3    <none>           <none>
    prometheus-kube-prometheus-operator-7fd74c7b44-k4chk     1/1     Running   0               5m33s   10.244.2.21    knode2    <none>           <none>
    prometheus-kube-state-metrics-6545694994-4hj8b           1/1     Running   0               5m33s   10.244.3.8     knode3    <none>           <none>
    prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0               5m27s   10.244.1.34    knode1    <none>           <none>
    prometheus-prometheus-node-exporter-cq92q                1/1     Running   0               5m33s   192.168.0.23   knode3    <none>           <none>
    prometheus-prometheus-node-exporter-fstkx                1/1     Running   0               5m33s   192.168.0.20   kmaster   <none>           <none>
    prometheus-prometheus-node-exporter-k2nqv                1/1     Running   0               5m33s   192.168.0.22   knode2    <none>           <none>
    prometheus-prometheus-node-exporter-qxzsk                1/1     Running   5 (3m55s ago)   5m33s   192.168.0.21   knode1    <none>    
 
#------- Svc -----------------
    NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
    alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   3m34s
    prometheus-grafana                        ClusterIP   10.111.235.172   <none>        80/TCP                       3m39s
    prometheus-kube-prometheus-alertmanager   ClusterIP   10.100.64.219    <none>        9093/TCP                     3m39s
    prometheus-kube-prometheus-operator       ClusterIP   10.109.64.198    <none>        443/TCP                      3m39s
    prometheus-kube-prometheus-prometheus     ClusterIP   10.108.228.154   <none>        9090/TCP                     3m39s
    prometheus-kube-state-metrics             ClusterIP   10.110.65.80     <none>        8080/TCP                     3m39s
    prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     3m34s
    prometheus-prometheus-node-exporter       ClusterIP   10.106.46.231    <none>        9100/TCP                     3m39s

#-------- Others --------
    NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    daemonset.apps/prometheus-prometheus-node-exporter   4         4         4       4            4           <none>          22m

    NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/prometheus-grafana                    1/1     1            1           22m
    deployment.apps/prometheus-kube-prometheus-operator   1/1     1            1           22m
    deployment.apps/prometheus-kube-state-metrics         1/1     1            1           22m

    NAME                                                             DESIRED   CURRENT   READY   AGE
    replicaset.apps/prometheus-grafana-cc56f546c                     1         1         1       22m
    replicaset.apps/prometheus-kube-prometheus-operator-7fd74c7b44   1         1         1       22m
    replicaset.apps/prometheus-kube-state-metrics-6545694994         1         1         1       22m

    NAME                                                                    READY   AGE
    statefulset.apps/alertmanager-prometheus-kube-prometheus-alertmanager   1/1     22m
    statefulset.apps/prometheus-prometheus-kube-prometheus-prometheus       1/1     22m





#

