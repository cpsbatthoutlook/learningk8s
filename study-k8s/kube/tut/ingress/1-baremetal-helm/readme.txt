helm repo add traefik https://helm.traefik.io/traefik
## https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-binary-distribution

helm repo update
helm install traefik traefik/traefik


OR 
helm install --namespace=traefik \
    --set="additionalArguments={--log.level=DEBUG}" \
    traefik traefik/traefik
