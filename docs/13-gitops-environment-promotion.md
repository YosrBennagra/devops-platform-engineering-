# 13 — GitOps and environment promotion

## Wall Note / A4

GitOps uses version-controlled **declared desired state** plus an in-environment reconciler.

Core properties:

- declarative desired state;
- versioned/auditable change;
- automated reconciliation;
- drift visibility/correction;
- pull-based environment access;
- rollback by changing desired state.

GitOps does not mean "everything must be YAML" and does not replace CI.

## Detailed Notes

A clean boundary:

~~~text
application repo → CI → immutable image digest
                         ↓
                 promotion changes desired state
                         ↓
environment repo → GitOps reconciler → cluster
~~~

~~~mermaid
flowchart LR
    G[(Git desired state)] --> R[GitOps reconciler]
    R --> C[Cluster actual state]
    C --> O[Observe drift / sync state]
    O --> R
    R -->|status| G
~~~

Do not allow another deployment system to mutate the same Kubernetes fields. One desired-state owner per surface.

### Repository patterns

Options include deployment config in app repos, separate environment repos or environment monorepos. Trade-offs: permissions, discoverability, blast radius and coupling.

### Promotion

Promotion changes the immutable reference; it should not rebuild:

~~~text
dev:     digest A
staging: digest A
prod:    digest A
~~~

### Environment drift

Keep differences intentional: scale, endpoint/identity, policy-required variation, feature configuration and secret references. Large bespoke overlays mean the platform is not actually standardized.

### Emergency changes

Break-glass changes require authorization, audit, time limit, awareness of reconciliation and follow-up source-of-truth reconciliation. Know how to pause a reconciler if it would immediately undo a deliberate emergency action.

### Secrets

Do not commit plaintext secrets. Use approved encrypted-secret or external-secret reference patterns owned with application-security.

## Practical Examples / Commands

See [examples/gitops/README.md](../examples/gitops/README.md).

~~~yaml
image:
  repository: registry.example.com/payments
  digest: sha256:new-verified-digest
~~~

Ask operationally:

~~~text
Which repository is authoritative?
Which reconciler owns this object?
What happens on invalid desired state?
Can sync safely be paused?
How are failed reconciliations surfaced?
Who may promote each environment?
~~~

## Exercises / Senior Questions

1. Why is GitOps plus kubectl-based push CD dangerous?
2. How do you perform an emergency change without permanent drift?
3. Compare app-repo and environment-repo models.
4. Why promote a digest rather than rebuild?
5. What must be true before aggressive auto-prune?
6. How do you order infrastructure and application changes?

## Related / Prerequisite Links

- [05 — CI/CD](05-ci-cd-artifacts-releases.md)
- [10 — Helm](10-helm.md)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
- [application-security](https://github.com/YosrBennagra/application-security)
