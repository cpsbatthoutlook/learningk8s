  ##Ops view ## https://kubernetes-operational-view.readthedocs.io/en/latest/getting-started.html

  #Refer# https://github.com/hjacobs/kube-ops-view

  ## Test in isolation
  docker run -it -p 18080:8080 hjacobs/kube-ops-view --mock


  go to master
  git clone https://github.com/hjacobs/kube-ops-view.git
  kc apply -f /home/ubuntu/kube-ops-view/deploy
  ##Not Good#kc proxy --address=192.168.0.181 --port=8888
  #on Master
  kc port-forward --address 0.0.0.0 service/kube-ops-view 18080:80

  Access http://<<master>>:18080/#q