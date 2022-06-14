#Shutdown 1 of the nodes
curl -o dashboard.yaml  https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc3/aio/deploy/recommended.yaml
##change dashboard namespace to chander
kc apply -f dashboard.yaml
kc  edit svc kubernetes-dashboard -n chander

====  ISSUES .. retried below ==== https://github.com/kubernetes/dashboard/issues/4088
wget https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml


## How to fix the authorization (Forbidden issues)
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
Run 1-create_sa.yaml & 2-create_clusterrolebinding.yaml
kubectl -n kubernetes-dashboard create token admin-user
         kckd port-forward --address='0.0.0.0'  service/kubernetes-dashboard 9100:443




## Excellent Tutoral : https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard

## As per https://richard-nunez.medium.com/my-journey-to-kubernetes-onto-bare-metal-part-2-choosing-an-os-397df8cee364
Should have Master setup
      wget  https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
         mv recommended.yaml  k8s-dashboard.yaml
         vi k8s-dashboard.yaml
         kc apply -f k8s-dashboard.yaml
         #kubectl proxy --address='0.0.0.0'

The PODs will be in pending state
Start the 1st Node, and Join the cluster
Pods are in Ready state
	kubectl -n kubernetes-dashboard  port-forward --address='0.0.0.0'  service/kubernetes-dashboard 9100:443


AUTHENTICATION: 2 ways : {TOKEN} {KUBECONFIG}
== TOKEN ==
    ##Create the SA
    kubectl -n kubernetes-dashboard create serviceaccount dashboard-admin-chander
    ## Bind to Cluster-admin-role
    kubectl -n kubernetes-dashboard  create clusterrolebinding {NAME: dashboard-admin-chander} --clusterrole={ROLE:cluster-admin} --serviceaccount={NS:SA kubernetes-dashboard:dashboard-admin-chander}
    ## Get Secrets
    kubectl -n kubernetes-dashboard describe secret  





