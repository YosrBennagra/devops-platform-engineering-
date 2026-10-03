# 06 — Deployment strategies, zero/low downtime and rollback

## Wall Note / A4

Choose deployment strategy by **failure tolerance, capacity headroom, compatibility and rollback speed**.

- **Rolling** — efficient default; old/new versions coexist.
- **Blue/green** — fast traffic switch/rollback; duplicate capacity and state compatibility required.
- **Canary** — limits blast radius with real traffic; requires trustworthy automated decision signals.

Zero downtime is an end-to-end property. Healthy replicas do not compensate for incompatible schemas, sessions, queues or dependencies.

## Detailed Notes

### Rolling deployment

Replace replicas gradually. It works well when versions coexist and spare capacity supports overlap. Common failures: incompatibility, overly aggressive rollout, readiness that passes too early and insufficient surge headroom.

### Blue/green

~~~mermaid
flowchart LR
    U[Users] --> R{Traffic switch}
    R -->|before| B[Blue v1]
    R -. after .-> G[Green v2]
    B --> DB[(Shared compatible state)]
    G --> DB
~~~

Traffic rollback is easy only if shared/external state is still compatible.

### Canary

~~~mermaid
flowchart LR
    T[Traffic] --> S{Router}
    S -->|95%| V1[v1 stable]
    S -->|5%| V2[v2 canary]
    V1 --> M[Signals]
    V2 --> M
    M --> D{Promote?}
    D -->|healthy| P[Increase]
    D -->|regression| R[Rollback]
~~~

A canary without objective promote/abort criteria is merely a slower deployment.

### Startup and termination

Startup: initialize required local state → pass startup probe if needed → become ready → receive traffic.

Termination: stop new traffic → allow bounded in-flight work → close resources → exit before grace period expires.

Liveness should detect unrecoverable stuck state, not restart every instance because a shared database is temporarily down.

### Rollback

Rollback may involve application, configuration, infrastructure, feature flags and data. Define a known-good rollback point **before** deployment and determine whether database/data changes remain backward compatible.

Feature flags separate deployment from release and can reduce blast radius, but stale flags create permanent branching complexity.

## Practical Examples / Commands

~~~bash
kubectl rollout status deployment/myapp
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp
kubectl get pods -w
~~~

~~~yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 0
    maxSurge: 1
~~~

This preserves desired capacity during rollout but requires extra schedulable headroom.

## Exercises / Senior Questions

1. Choose a strategy for a stateless API with 10% spare capacity. What changes at 100%?
2. Why can blue/green rollback fail after a schema migration?
3. Define objective canary abort criteria.
4. How can a readiness probe create false zero-downtime confidence?
5. Why does maxUnavailable: 0 still not guarantee availability?
6. Design a breaking API evolution without simultaneous client/server deployment.

## Related / Prerequisite Links

- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [system-design](https://github.com/YosrBennagra/system-design)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
