Reference: https://kubernetes.io/docs/concepts/storage/volumes/#local 
  Tut: https://medium.com/swlh/k8s-volumes-claims-part1-138012b6f52
      https://medium.com/swlh/k8s-volumes-claims-part2-70b6cefd9d5a

NFS tut:: https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs
 

https://www.youtube.com/watch?v=VB7vI9OT-WQ&t=86s
https://www.alibabacloud.com/blog/kubernetes-volume-basics-emptydir-and-persistentvolume_594834


2 types of volumes:
Ephemeral Volumes — These are tightly coupled with the Node’s lifetime (e.g., emptyDir or hostPath). They are deleted if the Node goes down.
Persistent Volumes — These are meant for long-term storage and are independent of the Pod/Node life-cycle. These can be cloud volumes (like gcePersistentDisk, awsElasticBlockStore, azureFile or azureDisk, etc.), NFS (Network File Systems), or Persistent Volume Claims (a series of abstraction to connect to the underlying cloud provided storage volumes)
 ----
  POD > PVC > PV > StorageClass > [Actual Storage]
  ----
     ACCESS MODE: ReadWriteOnce {when only 1 Node had to write}, ReadOnlyMany  {Many nodes Read}, ReadWriteMany  {RW by many nodes}
     Volume Modes:  [same between PV and PVC ] block, fs
     SELECTOR: labels selector to chose the type of storage
     CLASS: Particular Storage CLASS

    ACCESS MODE: ReadWriteOnce

## 
## From: https://kubernetes.io/docs/concepts/storage/volumes/#local

configMap
emptyDir  : When a Pod is removed from a node for any reason, the data in the emptyDir is deleted permanently.
fc (fibre channel)
glusterfs
hostPath : mounts a file or directory from the host node's filesystem into your Pod. Not recommended due to Security: 
iscsi
local : Use with nodeAffinity. represents a mounted local storage device such as a disk, partition or directory. Local volumes can only be used as a statically created PersistentVolume. Dynamic provisioning is not supported.
nfs
persistentVolumeClaim
portworxVolume
projected
rbd
secret
Using subPath
	Using subPath with expanded environment variables

Mount propagation : Shared storage with other containers or PODs
Configuration
