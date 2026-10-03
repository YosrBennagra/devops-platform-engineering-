# Example GitOps layout

Conceptual layout:

~~~text
environments/
  dev/demo-api-values.yml
  staging/demo-api-values.yml
  prod/demo-api-values.yml
~~~

Promotion changes the immutable artifact reference:

~~~yaml
image:
  repository: registry.example.com/demo-api
  digest: sha256:verified-content-digest
~~~

Ownership:

1. CI builds/tests once and publishes the digest.
2. Promotion proposes a desired-state change.
3. Review/policy approves it.
4. The GitOps reconciler applies it.
5. Runtime state is observed.
6. Rollback changes desired state to a known-compatible revision.

Do not simultaneously let another pipeline mutate the same Deployment with kubectl. That creates competing writers.
