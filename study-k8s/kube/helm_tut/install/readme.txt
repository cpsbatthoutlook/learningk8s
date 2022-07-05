### Compatibility
https://helm.sh/docs/topics/version_skew/

3.9.x	1.24.x - 1.21.x

https://github.com/helm/helm/releases/tag/v3.9.0
wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz

tar xvf helm-v3.9.0-linux-amd64.tar.gz && mv linux-amd64/helm  /usr/local/bin && chown -R vagrant:root /usr/local/bin/helm

			stable  https://charts.helm.sh/stable
			bitnami https://charts.bitnami.com/bitnami
			loki    https://grafana.github.io/loki/charts
			gitlab  https://charts.gitlab.io/
halkeye https://halkeye.github.io/helm-charts

cat /tmp/1 | while read a b;do helm repo add $a $b; done

helm version
	helm repo list
	#
	helm create mychart 
	 helm install t1 ./mychart [ --dry-run --debug ]
	  helm get manifest t1
	   helm uninstall t1
			Built-in Objects
			From <https://helm.sh/docs/chart_template_guide/builtin_objects/> 
	#Values.yaml (Built in  Values)
	   Add values and put in the chart file
	   helm install mychart [ --dry-run --debug ] 
	   helm install mychart [ --dry-run --debug ] --set favoriteDrink=slurm #Overwrite
	
	#Functions (quote  .Values.favorite.drink } 
		https://pkg.go.dev/text/template#hdr-Functions {GO functions }
		https://masterminds.github.io/sprig/ {Sprig functions}
	#Pipelines (.Values.favorite.drink | upper | quote  }
		default  | repeat | default (printf "%s-tea" (include "fullname" .))
		lookup  "v1" "Pod" "ns" "mypod"  { equiv. kc get pod -mypod n ns }
		lookup "v1"  "namespace" "" "" { equiuv kc get ns }
	#template Func. List { like module  date, dictionaries, encoding, filepath .. }
	#logic control :  empty, and, default, ge, gt, fail, coalesce 
	#flow control :  if else, with, range (like foreach),   define, template,block
	
	
	##Package
	helm package ./mychart/ --debug   #{output /home/vagrant/mychart-0.1.0.tgz}
helm install nginx1 mychart-0.1.0.tgz 
