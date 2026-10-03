# 14 — Platform engineering and internal developer platforms

## Wall Note / A4

A platform is a **product for internal engineering users**.

Principles:

- start from recurring user pain/jobs;
- provide paved roads, not mandatory mazes;
- encode safe defaults;
- allow visible escape hatches with clear responsibility;
- measure adoption, lead time, failures and cognitive load;
- version platform APIs/contracts;
- operate the platform with production discipline.

An Internal Developer Platform may include templates, service catalog, environment APIs, delivery workflows and policy integrations. A developer portal is an interface, not the platform itself.

## Detailed Notes

### Product discovery

Find repeated tasks, copied fragile infrastructure, slow approvals due to missing evidence and capabilities that should be self-service.

### Paved roads

A road might create repository skeleton, CI contract, artifact repository, environment namespace/project, baseline network policy, workload identity, deployment defaults, reliability/security integrations and ownership metadata.

### Platform API

Treat internal interfaces as APIs: documented inputs/outputs, versioning, compatibility, deprecation, support model, errors and status.

~~~mermaid
flowchart TB
    DEV[Developer] --> PORTAL[Portal / CLI / API]
    PORTAL --> ORCH[Platform orchestration]
    ORCH --> SCM[Source control]
    ORCH --> CI[CI / artifact]
    ORCH --> IAC[IaC / cloud]
    ORCH --> K8S[Kubernetes / runtime]
    ORCH --> POLICY[Policy / identity]
    K8S --> STATUS[Runtime status]
    IAC --> STATUS
    STATUS --> PORTAL
~~~

Prefer exposing real system state instead of copying everything into a stale portal database.

### Abstraction and escape hatches

Abstract repeated complexity, not essential operational truth. Developers still need to understand service resources, rollout behavior, dependencies, health and ownership.

### Multi-tenancy

Isolation can be namespace, cluster, cloud account/project/subscription, network, registry, state backend or identity domain. Stronger isolation increases cost/management but limits blast radius.

### Platform metrics

Useful metrics: time-to-first-deploy, lead time, paved-road adoption, self-service failure, support burden, upgrade lag and platform-caused change failure. "Number of templates" is a vanity metric.

### Build versus buy

Include integration, lifecycle/upgrades, security response, on-call, data/backup, switching risk and opportunity cost — not just license versus implementation time.

## Practical Examples / Commands

Conceptual platform API:

~~~yaml
apiVersion: platform.example/v1
kind: WebService
metadata:
  name: payments
spec:
  runtime: java21
  exposure: public
  scaling:
    min: 3
    max: 20
  dataClass: confidential
~~~

A good platform translates intent into lower-level resources while preserving inspectability.

## Exercises / Senior Questions

1. Team needs an unsupported feature and asks for direct Kubernetes access. What should happen?
2. Which deployment details should be abstracted versus visible?
3. Namespace versus cluster isolation?
4. Define three metrics proving the paved road is better.
5. When should a platform team reject another config option?
6. Which build-vs-buy costs are commonly forgotten?

## Related / Prerequisite Links

- [software-architecture](https://github.com/YosrBennagra/software-architecture)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
- [application-security](https://github.com/YosrBennagra/application-security)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
