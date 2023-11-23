# [ Hooks/Testing/Libraries](https://helm.sh/docs/topics/charts_hooks/)
# Lab
You have a chart that was created by your developers, and they would like you to create a service test for it. This is a proof-of-concept, so only the minimal test needs to be run. In this case, the test will simply ensure the service is available and connecting to the application.

## Create the Manifest for the Test in the Ghost Chart's Default Location
This test should be named,  needs the correct annotations,  use the busybox container image, use the wget command, target the service at its name and port

- 




# Overview
## use-case
* load the data after the pod is created
* back up the data before the upgrade happens
* stage environment, pre-post activities.
## Various hook-types
* pre-install : b4 object instantiate after the template is rendered
* post-install : after object instantiated
* pre-/post-delete:  b4/after delete request to any object
* pre-/post-upgrde: 
* pre-/post-rollback
* test
### important info
* hook is a normal template with special annotations to define hook.
* hooks are create in the template section of charts
* hooks have wieght, lowest weight will run 1st, best practice: set to 0 if not important
* failure of hook will fail everything
* multiple hooks can be defined.
* hooks object stand alone, can persist after release is deleted so cleaup should be considered.
### Examle ./web.. hooks.yaml
#### post-install
  annotations:
    "helm.sh/hook": "post-install"
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded

# [ Chart tests ](https://helm.sh/docs/topics/chart_tests/ )
### Example util.yaml
#### testing, validte password, svc , configuration 
!---- template/utils.yaml  ---!
apiVersion: v1
kind: Pod
metadata:
  name: dnsutils
  namespace: default
spec:
  containers:
  - name: dnsutils
    image: gcr.io/kubernetes-e2e-test-images/dnsutils:1.3
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
  restartPolicy: Always

- helm test pkg1  ## run the template/test/test-connection
  annotations:
    "helm.sh/hook": test



# [ Libraries  ](https://helm.sh/docs/topics/library_charts/)
## How to create library { if version changes, it will clobber up entire chart}
- helm repo add incubator https://charts.helm.sh/incubator
- helm search repo common
- helm create demo ; vi demo/Charts.yaml
    - name: common
      version: "^0.0.5"
      repository: "https://charts.helm.sh/incubator"
-  cd demo;helm dependency update
### it create common.tgz in ./charts/
-  now you can edit your templates to put common elements in:
{{- template "common.deployment" (list . "demo.deployment") -}}
{{- define "demo.deployment" -}}
{{- end}}
