
### [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
simple key values, nested kv, multi-line data
### [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
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




