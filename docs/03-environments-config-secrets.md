# 03 — Environments, configuration and secrets

## Wall Note / A4

Build **one immutable artifact** and promote it. Differences belong in environment configuration, policy, identity and external services.

Separate code, non-secret configuration, secrets, infrastructure configuration and runtime state.

Secret safety depends on storage, authorization, delivery, lifetime, rotation, revocation and audit — not merely on using an environment variable.

## Detailed Notes

Define each environment's purpose, differences, owners, source of truth, validation, promotion and rollback. Staging is useful only when it exercises production-like release mechanics/dependencies.

Document configuration precedence, for example:

~~~text
safe defaults < config file < injected runtime values < explicit arguments
~~~

Too many overlapping sources make effective state unclear during incidents.

Secret lifecycle: generate with adequate entropy, store in a dedicated system, authorize least privilege, deliver at runtime, avoid logs/dumps/artifacts, rotate, revoke and audit. Prefer short-lived identity-derived credentials over static keys when the platform supports them.

Environment variables are a transport mechanism, not a complete secret system; values can leak into diagnostics or logs.

ConfigMaps carry non-secret Kubernetes configuration. Kubernetes Secrets are separate objects but still require access control/encryption-at-rest and safe delivery. File projection can update; application reload behavior is still required. Environment values generally require process restart.

Promotion should reference the exact tested digest:

~~~text
staging: myapp@sha256:ABC
production: myapp@sha256:ABC
~~~

## Practical Examples / Commands

~~~yaml
http:
  port: 8080
featureFlags:
  checkoutV2: false
database:
  host: $DB_HOST
  username: $DB_USER
  # password is delivered separately by the secret mechanism
~~~

~~~bash
kubectl get configmap
kubectl get secret
kubectl describe pod <pod>
~~~

Verify secret reference/identity/version rather than printing secret values.

## Exercises / Senior Questions

1. Why is rebuilding for production weaker than promotion?
2. What fails if environments share credentials?
3. How can database credentials rotate without downtime?
4. When are environment variables acceptable for secrets?
5. Storage versus delivery of secrets?
6. How do you prove which config revision caused an incident?

## Related / Prerequisite Links

- [application-security](https://github.com/YosrBennagra/application-security)
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices)
- [08 — Kubernetes runtime configuration](08-kubernetes-networking-config-storage-health.md)
