# Docker Container Security
* Layered approach to protect containerized applications throughout the entire lifecyle.

## Docker Engine Security

Four major areas which affect security

* `Namespaces (NS), control groups (CG)`
  - NS's provide isolation - processes in C1 cannot interact processes in C2.
  - `Network stack` view isolated - each container has its own interfaces; NW sockets, ports, routing table, firewall rules of C1 cannot be accessed by C2 etc.
  - CG implememnt mechanism for `accounting, limiting, prioritization` of resources `(CPU, Memory, Block IO, PIDs, Network classification)`
  - Linux CFS scheduler 
    * Makes use of hierarchical structure of cgroups starting from root cgroup.
    * Select 
      - CG to RUN 
      - Task within the CG to RUN
  - NS, CG are important on `multi-tenant platforms`, like `public and private PaaS`, to guarantee a consistent `uptime and performance`.

* Docker Daemon `Attack Surface`
  - Runs with Root privileges
  - Container which has access to docker dameon socket (`/var/run/docker.sock`) for say running docker CLI (`docker in docker`)
  - Access to host filesystem via Docker container
  - Any network service like REST API etc. endpoints over HTTP - should be associated with certificates.

* Secure Container Images
  - Run Docker services in dedicated minimal footprint OS like `Bottlerock`
  - Scan for Vulnerabilities - container scanning tools
  - Use of `COPY` instead of `ADD`.
    * COPY blind copy of the file
    * ADD would extract - say ZIP or TAR file - which may contain malicious entries causing `ZIP SLIP` (e.g. `../../etc/passwd`) 
  - Implement image signing  - Enabling `docker content trust (DCT)` - so only trusted images are deployed.
  - Prevent 
    * `Poisoned images` - pull images from untrusted registry
    * `Layer attacks` - malicious lauyer in Docker image could exploit the vulnerabilities in the overlay file system

* Secure Container Run-time
  - `Run as non-root user` - prevent privilege escalation
    ```
        # Create a system user
        RUN addgroup -S appgroup && adduser -S appuser -G appgroup
        USER appuser
    ```
  - `Limit capabilities` - drop unnecessary Linux Kernel Capabilities `(--cap-drop)`
  - `Filesystem RD-Only` - Run the containers with RD-only root filesystem and explicit volumes
  - Some actions within container
    * File system operations - No mount operation, device node creation, file ownership changes etc.
    * Deny Raw sockets

* Hardening security feature of kernel and their interactions with the containers


