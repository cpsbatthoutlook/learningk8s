https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/

curl -LO https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
curl -LO https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml

Add them to kustomization.yaml

kubectl apply -k ./


kubectl get secrets


kubectl delete -k ./

