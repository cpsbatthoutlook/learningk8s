kcc create deploy ng --image=nginx --replicas=3 
kcc expose deploy ng --type LoadBalancer --port 80
kcc get all -o wide
