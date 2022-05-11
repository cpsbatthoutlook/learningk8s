#https://www.edureka.co/blog/kubernetes-ingress-controller-nginx



Using this one https://kubernetes.github.io/ingress-nginx/deploy/#prerequisite-generic-deployment-command
1. wget  https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.28.0/deploy/static/mandatory.yaml 
2.  kubectl apply -f mandatory.yaml

Using NodePort
3. wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.28.0/deploy/static/provider/baremetal/service-nodeport.yaml
4. kubectl apply -f service-nodeport.yaml

To Verify
5. kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

To detect:
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version


