### 3 types of containers
* BarePod:  Standalone Pods created manually. 
* ReplicaSet:  RS maintains the stable set of Pods
* DaemonSet:  single Pod running on every node

Jobs behavior:
* .spec.completions : # of pods should run to complete job
* .spec.parallelism : # How many parallels


https://kubernetes.io/docs/tasks/job/indexed-parallel-processing-static/
https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/
https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/
https://kubernetes.io/docs/tasks/job/parallel-processing-expansion/
