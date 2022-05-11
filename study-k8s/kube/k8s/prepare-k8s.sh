swapoff -a
cd ~/.ssh && cp  /kube/k8s/id_rsa .  && cp  /kube/k8s/authorized_keys . && chmod 600 id_rsa authorized_keys
cd /etc/ansible && cp /kube/k8s/inventory . && cp /kube/k8s/ansible.cfg . && chmod 600 ansible.cfg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  
ssh node1 hostname
ssh node2 hostname
echo  ansible-playbook -v -v  /kube/k8s/pre-install.yml

