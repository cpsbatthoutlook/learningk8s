### [Single Job starts controller Pod](https://github.com/kubernetes/examples/blob/master/staging/spark/README.md)

```
kc -f namespace-spark-cluster.yaml #Create NS
kc apply -f master.yaml -n spark-cluster
kc apply -f worker.yaml -n spark-cluster
kc apply -f zeppelin.yaml -n spark-cluster

##Run manually
kc exec zeppelin-controller-lvhmh -it  -n spark-cluster -- pyspark

from math import sqrt; from itertools import count, islice

def isprime(n):
    return n > 1 and all(n%i for i in islice(count(2), int(sqrt(n)-1)))

nums = sc.parallelize(xrange(99990000))
print nums.filter(isprime).count()

```

