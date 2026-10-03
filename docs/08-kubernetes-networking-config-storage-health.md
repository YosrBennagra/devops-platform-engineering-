# 08 — Kubernetes networking, configuration, storage and health

## Wall Note / A4

Traffic path:

~~~text
client → load balancer → ingress/gateway → Service → ready Pod endpoint → container
~~~

Configuration: ConfigMap for non-secret data; Secret for sensitive API objects that still require RBAC/encryption/safe delivery.

Storage: emptyDir for Pod-lifetime data; PVC for persistent storage requests.

Health:

- startup probe — did slow startup finish?
- readiness probe — may this endpoint receive traffic?
- liveness probe — is this process unrecoverably stuck?

Do not make liveness depend on every downstream service.

## Detailed Notes

Pods are ephemeral; Services provide stable identity over selected endpoint sets. ClusterIP/NodePort/LoadBalancer represent different exposure patterns. A Service may be valid but have zero endpoints because its selector matches no ready Pods.

Ingress/Gateway resources describe routing policy; a compatible controller must implement them.

~~~mermaid
flowchart LR
    E[External client] --> LB[Cloud / edge LB]
    LB --> IC[Ingress / Gateway controller]
    IC -->|host/path| SVC[Service]
    SVC --> EP[EndpointSlice]
    EP --> P1[Ready Pod]
    EP --> P2[Ready Pod]
~~~

Gateway API often offers richer role/routing separation than classic Ingress. Choose based on requirements and implementation maturity/support.

NetworkPolicy restricts flows only when the CNI enforces it. Start from explicit required flows and test DNS/control dependencies.

ConfigMaps/Secrets can be injected as environment variables or mounted files. Mounted projections may update, but applications need reload behavior. Environment variable changes usually require restart.

PV represents storage; PVC requests it; StorageClass enables dynamic provisioning. Understand access mode, reclaim policy, zone/topology, snapshots, expansion, latency and consistency. A Bound PVC is not a backup.

~~~mermaid
stateDiagram-v2
    [*] --> Starting
    Starting --> Ready: startup succeeds + readiness true
    Starting --> Restart: startup fails threshold
    Ready --> NotReady: readiness false
    NotReady --> Ready: readiness true
    Ready --> Restart: liveness fails threshold
    NotReady --> Restart: liveness fails threshold
~~~

Graceful termination coordinates readiness removal, endpoint propagation, SIGTERM and termination grace.

## Practical Examples / Commands

~~~bash
kubectl get svc,ingress,gateway 2>/dev/null
kubectl get endpointslice
kubectl get networkpolicy
kubectl get configmap,secret
kubectl get pvc,pv,storageclass
kubectl describe pvc <claim>
kubectl get pod <pod> -o yaml
~~~

## Exercises / Senior Questions

1. Service has ClusterIP but zero endpoints. What first?
2. Why is database health often wrong as a liveness check?
3. What happens when a file-mounted secret rotates?
4. Why does a Bound PVC not solve DR?
5. Design routing for two API versions.
6. How can a NetworkPolicy accidentally break DNS?

## Related / Prerequisite Links

- [02 — Networking](02-networking-dns-http-tls.md)
- [application-security](https://github.com/YosrBennagra/application-security)
- [15 — Recovery](15-supply-chain-dr-capacity-cost.md)
