https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md


alias kckd='kubectl -n kubernetes-dashboard '

         kc -n $n create serviceaccount dashboard-admin-chander
         kckd create clusterrolebinding dashboard-admin-chander --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin-chander
         kckd get clusterrolebinding | grep chander
         kckd create token dashboard-admin-chander


         kckd port-forward --address='0.0.0.0'  service/kubernetes-dashboard 9100:443

