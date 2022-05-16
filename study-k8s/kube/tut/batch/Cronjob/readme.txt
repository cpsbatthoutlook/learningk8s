https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/

.spec.JobTemplate is exactly as the Job but is nested





kcc create cronjob cj1 --image=busybox:1.28 --schedule=0/5 * * * * -- /bi/nsh -c date; echo Hello From Kubernetes
