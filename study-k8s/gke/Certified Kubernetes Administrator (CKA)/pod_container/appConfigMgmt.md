
### [ConfigMap]|(https://kubernetes.io/docs/concepts/configuration/configmap/)
simple key values, nested kv, multi-line data
### [Secrets]|(https://kubernetes.io/docs/concepts/configuration/secret/)
hidden


# Pass configuration 
### via ENVVAR variables
* Create CM  & Secret
* Invoke from POD
```
kc create -f my-configmap.yml
kc describe configmap my-configmap

echo -n 'secret' | base64  ## c2VjcmV0
echo -n 'anothersecret' | base64 ## YW5vdGhlcnNlY3JldA==
kc create -f secret.yaml 

kc apply -f env-pod.yaml
kc logs env-pod
```

### Mounted Volume
* Create CM  & Secret
* Invoke from POD
* Check the cd /etc/config/secret ./config

```
kc create -f volume-pod.yml
kc exec volume-pod -- ls /etc/config/configmap
kc exec volume-pod -- cat /etc/config/configmap/key1
kc exec volume-pod -- cat /etc/config/configmap/key2
kc exec volume-pod -- ls /etc/config/secret
kc exec volume-pod -- cat /etc/config/secret/secretkey1
kc exec volume-pod -- cat /etc/config/secret/secretkey2
```


### Exercise
You are working for BeeBox, a company that provides regular shipments of bees to customers. The company is working on deploying some applications to a Kubernetes cluster.

One of these applications is a simple Nginx web server. This server is used as part of a secure backend application, and the company would like it to be configured to use HTTP basic authentication.

This will require an htpasswd file as well as a custom Nginx config file. In order to deploy this Nginx server to the cluster with good configuration practices, you will need to load the custom Nginx configuration from a ConfigMap (this already exists) and use a Secret to store the htpasswd data.

Create a Pod with a container running the nginx:1.19.1 image. Supply a custom Nginx configuration using a ConfigMap, and populate an htpasswd file using a Secret.

htpasswd is already installed on the server, and you can generate an htpasswd file like so:

htpasswd -c .htpasswd user
A pod called busybox already exists in the cluster, which you can use to contact your Nginx pod and test your setup.

#### Solution
* Generate an `htpasswd` File and Store It as a Secret
! the lab is tainted. You have to figure out the nginx configuration and mount it to work!!
```
htpasswd -c .htpasswd user
kc create secret generic nginx-passwd --from-file .htpasswd
rm .htpasswd
kc create cm nginx-config
```

* Create the Nginx Pod
```
kc apply -f volume-pod.yaml
kc exec -it pod/myapp -- /bin/sh
kc get pods -o wide ## Get IP

kc create deploy testpod --image=busybox:latest
kc exec busybox -- curl 192.168.194.71
kc exec busybox -- curl -u user:pwd 192.168.194.71
```



