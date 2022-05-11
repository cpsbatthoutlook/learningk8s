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
