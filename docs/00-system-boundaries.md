# 00 — System boundaries and the platform mental model

## Wall Note / A4

A platform is a **delivery and runtime system**, not a pile of tools.

Think in four planes: source/intent; build/supply chain; control plane; runtime/data plane.

Senior questions:

- Who owns desired state?
- Which component reconciles actual state?
- What is the blast radius when that component or dependency fails?
- Can production still serve if the management/control plane is unavailable?

Do not automate a process you cannot explain manually. Do not add an abstraction unless it removes repeated cognitive load without hiding essential failure modes.

## Detailed Notes

DevOps is primarily a socio-technical operating model: short feedback loops and shared delivery/operational responsibility. Platform engineering productizes repeated capabilities so that model scales across teams.

A useful platform may offer service bootstrap, environment creation, artifact delivery, identity/network/storage defaults and policy integrations. It is successful because delivery is safer and simpler, not because Kubernetes or Terraform exists.

Modern platforms are reconciliation systems:

~~~mermaid
flowchart LR
    I[Declared intent] --> C[Controller / reconciler]
    C --> A[Actual state]
    A --> O[Observe]
    O --> C
    C -->|create / update / delete| A
~~~

Kubernetes controllers, Terraform plan/apply, GitOps agents and autoscalers all reconcile some desired state. Two writers owning the same field/resource create drift, flapping or surprising rollback.

Declarative systems say what should be true; imperative systems say what actions to perform. Declarative approaches excel for long-lived convergent state. Imperative steps remain useful for diagnostics, ordered migrations and break-glass operations.

A control plane can fail while workloads serve. Example: Kubernetes API unavailable may block scheduling/updates while existing Pods keep handling requests. CI outage may block delivery while production stays healthy. Separate ability to **serve** from ability to **manage**.

Reconciliation depends on idempotency. Failure-domain reasoning must cover process, container, node, zone, region, account/project, registry, identity and control-plane dependencies.

## Practical Examples / Commands

Build an ownership table:

| Resource | Desired-state source | Reconciler | Runtime | Failure domain | Rollback owner |
|---|---|---|---|---|---|
| image | source + pipeline | CI | registry | registry/project | release pipeline |
| Deployment | Git | GitOps + K8s | cluster | namespace/cluster | Git revert |
| network | Terraform | Terraform/provider | cloud | account/region | IaC change |

Trace both paths:

~~~text
request: DNS → load balancer → TLS → ingress/gateway → Service → workload → dependency
change: commit → verification → immutable artifact → registry → promotion → rollout → verify/rollback
~~~

## Exercises / Senior Questions

1. GitOps owns a Deployment while CI also runs kubectl set image. What happens?
2. Why can three replicas share one hidden failure domain?
3. When is imperative migration safer than reconciliation?
4. Draw control/data planes for a Kubernetes service behind cloud load balancing.
5. What platform capability should not be self-service?
6. Define measurable evidence that platform abstraction reduced cognitive load.

## Related / Prerequisite Links

- [software-engineer-roadmap](https://github.com/YosrBennagra/software-engineer-roadmap)
- [software-architecture](https://github.com/YosrBennagra/software-architecture)
- [system-design](https://github.com/YosrBennagra/system-design)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
