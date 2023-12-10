
### [Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
#### Conatiner states
* Waiting
* Running
* Terminated

#### Pod states






### [Container probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
#### Liveness probe
Scheduled check on the container app status. If the liveness probe fails, the kubelet kills the container.
#### Startup probes
only at startup, useful for legacy applications with long startup
#### Readiness 
To determine if container is ready to accept requests. If the readiness probe fails, the endpoints controller removes the Pod's IP address from the endpoints of all Services that match the Pod.

