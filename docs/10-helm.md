# 10 — Helm

## Wall Note / A4

Helm is a **Kubernetes package/template and release manager**. Use it when resources share a versioned deployment contract.

Chart rules:

- sensible defaults;
- narrow documented values;
- stable naming/labels;
- schema validation where valuable;
- understandable rendered YAML;
- deterministic templates;
- secrets referenced/injected, not committed.

Do not turn values.yaml into a programming language.

## Detailed Notes

~~~mermaid
flowchart LR
    C[Chart templates] --> R[Helm render]
    V[values.yaml] --> R
    E[environment overrides] --> R
    R --> M[Kubernetes manifests]
    M --> A[Kubernetes API]
~~~

Debug two layers separately: rendered manifest correctness, then Kubernetes runtime behavior.

A chart normally has Chart.yaml, values.yaml, templates and optionally values.schema.json.

Values should express application/platform intent such as replicas, image digest and resources. Avoid exposing every raw Kubernetes field unless it is a deliberate escape hatch.

Helm tracks release revisions. Helm rollback reapplies previous rendered resources but cannot undo external state/database incompatibility.

Hooks add lifecycle/ordering complexity and should be deliberate. CRDs need special ownership/upgrade care. Giant umbrella charts couple unrelated dependencies.

When templates grow deeply conditional, simplify the platform contract, split charts, use overlays or introduce a higher-level platform API.

## Practical Examples / Commands

See [examples/helm](../examples/helm/).

~~~bash
helm lint examples/helm
helm template demo examples/helm
helm upgrade --install demo examples/helm --namespace demo --create-namespace
helm history demo -n demo
helm rollback demo 1 -n demo
~~~

Render locally before assuming the cluster is at fault.

## Exercises / Senior Questions

1. Which values belong to app teams versus platform policy?
2. When should a new conditional be rejected?
3. Why can Helm rollback fail to restore service?
4. How do you keep secrets out of values files?
5. Compare per-service chart, library chart and umbrella chart.
6. What belongs in schema validation versus runtime validation?

## Related / Prerequisite Links

- [07 — Kubernetes architecture](07-kubernetes-architecture-workloads.md)
- [08 — Kubernetes runtime](08-kubernetes-networking-config-storage-health.md)
- [09 — Scheduling/autoscaling](09-kubernetes-scheduling-autoscaling.md)
- [13 — GitOps](13-gitops-environment-promotion.md)
