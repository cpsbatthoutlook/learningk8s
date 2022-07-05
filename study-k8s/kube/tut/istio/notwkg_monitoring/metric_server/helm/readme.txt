 ## No luck for me  in finding repo
 helm search hub metrics-server --max-col-width 1000| tr "\t"  "\n"
 #get the repo details from this location 
 $ curl -s https://raw.githubusercontent.com/helm/hub/master/config/repo-values.yaml | grep cloudbees

helm search hub metrics-server -o json | jq '.[].url' | nl
#doesn't work # helm pull  https://artifacthub.io/packages/helm/metrics-server/metrics-server           

#https://artifacthub.io/packages/helm/metrics-server/metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update metrics-server


