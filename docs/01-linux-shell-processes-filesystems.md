# 01 — Linux, shell, processes, permissions and filesystems

## Wall Note / A4

Production software becomes **processes consuming CPU, memory, files, sockets and kernel services**.

Debug: process state → CPU/memory/FDs → permissions → sockets → filesystem → kernel/cgroup constraints.

Triggers:

- High CPU: inspect work, threads and throttling before adding replicas.
- High memory: distinguish cache, working set, leak and cgroup pressure.
- Permission denied: effective UID/GID, mode bits, ACLs and mount flags.
- Disk full: bytes **and inodes**.
- "Works as root": ownership/capability design smell.

## Detailed Notes

A process has PID, parent, credentials, address space, file descriptors and scheduling state. Threads share memory but have distinct execution state.

SIGTERM requests graceful stop. SIGKILL permits no cleanup. Container orchestrators usually send TERM then KILL after a grace period, so application shutdown time must fit the platform setting.

Linux load average includes runnable tasks plus uninterruptible sleep, so high load can represent CPU or I/O contention. Inspect process/thread CPU, run queue, I/O wait, VM steal and cgroup CPU throttling.

Memory views differ: virtual memory, RSS, page cache, anonymous memory, swap and cgroup limit. Low "free" memory alone is not a leak. A container can be OOM-killed at its cgroup limit while the node still has available memory.

Sockets, files and pipes consume descriptors; leaks surface as "too many open files."

For permissions, prefer dedicated service identities, narrow group membership, read-only roots where practical, explicit writable paths and Linux capabilities rather than root.

Filesystem operations need capacity, inode, latency/IOPS, mount and persistence reasoning. Deleting a file does not free blocks while a process still holds it open.

Use shell as glue, not an application framework:

~~~bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
~~~

Quote variables, validate input and use traps for cleanup.

## Practical Examples / Commands

~~~bash
ps -eo pid,ppid,stat,%cpu,%mem,cmd --sort=-%cpu
systemctl status my-service
journalctl -u my-service --since "30 min ago"

top
free -h
vmstat 1

lsof -p <PID>
cat /proc/<PID>/limits
ss -lntup

df -h
df -i
du -xhd1 /var | sort -h
findmnt

id
namei -l /path/to/file
getfacl /path/to/file

pstree -ap
kill -TERM <PID>
~~~

Capture evidence before destructive cleanup; restarting or deleting can erase clues.

## Exercises / Senior Questions

1. Host shows 95% memory used with no swap/OOM. What determines health?
2. Container is OOMKilled while node has free memory. Explain.
3. Disk stays full after deleting a large log. Why?
4. Why is chmod 777 a dangerous fix?
5. Service needs 45 seconds to flush on TERM. What must align?
6. How can CPU throttling hurt latency before node CPU reaches 100%?

## Related / Prerequisite Links

- [engineering-toolbox](https://github.com/YosrBennagra/engineering-toolbox)
- [observability-reliability](https://github.com/YosrBennagra/observability-reliability)
- [application-security](https://github.com/YosrBennagra/application-security)
