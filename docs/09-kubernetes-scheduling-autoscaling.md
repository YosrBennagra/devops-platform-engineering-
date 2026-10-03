# 09 — Kubernetes requests, limits, scheduling and autoscaling

## Wall Note / A4

Scheduling uses **requests**, not observed usage.

- CPU request: placement/capacity and CPU-share signal.
- Memory request: placement signal.
- CPU limit: can throttle.
- Memory limit: crossing it can trigger OOM kill.
- No request: scheduler can overpack.
- Bad request: wasted capacity or contention.

Autoscaling is a control loop with signal, target, min/max, delay and stabilization.

## Detailed Notes

Scheduler filters impossible nodes then scores feasible ones.

~~~mermaid
flowchart LR
    P[Pending Pod] --> F[Filter feasible nodes]
    F --> S[Score]
    S --> B[Bind]
    B --> K[Kubelet starts Pod]
~~~

Constraints include requests, selectors/affinity, taints/tolerations, topology spread and volume topology. Pending usually means some hard constraint cannot be satisfied.

Choose requests from observed usage and service behavior. CPU requests that are too low cause contention and distort HPA. Memory is non-compressible: under pressure, processes/Pods are killed or evicted.

Taints repel. A toleration permits scheduling but does not force it. Combine with affinity/selectors when dedicating nodes.

Strict anti-affinity/topology rules improve spread but can reduce availability during capacity loss if they become unsatisfiable.

HPA:

~~~mermaid
flowchart LR
    M[Metrics] --> H[HPA control loop]
    H -->|desired replicas| D[Deployment]
    D --> P[Pods]
    P --> M
~~~

CPU utilization targets are relative to requests. Reaction delay includes measurement, decision, scheduling, image pull, startup, readiness and traffic distribution. Very short spikes may require headroom/queues rather than HPA.

Node autoscaling is slower because it provisions compute. Vertical scaling changes requests and may restart workloads. Avoid controllers fighting over the same scaling dimension.

Capacity needs headroom for rolling surge, node failure, autoscaler delay, system/DaemonSet overhead and incident operations.

## Practical Examples / Commands

See [examples/kubernetes/hpa.yml](../examples/kubernetes/hpa.yml).

~~~bash
kubectl top pods
kubectl top nodes
kubectl describe pod <pending-pod>
kubectl get events --field-selector reason=FailedScheduling
kubectl get hpa
kubectl describe hpa <name>
kubectl describe node <node>
~~~

## Exercises / Senior Questions

1. Usage 200m, request 100m, target 70%: why might HPA scale?
2. Why can rollout stall although steady-state capacity is enough?
3. When can strict anti-affinity reduce availability?
4. Why can CPU limits worsen latency?
5. Design headroom for a node failure during rollout.
6. Pods scale but database connections saturate. What boundary was missed?

## Related / Prerequisite Links

- [15 — Capacity/cost](15-supply-chain-dr-capacity-cost.md)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [system-design](https://github.com/YosrBennagra/system-design)
