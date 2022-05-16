alias ans="ansible -i /home/vagrant/learningk8s/Vagrant_setup/ansible/k8s_hosts "
host=/home/vagrant/learningk8s/Vagrant_setup/ansible/k8s_hosts

ansible all -i $host -m ping
ansible-playbook -b  -i $host  $xx
