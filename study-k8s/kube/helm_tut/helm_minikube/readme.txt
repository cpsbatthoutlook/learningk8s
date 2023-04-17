https://app.pluralsight.com/course-player?clipId=bfc6a7bc-f396-4f55-b794-b46431df8ebf
https://app.pluralsight.com/course-player?clipId=bfc6a7bc-f396-4f55-b794-b46431df8ebf
Packaging Applications with Helm for Kubernetes
by Philippe Collignon

## Docker version 18.09 or better
https://minikube.sigs.k8s.io/docs/drivers/docker/
https://docs.docker.com/engine/install/centos/

sudo yum -y remove docker docker-client docker-client-latest \
     docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

## Setup repo
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
#Install docker
sudo yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
##
 systemctl start docker &&  systemctl enable docker
 sudo chmod 666 /var/run/docker.sock


## Install Minikube

https://minikube.sigs.k8s.io/docs/start/
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube config set driver docker
 minikube start --delete-on-failure=true --cpus=2 --driver=docker

##Install kubectl
##  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


## Helm installs
 https://helm.sh/docs/intro/install/
cd /tmp && curl -LO https://get.helm.sh/helm-v3.11.3-linux-386.tar.gz && tar xvfz helm-v3.11.3-linux-386.tar.gz
sudo mv /tmp/linux-386/helm  /usr/local/bin && sudo chmod +x /usr/local/bin/helm

