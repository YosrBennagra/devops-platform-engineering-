# 16 — Production troubleshooting, rollback and recovery

## Wall Note / A4

Troubleshooting is **hypothesis-driven evidence gathering**.

1. Define user-visible symptom and start time.
2. Bound blast radius.
3. Check recent changes.
4. Follow request/runtime path.
5. Compare healthy and unhealthy instances.
6. Apply the smallest reversible mitigation.
7. Preserve evidence.
8. Recover deliberately.
9. Reconcile temporary changes into source of truth.

A restart is a mutation and can destroy evidence.

## Detailed Notes

Use four diagnostic views:

- **change** — artifact, config, secret, infrastructure, dependency version;
- **resource** — CPU, memory, disk, FDs, quota;
- **traffic** — DNS, TLS, proxy, routing, Service endpoints;
- **dependency** — database, queue, external API, identity.

Compare release digest, config revision, secret version, Helm/GitOps revision, IaC changes, nodes, certificates and DNS.

Kubernetes outside-in:

1. desired/current/available workload state;
2. events;
3. scheduling;
4. restart/termination/readiness;
5. Service endpoints;
6. ingress/gateway;
7. telemetry via observability owner;
8. node/runtime when many unrelated workloads share symptoms.

Common signatures:

- CrashLoopBackOff → process/startup/liveness repeated failure.
- ImagePullBackOff → image reference, registry, network or auth.
- Pending → scheduling/volume/resource/constraint.
- OOMKilled → memory limit/pressure.
- ingress 502/503 → upstream path/endpoints/health.
- TLS → certificate/SNI/trust/protocol/time.

Prefer rollback when regression maps to a reversible release and old app/config remains compatible with data. Prefer forward fix when rollback breaks data/state compatibility.

~~~mermaid
flowchart LR
    A[Detect] --> B[Bound blast radius]
    B --> C[Collect evidence]
    C --> D{Safe mitigation?}
    D -->|rollback| R[Known-good state]
    D -->|traffic/capacity| M[Mitigate]
    D -->|forward fix| F[Patch]
    R --> V[Validate service + data]
    M --> V
    F --> V
    V --> S[Reconcile source of truth]
~~~

Escalate to node when unrelated Pods on one node fail or kubelet/runtime/network/filesystem signals point to host.

## Practical Examples / Commands

See [examples/runbooks/triage.md](../examples/runbooks/triage.md).

~~~bash
kubectl get deploy,pod -o wide
kubectl get events --sort-by=.lastTimestamp
kubectl describe pod <pod>
kubectl logs <pod> --previous
kubectl get endpointslice
kubectl rollout history deployment/<name>
kubectl diff -f desired.yml
~~~

Capture revision/output before mutating state.

## Exercises / Senior Questions

1. A new deploy correlates with errors but rollback also fails. Which hypotheses strengthen?
2. When should you drain a node?
3. Why is "restart everything" a poor diagnostic?
4. Endpoints look healthy but ingress returns 502. Where next?
5. Design a break-glass process that does not leave permanent drift.
6. What proves recovery beyond one successful health request?

## Related / Prerequisite Links

- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [engineering-toolbox](https://github.com/YosrBennagra/engineering-toolbox)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
