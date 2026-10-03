# 11 — Infrastructure as code and Terraform

## Wall Note / A4

Infrastructure as code makes infrastructure intent **versioned, reviewable and repeatable**.

Terraform mental model:

~~~text
configuration + prior state + provider observations → plan → reviewed apply → new state
~~~

State is operationally sensitive because it maps logical resources to real provider objects and can contain sensitive values.

Senior rules:

- keep state blast radius bounded;
- use protected remote state with locking/version history where available;
- review plans before apply;
- avoid multiple writers;
- import/adopt existing resources deliberately;
- preserve stable resource identity during refactors;
- treat replacement and destroy actions as high risk;
- design modules around coherent ownership/lifecycle boundaries.

## Detailed Notes

### Declarative IaC

IaC improves repeatability, reviewability, drift visibility and recovery documentation. It does not guarantee correctness. A destructive configuration is still destructive even when committed.

### Terraform lifecycle

~~~mermaid
flowchart LR
    H[HCL configuration] --> P[Plan]
    S[(State)] --> P
    C[Cloud/provider APIs] --> P
    P --> R{Review}
    R -->|approve| A[Apply]
    A --> C
    A --> S
~~~

### State

Terraform state tracks identity and known attributes. Use backends with encryption, access control, locking, versioning/backup and audit where supported. Never commit real tfstate.

State can contain values marked sensitive because "sensitive" mainly controls display behavior, not necessarily storage.

### Plan review

Review create/update/destroy counts, forced replacements, dependency cascades, broad network/IAM changes, data-source assumptions and provider upgrades.

A one-line HCL change can produce a large blast radius.

### Drift and authority

Drift can come from manual changes, other controllers, provider behavior or partial failure. Do not automatically "correct" drift until you know which system owns desired state.

### Import and refactoring

Import adopts existing resources into state. Resource-address/module refactors can appear as delete/create unless moved-state semantics or explicit state operations preserve identity.

### Modules

Good modules own a coherent capability, expose stable inputs/outputs and encode safe defaults. Mega-modules couple unrelated lifecycles and make every change broad.

### Workspaces and isolation

Workspaces create multiple state instances for one configuration but may not provide the account, backend, credential and blast-radius isolation desired for production.

## Practical Examples / Commands

See [examples/terraform](../examples/terraform/).

~~~bash
terraform fmt -check
terraform init
terraform validate
terraform plan -out=tfplan
terraform show tfplan
terraform apply tfplan
terraform state list
terraform providers
~~~

Never apply an old saved plan after meaningful environment/config/provider changes without checking whether it is still valid.

## Exercises / Senior Questions

1. Why is Terraform state more than a cache?
2. How do you split state to reduce blast radius without unmanageable dependencies?
3. Manual firewall drift appears in plan. Revert or adopt?
4. Which plan changes should stop automation immediately?
5. Why can a generic "everything module" hurt platform evolution?
6. Design a safe process to adopt existing resources into Terraform.

## Related / Prerequisite Links

- [software-architecture](https://github.com/YosrBennagra/software-architecture)
- [application-security](https://github.com/YosrBennagra/application-security)
- [12 — Cloud fundamentals](12-cloud-networking-load-balancing.md)
