https://metallb.universe.tf/installation/

INSTALL > CONFIGURE 

##INSTALL
kubectl edit configmap -n kube-system kube-proxy  ## strictARP = True

#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
kc apply -f namespace.yaml
kc apply -f metallb.yaml


## Helm approach
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb
helm install metallb metallb/metallb -f values.yaml

values.yaml
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 198.51.100.0/24

##CONFIGURE    https://metallb.universe.tf/configuration/
#kc apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/example-config.yaml
	LAYER2 AND BGP HAVE DIFFERENT CONFIGURATION NEEDS

vagrant@master:~/tut/MetalLb$ diff config.yaml  original-config.yaml
<       name: metallb-ip-space
<       namespace: metallb-system
>       name: my-ip-space
---
<       protocol: layer2
>       protocol: bgp
---
<       #- 198.51.100.0/24
<       - 192.168.0.80-192.168.0.105

# kc apply -f config.yaml
# kc describe cm config -n metallb-system




