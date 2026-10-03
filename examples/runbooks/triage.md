# Production triage — platform mechanics

Use this as a thinking sequence, not a blind command checklist.

## 1. Define impact

- What user action fails?
- Since when?
- All traffic, one region, one tenant or one endpoint?
- Is data integrity at risk?

## 2. Preserve identifiers

Capture release digest, config revision, GitOps/Helm revision, infrastructure change reference, affected Pods/nodes and incident start time.

## 3. Check recent change

Compare current state to the last known-good release and desired state.

## 4. Kubernetes outside-in

~~~bash
kubectl get deploy,pod -o wide
kubectl get events --sort-by=.lastTimestamp
kubectl describe deployment <name>
kubectl describe pod <pod>
kubectl logs <pod> --previous
kubectl get svc,endpointslice
~~~

Check desired/current/available replicas, scheduling, image pulls, restarts/OOM, readiness, endpoints and shared node/zone.

## 5. Network path

~~~bash
dig <hostname>
curl -v https://<hostname>/health
openssl s_client -connect <hostname>:443 -servername <hostname>
~~~

## 6. Host/resource escalation

If multiple unrelated workloads on one node fail:

~~~bash
free -h
df -h
df -i
ss -lntup
journalctl -u kubelet --since "30 min ago"
~~~

## 7. Mitigate

Choose the smallest reversible action: rollback, reduce traffic, disable the failing feature, add bounded capacity, isolate a bad node or forward-fix when rollback is incompatible.

## 8. Validate recovery

Validate user path, runtime health and data correctness, not only a single health endpoint.

## 9. Reconcile

Represent emergency manual changes in declared source of truth or intentionally revert them. Remove temporary access and restore normal reconciliation.
