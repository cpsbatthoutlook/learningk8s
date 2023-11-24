##

#### SA 
```
 kc create sa test-chander 
 kc create role pod-reader --verb=list,watch,get --resource=pods,pods/status,pod/logs
 kc create rolebinding sa-pod-reader --serviceaccount=default:test-chander  --role=pod-reader
```
 -- To be continued --