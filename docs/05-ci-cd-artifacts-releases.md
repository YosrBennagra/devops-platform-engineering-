# 05 — CI/CD, artifacts, quality gates and release workflows

## Wall Note / A4

A strong pipeline converts **source intent into a verifiable immutable artifact**, then promotes that same artifact through controlled environments.

Properties:

- fast feedback early, expensive checks later;
- deterministic build inputs;
- immutable artifact identity;
- independent verification and promotion;
- least-privilege credentials;
- auditable release metadata;
- explicit failure and rollback behavior.

CI proves changes can be integrated. Continuous delivery keeps a verified artifact deployable; continuous deployment automatically promotes according to policy.

## Detailed Notes

### Pipeline shape

~~~mermaid
flowchart LR
    C[Commit / PR] --> F[Fast checks]
    F --> T[Test stages]
    T --> B[Build once]
    B --> S[Scan / attest]
    S --> R[Artifact registry]
    R --> D[Deploy non-prod]
    D --> V[Runtime verification]
    V --> P{Promotion gate}
    P -->|pass| PROD[Production]
    P -->|fail| STOP[Stop / fix]
~~~

If staging verifies artifact A but production rebuilds artifact B, staging did not verify production. Build once, then promote the same digest.

An artifact should carry immutable identity, source commit, digest/checksum, version and links to relevant verification/provenance evidence. CI workspaces are temporary; registries are release sources of truth.

Quality gates are policy decisions, not a contest to run every scanner. Useful gates include compilation/lint, testing criteria owned by testing-engineering, critical security/provenance policy, required review and runtime verification. A noisy irrelevant gate trains bypass behavior.

Prefer federated/short-lived pipeline identities. Separate build/read/deploy privileges. A pull-request job should not inherit production administrator credentials.

A release boundary should record artifact digest/version, config revision, migration revision, deployment time and owning change.

Database evolution can invalidate rollback. Expand/contract is the common zero-downtime sequence: add compatible shape → deploy compatible code → migrate data → remove old shape only after all consumers transition.

Failure modes: flaky pipelines, mutable tags, environment-specific rebuilds, shared admin secrets, manual artifact copies, race conditions between state-changing jobs and long serial pipelines that destroy feedback speed.

## Practical Examples / Commands

See [examples/ci/pipeline.yml](../examples/ci/pipeline.yml).

~~~yaml
release:
  version: 2.4.1
  commit: 6fe2c84
  imageDigest: sha256:...
  configRevision: 184
  migration: 2026_10_03_01
~~~

~~~bash
sha256sum artifact.tar.gz
~~~

## Exercises / Senior Questions

1. What does build-once/promote-many prevent?
2. Which checks belong before merge versus after artifact build?
3. How do you prevent PR jobs from obtaining production deploy authority?
4. Why can a destructive migration make code rollback unsafe?
5. When should a production gate be automatic versus human?
6. How do you reduce pipeline duration without reducing confidence?

## Related / Prerequisite Links

- [testing-engineering](https://github.com/YosrBennagra/testing-engineering)
- [application-security](https://github.com/YosrBennagra/application-security)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
