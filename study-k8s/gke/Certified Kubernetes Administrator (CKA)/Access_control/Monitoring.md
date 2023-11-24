


## Install Kubernetes Metrics Server
Install the metric server
```
kc apply -f https://raw.githubusercontent.com/ACloudGuru-Resources/content-cka-resources/master/metrics-server-components.yaml
```
Verify metric server
kc get --raw /apis/metrics.k8s.io/

## Locate the CPU-Using Pod and Write Its Name to a File
```
kc top pod -n beebox-mobile --sort-by cpu --selector app=auth
echo auth-proc > /home/cloud_user/cpu-pod-name.txt
```