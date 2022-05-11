echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc
echo  >> ~/.bashrc
#kc completion bash >> ~/.bashrc
echo "alias kc=kubectl" >> ~/.bashrc
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'complete -F __start_kubectl kc' >>~/.bashrc
echo "alias ka=kubeadm" >> ~/.bashrc
kubeadm completion bash >/etc/bash_completion.d/kubeadm
echo 'source <(kubeadm completion bash)' >> ~/.bashrc
echo 'complete -F __start_kubeadm ka' >>~/.bashrc
