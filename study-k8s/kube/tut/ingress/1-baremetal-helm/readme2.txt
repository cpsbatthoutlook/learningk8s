## https://www.devtech101.com/2019/03/02/using-traefik-as-your-ingress-controller-combined-with-metallb-on-your-bare-metal-kubernetes-cluster-part-2/

## Generate password
htpasswd -nbm admin password1234
admin:$apr1$ZywpxeoS$6U80kYPG116slxBceEsVz0

## Without Values
#helm install traefik/traefik --name=traefik --namespace=kube-system --tls \
#--set dashboard.enabled=true,serviceType=LoadBalancer,rbac.enabled=true,dashboard.auth.basic.admin='$apr1$ZywpxeoS$6U80kYPG116slxBceEsVz0',dashboard.domain=traefik.domain.com 

helm install traefik --namespace=kube-system  \
--set dashboard.enabled=true,serviceType=LoadBalancer,rbac.enabled=true,dashboard.auth.basic.admin='$apr1$ZywpxeoS$6U80kYPG116slxBceEsVz0'\
,dashboard.domain=traefik.domain.com   traefik/traefik ## --tls

## Access Traefik Dashboard
kubectl -n kube-system edit service traefik-dashboard
