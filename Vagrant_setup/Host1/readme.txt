## What it does
The vagrant file will do the following:

Provision all local VMs using VirtualBox
Patch the OS
Install Docker
Install k8s control plane
Initialize cluster with Flannel CIDR block & install Flannel
Join the nodes to the master
Create and copy the SSH key to all machines so you can SSH to any node from the Master. Add names & IPs to the local hosts file on each master and node. Create alias in vagrant home for kubectl...just use k
Make required Ubuntu OS mods for the cluster to function properly

## How it does
vagrant plugin install vagrant-disksize
https://github.com/LocusInnovations/k8s-vagrant-virtualbox
cd k8s-vagrant-virtualbox
vagrant up


## NFS Server
apt-get -y install nfs-server nfs-commons
systemctl enable nfs-server
systemctl start nfs-server
  mkdir /k8s_share/vol{0..5} && chmod -R 777 /k8s_share 
edit /etc/exportfs ## /k8s_share       192.168.0.0/16(rw)
exportfs -a
showmount -e 
