# my learning: K8s, Helm

## My Setup
Host { Quad Core/64GB RAM/ 1.5TB } - hosting  master, node1-3
Host2 { Dual Core/16GB/ 2TB } - hosting jnode3-5
Networking : Host { 192.168.0. 20-28 }
Overlay Networking :  Flannel   10.244.0.0/16
Host OS  : Ubuntu 16.04.7
Vagrant : Version: 2.2.19
Vagrant plugins : 
   vagrant-disksize (0.1.3, global)
   vagrant-vbguest (0.30.0, global) [ 0.21 on host2 ]
VirtualBox:  6.1.34r150636
VirtualBox image {Host}:   ubuntu/xenial64
VirtualBox image {Host2}:  bento/ubuntu-16.04  

##  K8s Versions
* Client Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:46:05Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.4
* Server Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:38:19Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}
* Docker  Client: Version:           18.09.7

