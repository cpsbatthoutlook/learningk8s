Refer https://www.linode.com/docs/kubernetes/deploy-container-image-to-kubernetes/

#Test
 for a in node1 node2 master;do curl -i  --connect-timeout 5 ${a}:30385; done
p=30385  #Svc

Issues:
With single replica, nodeport:svcPort works on the pod running on that Node.
with 2 replicas, on each node,  nodeport:svcPort not working. (Application is running on NodePort)

With LoadBalancer, it runs on each port.


# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
# services "chander" was not valid:
# * spec.ports[0].nodePort: Forbidden: may not be used when `type` is 'ClusterIP'

ervices "chander" was not valid:
# * spec.type: Unsupported value: "Loadbalancer": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"

# services "chander" was not valid:
# * spec.clusterIP: Forbidden: must be empty for ExternalName services
# * spec.externalName: Required value
