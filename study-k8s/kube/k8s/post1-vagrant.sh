#cp /kube/k8s/ansible.cfg /etc/ansible
#cp /kube/k8s/inventory /etc/ansible
#        cd /kube
#        cp au*keys ~/.ssh/
#        cp id_rsa ~/.ssh/
#        chmod 600 ~/.ssh/id_rsa
ansible all -m ping 
ssh node1 "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
ssh node2 "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
ssh master  "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
ssh master  "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
ssh node1 "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
ssh node2 "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
