# 02 — Networking, DNS, HTTP/TLS and ports

## Wall Note / A4

Debug the network **path** in order:

~~~text
name → IP → route → TCP/UDP → TLS → HTTP/gRPC → application
~~~

NXDOMAIN/SERVFAIL → DNS. Timeout → route/firewall/listener/path. Refused → reachable destination without accepting listener (or explicit reject). TLS error → certificate/SNI/trust/protocol/time. HTTP status → transport completed.

## Detailed Notes

An IP belongs to a routing context. Subnets decide directly reachable peers; routes choose next hops. NAT rewrites addressing and can hide client identity. Overlapping private ranges become costly when networks must connect.

Servers bind address/port pairs. 127.0.0.1 is loopback-only; 0.0.0.0 usually listens on all IPv4 interfaces subject to policy.

TCP gives ordered reliable byte streams with flow/congestion control. UDP gives datagrams without built-in delivery. DNS often uses UDP with TCP fallback; QUIC builds secure transport over UDP.

DNS commonly passes local stub/cache → recursive resolver → authoritative server. Important records include A/AAAA, CNAME, MX, TXT, NS and SRV. TTL is cache duration. Lowering TTL at cutover cannot invalidate records already cached at the previous TTL.

HTTP operational behavior includes idempotency/retry safety, keep-alive, connection pools, proxy status, caching and bounded timeouts. Outer timeouts should not routinely expire while inner layers keep expensive work alive.

TLS authenticates/encrypts. Certificate identity must match hostname and chain to trust. SNI lets shared endpoints choose a certificate. Know exactly where TLS terminates and whether traffic is re-encrypted.

~~~mermaid
flowchart LR
    U[Client] -->|DNS| D[Resolver]
    U -->|TCP 443 + TLS/SNI| L[Load balancer]
    L -->|HTTP or TLS| G[Ingress / gateway]
    G --> S[Service]
    S --> P[Pod / process]
~~~

Host firewall, cloud policy and Kubernetes NetworkPolicy are separate enforcement layers.

## Practical Examples / Commands

~~~bash
dig example.com A
dig +trace example.com
getent hosts example.com

ip addr
ip route
traceroute <host>

ss -lntp
nc -vz example.com 443
openssl s_client -connect example.com:443 -servername example.com

curl -v https://example.com/health
curl --resolve example.com:443:203.0.113.10 https://example.com/
~~~

## Exercises / Senior Questions

1. DNS resolves and TCP connects but certificate mismatches. Which layers are healthy?
2. Why can DNS cutover send traffic to both old/new systems for a while?
3. Refused versus timeout?
4. Client timeout 10s, proxy 30s, app 60s: what is wrong?
5. Where would you terminate TLS, and when re-encrypt?
6. Build an allowed-flow matrix for ingress → API → database.

## Related / Prerequisite Links

- [system-design](https://github.com/YosrBennagra/system-design)
- [application-security](https://github.com/YosrBennagra/application-security)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
