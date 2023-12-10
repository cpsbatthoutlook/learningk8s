### Multi-container pods
Not recommended but, if required, they would need to share:
* Network: container share same NS and communicate with eachother on any port [ even those not exposed ]
* Storage:  Shared volumes
[Use case](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/) :
1. side car deployment
2. cont-1 create logs and write 2 file, cont-2 read the file and display logs using [shared volumes](https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/)
3. Ambassador containers : for filtered outbound traffic
4. Adapter containers: for controlled inputs


```
apiVersion: v1
kind: Pod
metadata:
  name: two-containers
spec:

  restartPolicy: Never

  volumes:
  - name: shared-data
    emptyDir: {}

  containers:

  - name: nginx-container
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html

  - name: debian-container
    image: debian
    volumeMounts:
    - name: shared-data
      mountPath: /pod-data
    command: ["/bin/sh"]
    args: ["-c", "echo Hello from the debian container > /pod-data/index.html"]
    # kc exec -it two-containers -c nginx-container -- "curl localhost"
```

### [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

run once during startup process. Could be >1. 
Workflow: InitC-1 > InitC-2 > POD