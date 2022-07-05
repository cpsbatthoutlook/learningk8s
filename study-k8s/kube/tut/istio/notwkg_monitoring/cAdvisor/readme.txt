
METRIC Collection :  [Needed for HPA, VPA ]
cAdvisor > KubeLet  > Metric Svr [ Need aggregator api svc, tls-insecure setup, Webhook authentication and authorization enabled at Node, access to 10250 port ]  > Metric API [.status.daemonEndpoints.kubeletEndpoint.port, ]


cAdvisor:

## Test on a docker " https://github.com/google/cadvisor "
VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080  --detach=false  --rm --name=cadvisor --privileged --device=/dev/kmsg   gcr.io/cadvisor/cadvisor:$VERSION

## For CentOS as per this link https://github.com/google/cadvisor/blob/master/docs/running.md
docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys/fs/cgroup/cpu,cpuacct:/sys/fs/cgroup/cpuacct,cpu  --volume=/var/lib/docker/:/var/lib/docker:ro --publish=8080:8080 --detach=false --rm --name=cadvisor --privileged=true google/cadvisor:latest

Check http://localhost:8080
