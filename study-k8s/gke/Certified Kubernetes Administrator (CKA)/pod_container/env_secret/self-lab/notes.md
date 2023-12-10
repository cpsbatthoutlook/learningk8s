###  [secret with files](secret_with_pod.yaml)

```
kc create secret generic secret1 --from-literal=user1=password1
```

[Create pod](https://kubernetes.io/docs/concepts/configuration/secret/)


###  [secret with env](secretenv_with_pod.yaml)
[multi-env example](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data)

```
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'
kubectl create secret generic db-user --from-literal=db-username='db-admin'
kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
kubectl create secret generic test-db-secret --from-literal=username=testuser --from-literal=password=iluvtests
kubectl create secret generic dev-db-secret --from-literal=username=devuser --from-literal=password='S!B\*d$zDsb='


```

