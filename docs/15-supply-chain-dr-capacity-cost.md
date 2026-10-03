# 15 — Supply chain, backup/DR, capacity and cost

## Wall Note / A4

Production readiness asks:

1. Can we trust what we deploy?
2. Can we restore state we cannot recreate?
3. Can the platform survive expected load plus a failure?
4. Do we understand the cost curve in normal and failure scenarios?

Platform engineering integrates these controls; deep security and reliability material remains in their owner repositories.

## Detailed Notes

### Supply-chain integration

A delivery platform should support controlled build environments, dependency/image policy, immutable digests, provenance/attestation where appropriate, SBOM storage, isolated least-privilege workers, protected signing identity, deployment verification and registry lifecycle.

~~~mermaid
flowchart LR
    S[Source] --> B[Isolated build]
    B --> A[Artifact]
    B --> M[SBOM / provenance]
    A --> SIGN[Sign / attest]
    SIGN --> R[Registry]
    M --> R
    R --> V[Deploy-time verification]
    V --> RUN[Runtime]
~~~

A signed artifact can still be vulnerable or malicious if signing happened after a compromised build. Signature establishes identity/integrity of what was signed, not absolute safety.

### Backup versus replication

Replication improves availability but can immediately replicate deletion/corruption. Backup creates historical recovery points.

Define what, frequency, retention, encryption/access, separate failure-domain location, restore procedure and restore test cadence.

### RPO/RTO

RPO is maximum acceptable data loss measured in time. RTO is target time to restore service. These are business requirements translated into architecture.

### Disaster recovery

~~~mermaid
flowchart LR
    F[Failure / disaster] --> D[Declare]
    D --> S[Select recovery point]
    S --> I[Restore infrastructure]
    I --> DATA[Restore / fail over data]
    DATA --> APP[Deploy compatible app]
    APP --> V[Validate integrity + service]
    V --> T[Shift traffic]
    T --> R[Reconcile normal operations]
~~~

DR includes dependencies, identity, DNS, certificates, artifacts, data and runbooks — not only compute.

### Capacity

Plan steady state, peak, growth, failover, deployment surge, maintenance, autoscaler reaction and provider quotas. 100% nominal utilization has no operating margin.

### Cost awareness

Common cost drivers: compute, storage/IOPS/requests, network egress/cross-zone traffic, managed-service tiers, idle redundancy, telemetry retention and artifact/build usage.

Useful unit economics: cost/request, transaction, customer and environment. Optimize after measuring; cutting redundancy directly spends availability.

## Practical Examples / Commands

| System | State | RPO | RTO | Backup mechanism | Restore test |
|---|---|---:|---:|---|---|
| database | durable | 15 min | 1 h | snapshots + log shipping | monthly |
| registry | artifacts | 24 h | 4 h | replication/export | quarterly |

Capacity scenario:

~~~text
Normal peak: 60 replicas
One-zone loss: remaining capacity must still carry 60
Rolling surge: +10
Required schedulable capacity: at least 70
plus system overhead and safety margin
~~~

## Exercises / Senior Questions

1. Why is database replication not backup?
2. Map 15-minute RPO to a plausible recovery mechanism.
3. What can make a signed artifact unsafe?
4. How do registry retention and rollback requirements conflict?
5. Why must failover capacity enter cost planning?
6. Removing cross-zone redundancy saves 20%. What risk was accepted?

## Related / Prerequisite Links

- [application-security](https://github.com/YosrBennagra/application-security)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [system-design](https://github.com/YosrBennagra/system-design)
