read://https_richard-nunez.medium.com/?url=https%3A%2F%2Frichard-nunez.medium.com%2Fmy-journey-to-kubernetes-onto-bare-metal-part-4-metallb-cce4385f712d

## Seems like older version
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
## Used this one
https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

=== WARNING : policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+ === I am using 1.24



#NOT NEEDED ANYMORE ?
		## Only for the first time 
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)

