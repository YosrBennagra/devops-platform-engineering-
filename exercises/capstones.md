# Capstone exercises — DevOps / platform engineering

Do not answer these with tool names only. Produce architecture, failure reasoning, rollout/recovery flow and trade-offs.

## 1 — Productionize a stateless API

A Java API currently has:

- a local config file containing credentials;
- manual SSH deployment;
- no immutable artifact;
- one external database.

Design:

- image lifecycle and registry;
- CI verification and immutable identity;
- configuration/secret delivery;
- Kubernetes workload;
- Service and ingress/gateway;
- resource requests/limits;
- probes;
- rolling deployment;
- rollback;
- environment promotion.

Deliverables:

1. request-path diagram;
2. commit-to-production diagram;
3. Kubernetes manifest or Helm values;
4. at least eight concrete failure modes;
5. rollback conditions;
6. ownership table.

## 2 — Canary a risky release

A payment release changes validation behavior and raises CPU consumption.

Design the canary cohort/percentage, capacity headroom, promote/abort criteria, old/new compatibility, schema sequence, rollback and evidence required to promote.

Explain why a 5% canary can still overload a shared database or queue.

## 3 — Scheduling incident

Symptoms:

- six replicas desired;
- four running;
- two Pending;
- rollout stuck;
- cluster CPU average 45%.

Build a diagnostic tree covering requests, allocatable resources, affinity, taints/tolerations, topology spread, volumes, maxSurge and quota.

Do not assume adding nodes is correct until the unsatisfied constraint is known.

## 4 — Terraform destructive plan

A tiny module refactor produces:

~~~text
Plan: 3 to add, 2 to change, 4 to destroy
~~~

Define a safe response covering stop criteria, resource-address/state inspection, moved-resource handling, drift analysis, state backup, peer review and apply strategy.

Explain why source diff size is a poor proxy for infrastructure blast radius.

## 5 — Regional disaster recovery

System:

- multi-zone Kubernetes;
- managed relational database;
- object storage;
- external DNS;
- container registry;
- secret manager.

Business targets:

- RPO 15 minutes;
- RTO 2 hours.

Design full-region recovery: data, infrastructure, artifacts, secrets/identity, DNS/traffic, validation, failback and restore testing.

## 6 — Internal developer platform

Twenty teams maintain similar deployment code.

Design a product that provides service bootstrap, build/artifact defaults, environment provisioning, runtime contract, identity/network defaults, GitOps integration, ownership metadata and an escape hatch.

Define adoption/quality metrics and explain what should **not** be abstracted.

## Senior interview drill

Answer in this order:

1. assumptions;
2. mechanism;
3. failure modes;
4. alternatives;
5. decision under constraints;
6. evidence and rollback.

Questions:

- What happens from git push until a request reaches the new Pod?
- Kubernetes request versus limit?
- When would you avoid a CPU limit?
- Why does HPA depend on requests?
- When would you choose StatefulSet?
- How do you deploy schema changes without downtime?
- Why is Terraform state sensitive?
- When is GitOps worse than simpler CD?
- How do you avoid making an IDP a black box?
- What does production-ready mean beyond passing tests?
