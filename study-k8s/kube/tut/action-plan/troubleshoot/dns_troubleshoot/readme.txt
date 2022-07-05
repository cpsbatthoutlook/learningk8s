https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/
https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/

#Verify that the search path and name server are set up like the following
kubectl exec -i -t dnsutils -- nslookup kubernetes.default
kubectl exec -ti dnsutils -- cat /etc/resolv.conf
kubectl exec -i -t dnsutils -- nslookup kubernetes.default

## Check if the DNS pod,svc, is running 
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns
kubectl logs --namespace=kube-system -l k8s-app=kube-dns
kubectl get svc --namespace=kube-system
kubectl get endpoints kube-dns --namespace=kube-system

## Are DNS queries being received/processed? 
kubectl -n kube-system edit configmap coredns

## Permissions:
kubectl describe clusterrole system:coredns -n kube-system

Right NS: 
kubectl exec -i -t dnsutils -- nslookup <service-name>
kubectl exec -i -t dnsutils -- nslookup <service-name>.<namespace>

