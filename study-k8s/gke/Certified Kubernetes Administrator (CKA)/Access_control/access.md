## [Role/Role bindings | ClusterRole/ClusterRoleBindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/ )

### Cmds 
```
kc create role/clusterrole pod-reader --verb=get,list,watch --resource=pods,pods/status [-n namespace] [--resource-name=readablepod --resource-name=anotherpod ]

kc create rolebinding bob-admin-binding --clusterrole=admin [ --user=bob | --serviceaccount=acme:myapp ] [-n acme ]
```
### Subjects to the role binding
```
kind: User,Group, ServiceAccount,
## All SA in QA ns 
kind: Group
name: system:serviceaccounts:qa  

## All SA in any ns 
kind: Group
name: system:serviceaccounts

## All Authenticated users
kind: Group
name: system:authenticated

## All Unauthenticated users
kind: Group
name: system:unauthenticated

## All  users
Use both system:authenticated & system:unauthenticated
```

