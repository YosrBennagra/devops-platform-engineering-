# DevOps & Platform Engineering — Cheat Sheet

> A platform is a **delivery and runtime system**, not a pile of tools. Hub: [software-engineer-roadmap](https://github.com/YosrBennagra/software-engineer-roadmap)

**Four planes:** source/intent → build/supply chain → control plane → runtime/data plane.
**Senior questions:** Who owns the desired state? What reconciles it? What is the blast radius if it fails? Can prod still serve if the control plane is down?

## Linux triage
| Symptom | Check |
|---|---|
| High CPU | `top`/`htop`, threads, cgroup **throttling**, before you add replicas |
| High memory | cache vs working set vs leak vs cgroup limit (`free -m`, OOM in `dmesg`) |
| Disk full | `df -h` **and** `df -i` (inodes), `du -sh *` |
| Permission denied | effective UID/GID, mode bits, ACLs, mount flags (`ls -l`, `id`) |
| Port busy / sockets | `ss -tulpn`, `lsof -i :8080` |
| Logs | `journalctl -u svc -f`, `tail -f` |
- "Works as root" = a design smell.

## Network path (debug in this order)
```
name → IP → route → TCP/UDP → TLS → HTTP/gRPC → application
```
- `NXDOMAIN`/`SERVFAIL` → DNS (`dig`) · **timeout** → firewall/route/no listener path · **connection refused** → host reachable, nothing listening · TLS error → cert/SNI/trust chain/clock · got an HTTP status → transport worked, look at the app.

## Config & secrets
- **Build once, promote the same immutable artifact** (dev → staging → prod). Only config differs (12-factor).
- Separate code, config, secrets, infrastructure, runtime state.
- Secret safety = storage + authZ + delivery + lifetime + rotation + revocation + audit (Vault, cloud KMS, External Secrets).

## Containers
| Term | One line |
|---|---|
| Image | immutable layered filesystem + config (the recipe) |
| Container | running **process** with namespaces (isolation) + cgroups (limits). Not a VM |
| Registry | stores images. Deploy by **digest** (`@sha256:`), not `latest` |
| Multi-stage build | build with JDK/Node, ship a slim JRE/distroless runtime |
- Production Dockerfile: pinned base, minimal image, **non-root user**, no secrets in layers (they stay in history), `.dockerignore`, layer cache order (deps before source), exec-form `ENTRYPOINT` so SIGTERM reaches the app, graceful shutdown.
- Compose = several containers locally. Volumes for persistent data.

## CI/CD
```
commit → build → unit tests → static analysis/SCA → package (immutable, versioned) → integration/contract
→ publish artifact → deploy staging → smoke/E2E → promote prod (approval or policy) → verify → (auto) rollback
```
- **CI** = integrate often and prove it builds and passes. **Continuous Delivery** = always deployable (manual approval). **Continuous Deployment** = automatic to prod.
- Fast checks first. Deterministic builds (lockfiles). Least-privilege pipeline credentials (OIDC to cloud). Pinned actions. Release metadata (commit, version, SBOM).

## Deployment strategies
| Strategy | How | Pros | Cons |
|---|---|---|---|
| Recreate | stop old, start new | simple | downtime |
| **Rolling** (K8s default) | replace pods gradually (`maxSurge`/`maxUnavailable`) | efficient | old and new run together |
| **Blue/green** | full new env, switch traffic | instant switch/rollback | 2× capacity, shared DB must be compatible |
| **Canary** | small % of real traffic first | limits blast radius | needs trustworthy metrics to decide |
| Feature flags | deploy dark, release by flag | decouples deploy and release | flag debt |
- Zero downtime is end to end: **backward-compatible DB schema (expand/contract)**, API, sessions, messages.

## Kubernetes architecture
- **Control plane:** API server (front door) · **etcd** (state) · scheduler (places pods) · controller manager (reconcile loops).
- **Node:** kubelet (runs pod specs) · container runtime (containerd) · kube-proxy/CNI (networking).
- Desired state → controllers reconcile actual → desired, continuously.

## Kubernetes objects
| Object | Purpose |
|---|---|
| Pod | smallest schedulable unit: 1+ containers sharing network/IP + volumes |
| ReplicaSet | keeps N pod replicas (owned by a Deployment) |
| **Deployment** | stateless replicas + rolling update + rollback |
| **StatefulSet** | stable identity, ordered start, per-pod storage (DBs, Kafka) |
| DaemonSet | one pod per node (log/metrics agents) |
| Job / CronJob | run to completion / on a schedule |
| **Service** | stable virtual IP/DNS → ready pods (ClusterIP, NodePort, LoadBalancer) |
| **Ingress** / Gateway API | L7 HTTP routing from outside to Services (needs a controller) |
| ConfigMap / **Secret** | config / sensitive data (Secrets are only base64 → enable encryption at rest + RBAC) |
| PV / PVC / StorageClass | persistent storage, a claim for it, dynamic provisioning |
| Namespace | scope for names, RBAC, quotas |
| HPA / VPA | scale replicas / right-size requests |
| NetworkPolicy | pod-level firewall (default allow-all!) |
| ServiceAccount + RBAC | pod identity + permissions (Role/ClusterRole + Binding) |
- Traffic path: `client → LB → Ingress/Gateway → Service → ready Pod endpoint → container`.

## Resources & scheduling
- Scheduler places by **requests**, not real usage. No requests → overpacking.
- **CPU limit → throttling**. **Memory limit → OOMKilled**.
- QoS: **Guaranteed** (requests = limits) · Burstable · BestEffort (evicted first).
- Probes: **startup** (slow boot) · **readiness** (traffic) · **liveness** (restart). Liveness must not depend on the DB.
- HPA: target metric (CPU/custom), min/max, stabilisation window. Needs requests set and metrics-server.
- PodDisruptionBudget, anti-affinity/topology spread for high availability.

## kubectl debugging (outside → in)
```
kubectl get pods -o wide · describe pod <p> (Events!) · logs <p> [--previous] · get events --sort-by=.lastTimestamp
kubectl exec -it <p> -- sh · port-forward svc/x 8080:80 · get endpoints <svc> · top pod · rollout status/undo deploy/x
```
| Status | Usually |
|---|---|
| `Pending` | no node fits (requests, taints, PVC) |
| `ImagePullBackOff` | wrong image/tag, registry auth |
| `CrashLoopBackOff` | app exits: check `logs --previous`, config, liveness |
| `OOMKilled` | memory limit too low or a leak (JVM: `MaxRAMPercentage`) |
| Service gives no response | selector/labels don't match → empty endpoints, readiness failing |

## Helm, Terraform, GitOps
- **Helm** = templated K8s package + release history (`install/upgrade/rollback`). Keep values narrow. Never commit secrets.
- **Terraform:** `config + state + provider → plan → reviewed apply → new state`. Remote state + locking. Review every **destroy/replace**. Small state blast radius. `import` deliberately.
- **GitOps** (Argo CD / Flux): Git = desired state, an in-cluster agent **pulls** and reconciles, drift is visible, rollback = `git revert`. It doesn't replace CI.

## Platform engineering
- The platform is an **internal product**: paved roads (templates, golden paths), self-service, safe defaults, visible escape hatches.
- Measure adoption and **DORA**: deployment frequency, lead time for changes, change failure rate, time to restore.

## Production readiness
Trust what we deploy (signed, scanned, SBOM)? Restore what we can't recreate (**tested** backups, RPO/RTO)? Survive load + a failure (N+1, multi-AZ)? Know the cost curve?

## Troubleshooting loop
Symptom + start time → blast radius → **recent changes** → follow the request path → compare healthy vs unhealthy → smallest reversible mitigation → preserve evidence → recover → reconcile temp fixes back into Git.
- A restart is a mutation and **destroys evidence** (take a thread/heap dump first if possible).

## Senior gotchas
- `latest` tags. Secrets in images or Git. Running as root.
- No resource requests. A CPU limit throttling a JVM. JVM heap = the container memory limit (no headroom).
- Liveness probe checking the DB → cluster-wide restart storm.
- Manual `kubectl edit` in prod drifting from Git.
- A blue/green switch with an incompatible DB migration.
