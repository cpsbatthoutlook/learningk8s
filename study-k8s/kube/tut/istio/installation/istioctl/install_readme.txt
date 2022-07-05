
* Istio installation occurs in its on NS
* Need Metric system to capture the resources [ Heapster [ discontinued ], metric-server ]
* Create Service Mesh implementation [ Control Plane - Istiod {Pilot, Citadel, Mixer, Gallery } , Envoy Proxy [ Svc discovery config/cert distribute] ]



## K8s version 1.24.1  + Istio 1.14
Version	Currently Supported	Release Date	End of Life	Supported Kubernetes Versions	Tested, but not supported
1.14	Yes	May 24, 2022	~January 2023 (Expected)	1.21, 1.22, 1.23, 1.24	1.16, 1.17, 1.18, 1.19, 1.20

==INSTALLATION ISTIOCTL WAY ==
# https://istio.io/latest/docs/setup/install/istioctl/

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.14.1 TARGET_ARCH=x86_64 sh -
    #----------------
    Downloading istio-1.14.1 from https://github.com/istio/istio/releases/download/1.14.1/istio-1.14.1-linux-amd64.tar.gz ...
    Istio 1.14.1 Download Complete!
    Istio has been successfully downloaded into the istio-1.14.1 folder on your system.
    Next Steps:
    See https://istio.io/latest/docs/setup/install/ to add Istio to your Kubernetes cluster.
    To configure the istioctl client tool for your workstation,
    add the /home/vagrant/tut/istio/installation/istioctl/binaries/istio-1.14.1/bin directory to your environment path variable with:
            export PATH="$PATH:/home/vagrant/tut/istio/installation/istioctl/binaries/istio-1.14.1/bin"
    Begin the Istio pre-installation check by running:
            istioctl x precheck
    Need more information? Visit https://istio.io/latest/docs/setup/install/
    #----------------

cd istio-1.14.1
#export PATH=$PWD/bin:$PATH
export PATH="$PATH:/home/vagrant/tut/istio/installation/istioctl/binaries/istio-1.14.1/bin"
istioctl x precheck
    #-------------
        No issues found when checking the cluster. Istio is safe to install or upgrade!
        To get started, check out https://istio.io/latest/docs/setup/getting-started/
    #-------------

istioctl install [--set profile=demo -y]    ## For demo profile. There are production profiles as well
    ## Resolv.conf issue at the node level. Kubelet level  ## https://gist.github.com/superseb/f6894ddbf23af8e804ed3fe44dd48457
    ## Kubelet can be customized for certain settings including resolv.conf: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
    ##  mkdir /run/systemd/resolve; ln -s /etc/resolv.conf /run/systemd/resolve/resolv.conf; cat > /etc/resolv.conf
            # nameserver 10.0.2.3
            # nameserver 8.8.8.8
            # search home




kubectl label namespace default istio-injection=enabled  #To add Istio Injection



