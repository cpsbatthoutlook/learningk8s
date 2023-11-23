https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/



#-----------Base64 encode
echo -n 'my-app' | base64
echo -n '39528$vdg7Jb' | base64
 kubectl get secret db-user-pass -o jsonpath='{.data}'  ## https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/#use-source-files
 kc get secrets test-db-secret -o json | jq .data.password
#-----------Create Secret
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
data:
  username: bXktYXBw
  password: Mzk1MjgkdmRnN0pi
#-----------Create Manually
kc create secret generic test-secret --from-literal='username=my-app' --from-literal='password=39528$vdg7Jb'
#-----------Create from File
 #https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/
echo -n 'admin' > ./username.txt
echo -n 'S!B\*d$zDsb=' > ./password.txt

kubectl create secret generic db-user-pass  --from-file=./username.txt  --from-file=./password.txt ##Default keyname is filename
kubectl create secret generic db-user-pass --from-file=username=./username.txt --from-file=password=./password.txt


OR
 #https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-config-file/
cat > secret_test.cfg
apiUrl: "https://my.api.com/api/v1"
username: "<user>"
password: "<password>"

---- secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:
  config.yaml: |
    apiUrl: "https://my.api.com/api/v1"
    username: <user>
    password: <password>    

#-----------Apply
kc get [secret ]
#----------- Access through POD
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
spec:
  containers:
    - name: test-container
      image: nginx
      volumeMounts:
        # name must match the volume name below
        - name: secret-volume
          mountPath: /etc/secret-volume
          readOnly: true
  # The secret data is exposed to Containers in the Pod through a Volume.
  volumes:
    - name: secret-volume
      secret:
        secretName: test-secret
#-----------Access within PoD
kubectl exec -i -t secret-test-pod -- /bin/bash
ls /etc/secret-volume
# Run this in the shell inside the container
echo "$( cat /etc/secret-volume/username )"
echo "$( cat /etc/secret-volume/password )"
#----------- control the paths within the volume 
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: test-secret
      items:
      - key: username
        path: my-group/my-username
#.spec.volumes[].secret.items
#-----------Define container environment variables using Secret data 
#kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'
apiVersion: v1
kind: Pod
metadata:
  name: env-single-secret
spec:
  containers:
  - name: envars-test-container
    image: nginx
    env:
    - name: SECRET_USERNAME
      valueFrom:
        secretKeyRef:
          name: backend-user
          key: backend-username
#kubectl exec -i -t env-single-secret -- /bin/sh -c 'echo $SECRET_USERNAME'
#-----------Define container environment variables with data from multiple Secrets 
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'
kubectl create secret generic db-user --from-literal=db-username='db-admin'

apiVersion: v1
kind: Pod
metadata:
  name: envvars-multiple-secrets
spec:
  containers:
  - name: envars-test-container
    image: nginx
    env:
    - name: BACKEND_USERNAME
      valueFrom:
        secretKeyRef:
          name: backend-user
          key: backend-username
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-user
          key: db-username

#kubectl exec -i -t envvars-multiple-secrets -- /bin/sh -c 'env | grep _USERNAME'

#-----------Configure all key-value pairs in a Secret as container environment variables - envFrom
kubectl create secret generic test-secret --from-literal=username='my-app' --from-literal=password='39528$vdg7Jb'

apiVersion: v1
kind: Pod
metadata:
  name: envfrom-secret
spec:
  containers:
  - name: envars-test-container
    image: nginx
    envFrom:
    - secretRef:
        name: test-secret

kubectl exec -i -t envfrom-secret -- /bin/sh -c 'echo "username: $username\npassword: $password\n"'

#----------- Provide prod/test credentials to Pods using Secrets
kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
kubectl create secret generic test-db-secret --from-literal=username=testuser --from-literal=password=iluvtests
kubectl create secret generic dev-db-secret --from-literal=username=devuser --from-literal=password='S!B\*d$zDsb='  ## Special Character, --from-file is better
kubectl create secret generic fromfile-db-user-pass --from-file=username=./username.txt --from-file=password=./password.txt

apiVersion: v1
kind: List
items:
- kind: Pod
  apiVersion: v1
  metadata:
    name: prod-db-client-pod
    labels:
      name: prod-db-client
  spec:
    volumes:
    - name: secret-volume
      secret:
        secretName: prod-db-secret
    containers:
    - name: db-client-container
      image: myClientImage
      volumeMounts:
      - name: secret-volume
        readOnly: true
        mountPath: "/etc/secret-volume"
- kind: Pod
  apiVersion: v1
  metadata:
    name: test-db-client-pod
    labels:
      name: test-db-client
  spec:
    volumes:
    - name: secret-volume
      secret:
        secretName: test-db-secret
    containers:
    - name: db-client-container
      image: myClientImage
      volumeMounts:
      - name: secret-volume
        readOnly: true
        mountPath: "/etc/secret-volume"

### You could further simplify the base Pod specification by using two service accounts:



#-----------
#-----------
#-----------
#-----------
#-----------