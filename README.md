# DevOps & Platform Engineering — 0 → Expert

> **Cheat sheet:** [CHEAT-SHEET.md](CHEAT-SHEET.md) (dense one-to-two-page revision sheet to print and keep on the wall)

This repository is the **DevOps / platform-engineering owner** in the interconnected software-engineering knowledge system. The master index is [software-engineer-roadmap](https://github.com/YosrBennagra/software-engineer-roadmap).

The purpose is to learn how software moves safely from source code to production and how platforms make that path repeatable. The repository is intentionally production-oriented: mechanisms, failure modes, commands, diagrams, trade-offs and senior reasoning rather than tool-list memorization.

## Repository contract

This repository owns Linux/runtime fundamentals, networking/DNS/HTTP/TLS, environments/config/secrets integration, containers/images/registries, CI/CD/artifacts/releases, deployment strategies, Kubernetes, Helm, IaC/Terraform, cloud fundamentals, load balancing/reverse proxies, GitOps, platform engineering/IDPs, supply-chain integration, backup/DR mechanics, capacity/cost awareness, production troubleshooting, rollback/recovery and senior platform architecture.

It does **not** duplicate the deep owners of observability/reliability, application security, testing, architecture, system design or general engineering tools.

## Study shape

Every important module contains:

1. **Wall Note / A4** — mental model and decision triggers.
2. **Detailed Notes** — mechanisms, trade-offs and failure modes.
3. **Practical Examples / Commands**.
4. **Exercises / Senior Questions**.
5. **Related / Prerequisite Links**.

A topic is complete only when you can explain its failure modes, operate it and justify choices under constraints.

## Complete learning order

- [ ] 00 — [System boundaries and platform mental model](docs/00-system-boundaries.md)
- [ ] 01 — [Linux, shell, processes, permissions and filesystems](docs/01-linux-shell-processes-filesystems.md)
- [ ] 02 — [Networking, DNS, HTTP/TLS and ports](docs/02-networking-dns-http-tls.md)
- [ ] 03 — [Environments, configuration and secrets](docs/03-environments-config-secrets.md)
- [ ] 04 — [Containers, Docker, images and registries](docs/04-containers-images-registries.md)
- [ ] 05 — [CI/CD, artifacts, quality gates and releases](docs/05-ci-cd-artifacts-releases.md)
- [ ] 06 — [Deployment strategies, zero downtime and rollback](docs/06-deployment-strategies-zero-downtime.md)
- [ ] 07 — [Kubernetes architecture and workloads](docs/07-kubernetes-architecture-workloads.md)
- [ ] 08 — [Kubernetes networking, configuration, storage and probes](docs/08-kubernetes-networking-config-storage-health.md)
- [ ] 09 — [Kubernetes resources, scheduling and autoscaling](docs/09-kubernetes-scheduling-autoscaling.md)
- [ ] 10 — [Helm](docs/10-helm.md)
- [ ] 11 — [Infrastructure as code and Terraform](docs/11-iac-terraform.md)
- [ ] 12 — [Cloud fundamentals, load balancing and reverse proxies](docs/12-cloud-networking-load-balancing.md)
- [ ] 13 — [GitOps and environment promotion](docs/13-gitops-environment-promotion.md)
- [ ] 14 — [Platform engineering and internal developer platforms](docs/14-platform-engineering-idp.md)
- [ ] 15 — [Supply chain, backup/DR, capacity and cost](docs/15-supply-chain-dr-capacity-cost.md)
- [ ] 16 — [Production troubleshooting, rollback and recovery](docs/16-production-troubleshooting-recovery.md)
- [ ] 17 — [Senior platform architecture and trade-offs](docs/17-senior-platform-architecture.md)
- [ ] Capstone — [Production platform exercises](exercises/capstones.md)

## Topic map

| Area | Modules | Proof of understanding |
|---|---|---|
| Host/runtime | 01 | diagnose process, CPU, memory, permissions, filesystem and sockets |
| Network path | 02 | trace DNS → route → transport → TLS → HTTP |
| Runtime configuration | 03 | separate artifact, config and secret lifecycle |
| Containers | 04 | build minimal reproducible images and reason about lifecycle |
| Delivery/releases | 05–06 | build once, promote, roll out and rollback safely |
| Kubernetes | 07–09 | explain controllers, workloads, traffic, storage, probes, scheduling and scaling |
| Packaging | 10 | maintain a narrow Helm contract |
| IaC/cloud | 11–12 | reason about state, drift, compute/network/storage/IAM and traffic |
| GitOps/platform | 13–14 | design reconciliation, promotion and paved roads |
| Production economics | 15 | connect supply chain, RPO/RTO, capacity and cost |
| Operations | 16 | evidence-first troubleshooting and safe recovery |
| Senior architecture | 17 | defend ownership, failure domains and build-vs-buy decisions |

## Repository boundaries

Deep material belongs in:

- [observability-reliability](https://github.com/YosrBennagra/observability-reliability) — telemetry, SLOs, incidents and reliability engineering.
- [application-security](https://github.com/YosrBennagra/application-security) — security engineering and threat modeling.
- [testing-engineering](https://github.com/YosrBennagra/testing-engineering) — test strategy and test systems.
- [software-architecture](https://github.com/YosrBennagra/software-architecture) — architecture styles/decisions.
- [system-design](https://github.com/YosrBennagra/system-design) — distributed system design/scaling.
- [engineering-toolbox](https://github.com/YosrBennagra/engineering-toolbox) — general tools and command references.
- [engineering-practices](https://github.com/YosrBennagra/engineering-practices) — code review, RFC/ADR, planning and team delivery practice.

**Ownership rule:** this repository is the DevOps/platform owner. It does not redirect to, rename, replace or absorb **engineering-practices**.

## Whole knowledge system

Start from [software-engineer-roadmap](https://github.com/YosrBennagra/software-engineer-roadmap), then connect this layer with [computer-science-fundamentals](https://github.com/YosrBennagra/computer-science-fundamentals), [programming-principles](https://github.com/YosrBennagra/programming-principles), [java-mastery](https://github.com/YosrBennagra/java-mastery), [spring-mastery](https://github.com/YosrBennagra/spring-mastery), [angular-mastery](https://github.com/YosrBennagra/angular-mastery), [design-patterns](https://github.com/YosrBennagra/design-patterns), [software-architecture](https://github.com/YosrBennagra/software-architecture), [system-design](https://github.com/YosrBennagra/system-design), [testing-engineering](https://github.com/YosrBennagra/testing-engineering), [application-security](https://github.com/YosrBennagra/application-security), [observability-reliability](https://github.com/YosrBennagra/observability-reliability), [engineering-toolbox](https://github.com/YosrBennagra/engineering-toolbox) and [engineering-practices](https://github.com/YosrBennagra/engineering-practices).

## Completion standard

You are approaching senior competence when, for an unfamiliar service, you can establish with evidence: artifact identity/promotion/rollback, ingress and TLS path, config/secret delivery, controller ownership, failure domains, resource/scheduling model, rollout blast radius, restore path, drift model, platform abstraction boundaries and the availability/security/speed/complexity/cost trade-offs.
