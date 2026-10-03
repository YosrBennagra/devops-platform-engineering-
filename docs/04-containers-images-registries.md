# 04 — Containers, Docker, images and registries

## Wall Note / A4

A container is **a process with kernel isolation and resource controls**, not a miniature VM.

An image is an immutable filesystem/config template; a container is a runtime instance plus writable state.

Production rules: reproducible build, minimal runtime, non-root default, deliberate base/dependency pinning, no credentials in layers, digest identity, explicit entrypoint/graceful shutdown and externalized persistent state.

## Detailed Notes

Linux containers rely on namespaces, cgroups, capabilities and security mechanisms such as seccomp/LSM. They share the host kernel, so isolation differs from VMs.

Images are content-addressed layers. Build ordering affects cache reuse. Deleting a secret in a later layer does not erase the earlier layer: never copy secrets into the build context/layers.

Multi-stage builds compile in one stage and copy only runtime artifacts to the final stage, reducing attack surface and pull size.

Tags are mutable labels. Digests identify exact content. Deployments should preserve the digest even when version tags exist.

Registry operations include auth, immutability, retention/GC, replication, provenance/security metadata and deploy-time availability. Running containers may survive a registry outage; replacement/new scheduling may fail.

~~~mermaid
flowchart LR
    S[Source] --> B[Build]
    B --> I[Image]
    I --> R[Registry]
    R --> P[Pull]
    P --> C[Create]
    C --> X[Running process]
    X -->|SIGTERM| G[Graceful shutdown]
    G --> E[Exited]
    X -->|crash / OOM| E
    E -->|restart/controller| C
~~~

Container writable layers are ephemeral. Persistent state belongs in explicit volumes/services. Resource limits protect hosts but undersizing creates throttling/OOM.

## Practical Examples / Commands

The repository includes a small Docker example under examples/docker.

~~~bash
docker build -t demo:local examples/docker
docker image inspect demo:local
docker run --rm -p 8080:8080 demo:local
docker ps
docker stats
docker logs <container>
docker inspect <container>
~~~

Production diagnostics should not depend on a full shell existing in the runtime image.

## Exercises / Senior Questions

1. Why is a tag insufficient evidence of production content?
2. How does multi-stage build help operations and security?
3. Container exits every 10 seconds and restarts: why isn't that recovery?
4. Registry goes down after all Pods are running: what still works?
5. Compare VM/container isolation for hostile tenants.
6. Design registry retention that preserves rollback.

## Related / Prerequisite Links

- [application-security](https://github.com/YosrBennagra/application-security)
- [05 — CI/CD](05-ci-cd-artifacts-releases.md)
- [09 — Kubernetes resources](09-kubernetes-scheduling-autoscaling.md)
