# Modifying Helm Charts

The development team is launching a new blogging platform, and they would like to stand up a test space so they can work on the configuration of the blogging platform. You will need to create a release of a ghost blog chart that is available on a node port in your cluster. Be sure to test the release to ensure that it is accessible on your cluster.


## Create a Release of the Ghost Blog Chart from the cloud_users Home Directory
- helm show values|all .
- helm install test .  --set Service.targetPort=30080,Service.type=nodeport  --dry-run { path from value.yaml}

## Verify the Blog Is Available at the Node Port on the Cluster
```
curl http://54.92.232.180:30080
```