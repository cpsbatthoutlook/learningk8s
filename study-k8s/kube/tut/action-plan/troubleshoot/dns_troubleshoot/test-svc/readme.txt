https://medium.com/kubernetes-tutorials/kubernetes-dns-for-services-and-pods-664804211501

A CNAME SRC records

https://supergiant.io/blog/kubernetes-networking-services/
dhttps://github.com/supergiant
https://github.com/supergiant

svc.your-namespace.svc.cluster.local
pod-ip-address.my-namespace.pod.cluster.local
custom-host.custom-subdomain.my-namespace.svc.cluster.local.


POD & DEPLOYMENT spec.selector field of the service should match the spec.template.metadata.labels

