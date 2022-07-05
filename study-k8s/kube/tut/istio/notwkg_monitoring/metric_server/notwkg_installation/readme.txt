# Reference : https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/

https://github.com/kubernetes-sigs/metrics-server

VPA discussion with metric-server; https://www.youtube.com/watch?v=fLXqEUI_WRg

Get metric-server: wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml;kubectl apply -f component.yaml
 OR Helm : https://artifacthub.io/packages/helm/metrics-server/metrics-server


## Troubleshooting ## 
- check the flags : docker run --rm k8s.gcr.io/metrics-server/metrics-server:v0.6.0 --help
   --kubelet-insecure-tls, --kubelet-preferred-address-types, --requestheader-client-ca-file 
