# 12 — Cloud fundamentals, networking, load balancing and reverse proxies

## Wall Note / A4

Cloud is a set of **programmable infrastructure failure domains and managed services**, not merely someone else's server.

Core areas:

- compute;
- virtual networking;
- storage;
- IAM;
- managed data/messaging/runtime services;
- regions/zones;
- quotas;
- billing.

Managed-service decision: trade some operational ownership for provider constraints, integration and dependency.

## Detailed Notes

### Compute choices

VMs, containers/orchestrators, functions/serverless and managed application platforms trade runtime control, isolation, startup latency, network capability, portability, operational staffing and cost.

### Cloud network model

~~~mermaid
flowchart TB
    I[Internet] --> EDGE[CDN / edge optional]
    EDGE --> PUB[Public load balancer]
    subgraph VPC[VPC / virtual network]
      PUB --> APP1[Private app zone A]
      PUB --> APP2[Private app zone B]
      APP1 --> DB[(Private data service)]
      APP2 --> DB
      APP1 --> NAT[NAT / controlled egress]
      APP2 --> NAT
    end
    NAT --> EXT[External APIs]
~~~

"Private subnet" is not magic. Exposure depends on addressing, routes, gateways and policy.

### IAM

Prefer federation/workload identity and separate human/workload identities. Scope permissions to required actions/resources. Deep authorization and threat modeling belong in application-security; platform ownership here is secure integration.

### Storage

Object storage is API/object based, block storage presents device-like volumes and file storage exposes shared filesystem semantics. Durability, availability, replication and recovery are separate properties.

### Managed services

Managed databases/caches/queues reduce maintenance but you still own sizing, network/access, backup/restore configuration, failover understanding, version lifecycle, quotas and cost.

### Load balancing and reverse proxying

A load balancer distributes connections/requests across targets, commonly at L4 or L7. A reverse proxy accepts client traffic and forwards upstream while applying routing, TLS, timeout, header, buffering or policy rules. Many products do both.

Balancing methods include round-robin, least-connections, weighting and hashing. Correct choice depends on request duration, keep-alive, state and unequal target capacity.

Health checks should represent ability to serve without making every target fail because one shared dependency is temporarily unavailable.

### Retry risk

Retries can improve transient reliability but amplify overload. If three proxy layers each retry three times, a single client request can create a request storm. Define one retry owner per failure class with budgets and idempotency.

## Practical Examples / Commands

Architecture checklist:

~~~text
Region/zone placement?
Ingress and TLS termination?
Public/private address ownership?
Outbound egress path?
IAM identity source?
Storage semantics?
Backup/restore owner?
Quota/capacity ceiling?
Cross-zone/region data cost?
Managed-service failure behavior?
~~~

For every proxy/load balancer document: listener, TLS, route, timeout, retries, body limits, forwarded headers and health behavior.

## Exercises / Senior Questions

1. When is a managed service a worse choice than self-managed infrastructure?
2. Why can multi-zone compute still have a single-zone dependency?
3. Object versus block storage operationally?
4. Design a private app network that needs outbound external APIs.
5. When do proxy retries amplify an outage?
6. Why can a database-dependent load-balancer health check remove every target?

## Related / Prerequisite Links

- [02 — Networking](02-networking-dns-http-tls.md)
- [system-design](https://github.com/YosrBennagra/system-design)
- [application-security](https://github.com/YosrBennagra/application-security)
