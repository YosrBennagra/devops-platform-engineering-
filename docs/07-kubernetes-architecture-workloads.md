# 07 — Kubernetes architecture and workloads

## Wall Note / A4

Kubernetes is a **desired-state orchestration system**.

Control plane:

- API server — authoritative API front door;
- etcd — cluster state store;
- scheduler — assigns unscheduled Pods to nodes;
- controller managers — reconcile resources.

Node plane:

- kubelet — reconciles Pod specs on the node;
- container runtime — starts/stops containers;
- networking implementation — Pod traffic;
- OS/kernel — actual resource boundary.

Use Deployment for replaceable stateless replicas, StatefulSet for stable identities/ordered semantics, DaemonSet for node-local agents, Job for finite work and CronJob for scheduled Jobs. Pods are the scheduling unit. ReplicaSets are normally owned by Deployments.

## Detailed Notes

~~~mermaid
flowchart TB
    U[kubectl / GitOps / controllers] --> API[API Server]
    API <--> E[(etcd)]
    API --> CM[Controller Manager]
    API --> SCH[Scheduler]
    SCH --> API
    CM --> API

    subgraph Node A
      K1[kubelet] --> R1[container runtime] --> P1[Pods]
    end
    subgraph Node B
      K2[kubelet] --> R2[container runtime] --> P2[Pods]
    end

    API --> K1
    API --> K2
~~~

Kubernetes objects usually contain metadata, spec (desired state) and status (observed state). Avoid competing automation that writes fields another controller owns.

Pods share scheduling fate, network namespace/localhost and volumes. Multi-container Pods fit tightly coupled lifecycle/locality, not unrelated services.

A Deployment owns ReplicaSets which own Pods. Operate at the highest intended controller level.

StatefulSet gives stable ordinal identity and ordered behavior; it does not make a database correct. You still need quorum, replication, storage, backups and recovery.

DaemonSets are useful for networking/storage/node agents. Scheduling constraints still apply.

Jobs model completion and may retry; tasks should be idempotent or tolerate duplicate execution. CronJobs need concurrency/missed-schedule reasoning.

Namespaces partition names and policy scope but are not a complete hard multi-tenancy boundary.

Labels/selectors are production API. Changing labels can disconnect Services or controller ownership.

## Practical Examples / Commands

See [examples/kubernetes/app.yml](../examples/kubernetes/app.yml).

~~~bash
kubectl get nodes
kubectl get pods -A -o wide
kubectl get deploy,rs,sts,ds,job,cronjob
kubectl describe pod <pod>
kubectl get events --sort-by=.lastTimestamp
kubectl explain deployment.spec.strategy
kubectl auth can-i get pods
~~~

Inspect object status/events before immediately entering containers.

## Exercises / Senior Questions

1. Deployment says 3 desired, 3 current, 1 available. Explain each.
2. Why not manually recreate a Pod owned by Deployment?
3. When is StatefulSet the wrong answer for a database?
4. Design a retry-safe Job.
5. What happens if API server is unavailable while Pods are serving?
6. Why are labels an operational API?

## Related / Prerequisite Links

- [system-design](https://github.com/YosrBennagra/system-design)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [application-security](https://github.com/YosrBennagra/application-security)
