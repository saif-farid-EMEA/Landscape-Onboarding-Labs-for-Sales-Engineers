# Glossary

Plain-English definitions of every term used in these labs. **(L)** = Landscape-specific.

| Term | Meaning |
|---|---|
| **Access group (L)** | A container of machines (and profiles and scripts) used to delegate admin rights. Every machine is in exactly one. Groups form a tree under `global`. |
| **Activity (L)** | A tracked unit of work (install a package, run a script, reboot…). States include Queued, Scheduled, Waiting, Blocked, In progress, Succeeded, Failed and Canceled. Records who requested what, when, and the result. |
| **Airgap / airgapped** | A network with no connection (or only a tightly controlled one) to the Internet. *Restricted* airgaps have a controlled path out; *fully disconnected* ones have none. |
| **Checksum (SHA-256)** | A fingerprint of a file. If one byte changes, the fingerprint changes. Used to verify files carried into an airgap. |
| **Data residency / data sovereignty** | Residency: data must be *stored* in a given place. Sovereignty: data must stay under a given jurisdiction's laws and the owner's control. |
| **Alert (L)** | A notification that something needs attention (security upgrades, reboot needed, machine offline…). Clears itself when the cause is fixed. |
| **Annotation (L)** | A key/value fact a machine reports about itself, created as files in `/var/lib/landscape/client/annotations.d/`. Searchable with `annotation:key:value`. |
| **APT** | Ubuntu's package manager for `.deb` packages (`apt update`, `apt upgrade`, `apt install`). |
| **Bearer token** | A token for mirroring Ubuntu Pro repositories. Not the same as the Pro subscription token. |
| **CIS Benchmark** | Hardening guidelines from the Center for Internet Security, usually at Level 1 and Level 2. |
| **cloud-init** | The industry-standard tool that configures cloud machines on first boot. |
| **COS** | Canonical Observability Stack, for monitoring. |
| **CVE** | Common Vulnerabilities and Exposures: the public ID of one security flaw, e.g. `CVE-2024-6387`. |
| **Debarchive (L)** | The `landscape-debarchive` service behind repository mirroring in 26.04 LTS and later. |
| **DGX Spark** | NVIDIA's compact AI computer running DGX OS (Ubuntu-based). NVIDIA recommends Landscape to manage it. |
| **DISA-STIG** | Security Technical Implementation Guides from the US Defense Information Systems Agency. |
| **ESM** | Expanded Security Maintenance (Ubuntu Pro). **ESM Infra** covers *main* beyond standard support; **ESM Apps** covers *universe*. Up to 10 years in total. |
| **Filtered mirror (L)** | A mirror that keeps only packages matching a filter expression, e.g. `Name (= hello) \| Name (= sl)`: an approved catalogue. |
| **FDE** | Full Disk Encryption. Landscape (26.04+) can manage FDE recovery keys. |
| **FIPS** | US government cryptography standard. Ubuntu Pro provides FIPS-validated packages. |
| **HA** | High availability: no single point of failure (multiple Landscape servers behind HAProxy, usually deployed with Juju). |
| **GPG key pair** | A private key that signs and a public key that verifies. Landscape signs published repositories with the customer's private key; clients verify with the public key. |
| **Hold** | Pinning a package or snap at its current version so automatic upgrades skip it. |
| **Juju / charm** | Canonical's application orchestration tool, and its packaged operators ("charms"). Used for HA Landscape deployments. |
| **Kernel** | The core of the operating system. Kernel updates normally need a reboot. |
| **Landscape Client (L)** | The agent on each managed machine (Debian package, snap or charm). |
| **Landscape Server (L)** | The central server: web portal, API, message system. |
| **Legacy web portal (L)** | Landscape's older UI. Default in 24.04–26.04 LTS. Since 26.10 the modern web portal is the default. |
| **Livepatch** | Applies high and critical kernel security fixes without a reboot (Ubuntu Pro). |
| **LTS** | Long Term Support releases (Ubuntu: every two years in April; also Landscape LTS versions). |
| **MAAS** | Metal as a Service: Canonical's bare-metal provisioning tool. |
| **main / universe** | Parts of the Ubuntu archive: *main* is Canonical-maintained; *universe* is community-maintained (security covered by Ubuntu Pro ESM Apps). |
| **Managed Landscape (L)** | Single-tenant Landscape operated by Canonical under an SLA, in public cloud or on-premises. |
| **Mirror (L)** | A local copy of a software repository. |
| **Multipass** | Canonical's tool for creating Ubuntu VMs on a laptop. |
| **Operational sovereignty** | Being able to keep operating without depending on a vendor or the Internet. |
| **OIDC** | OpenID Connect: modern single sign-on (Okta, Entra ID, Keycloak…). |
| **Package** | An installable piece of software (`.deb` on Ubuntu). |
| **PPA** | Personal Package Archive: an extra repository hosted on Launchpad. Landscape ships through PPAs. |
| **Profile (L)** | A reusable policy applied to machines by access group and tags: package, upgrade, reboot, removal, script, USG, repository, WSL. |
| **Publication / publication target (L)** | Publishing a mirror (signed, point-in-time) to filesystem, S3 or Swift storage that clients use. |
| **Quickstart (L)** | Single-machine Landscape Server install for evaluation and demos. |
| **RBAC** | Role-based access control: roles define permissions, applied to access groups. |
| **Registration key (L)** | Shared secret that lets new clients be accepted automatically. |
| **Repository** | An online store of packages. |
| **Role (L)** | A set of permissions on one or more access groups, assigned to administrators. |
| **root / sudo** | `root` is the all-powerful Linux admin user; `sudo` runs one command as root. |
| **Signature-preserving mirror (L)** | A mirror that keeps the upstream repository's original signatures (no filtering allowed). |
| **Sanitize (L)** | Irreversibly erases LUKS encryption key slots on a machine, then shuts it down. |
| **Saved search (L)** | A stored instance query (self-hosted 26.04 LTS+). |
| **Service / daemon** | A program running in the background (e.g. `landscape-client`, `ssh`). |
| **Snap** | Canonical's self-contained, auto-updating, sandboxed package format. |
| **Sneakernet** | Moving data into an airgap by physically carrying media (USB drive, DVD) through an approved process. |
| **Snapshot (mirror) (L)** | A mirror of the Ubuntu archive as it was on a specific date. |
| **Sovereign AI** | AI infrastructure, data and models kept under national or organizational control and jurisdiction. Relevant to self-hosted and airgapped Landscape. |
| **Standalone (L)** | The account name on a self-hosted Landscape server. |
| **Tag (L)** | A label on machines, used for grouping and targeting profiles. A machine can have many. |
| **Tailoring file** | A customization of a CIS or DISA-STIG benchmark (USG). |
| **Ubuntu Core** | Minimal, snap-based Ubuntu for IoT and edge devices. |
| **Ubuntu Pro** | Canonical's subscription: ESM, Livepatch, FIPS, USG, Landscape, support options. Free for 5 machines. |
| **Ubuntu Pro for WSL** | Windows app that registers WSL hosts with Landscape and attaches Pro. |
| **ufw** | "Uncomplicated firewall": Ubuntu's built-in host firewall tool, used in Lab 11 to simulate an airgap. |
| **USG** | Ubuntu Security Guide: audits and fixes against CIS and DISA-STIG (Ubuntu Pro). |
| **USN** | Ubuntu Security Notice: Canonical's announcement of a security fix, e.g. `USN-6859-1`. Can cover several CVEs. |
| **VM** | Virtual machine: a computer simulated in software. |
| **WSL** | Windows Subsystem for Linux: running Ubuntu inside Windows. |
| **Zero Trust** | Security model: never trust by default, grant least privilege, verify everything. |
