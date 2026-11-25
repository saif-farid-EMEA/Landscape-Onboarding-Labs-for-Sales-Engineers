# Read-more map: where to look when a customer goes deep

You won't know every answer, and nobody expects you to. You **are** expected to know *where the answer lives* and to follow up quickly.

**Official docs:** <https://canonical-landscape-documentation.readthedocs-hosted.com/en/latest/>
Page numbers refer to the PDF export of the docs (867 pages, "latest", 2026) that these labs were written from. Use the section title to search the online docs.

## By customer question

| Customer asks about… | Doc section | PDF page | Sales relevance |
|---|---|---|---|
| "What is Landscape?" | What is Landscape? / About Landscape | 6, 797 | ⭐⭐⭐ |
| Editions (SaaS / Managed / self-hosted) | About Landscape; What is Landscape? → Editions | 7–9, 797 | ⭐⭐⭐ |
| Licensing, Ubuntu Pro | Landscape licenses; How to attach your Ubuntu Pro subscription | 804, 195 | ⭐⭐⭐ |
| Supported versions, lifecycle | About self-hosted Landscape; Supported versions and PPAs | 801, 781 | ⭐⭐ |
| Hands-on trial | Getting started tutorial; SaaS account guide | 9, 38 | ⭐⭐⭐ |
| Security patching, CVEs, USNs | How to apply security patches and upgrades | 347 | ⭐⭐⭐ |
| Livepatch | Manage Livepatch and kernel updates | 254 | ⭐⭐⭐ |
| CIS / DISA-STIG compliance | How to use USG profiles | 349 | ⭐⭐⭐ |
| Profiles (all types) | Use profiles; Terms → Profiles | 255, 777 | ⭐⭐⭐ |
| Remote scripts | Use remote script execution; Explanation → Remote script execution | 259, 847 | ⭐⭐⭐ |
| Packages and snaps | Manage packages and snaps | 251 | ⭐⭐ |
| Alerts | Explanation → Alerts | 825 | ⭐⭐ |
| Activities (states, life cycle) | Explanation → Activities | 821 | ⭐ |
| RBAC, access groups, roles | Manage administrators and roles; Manage access groups; Terms | 248, 249, 775 | ⭐⭐⭐ |
| SSO: OIDC / AD / PAM | How to enable OIDC; Active Directory; PAM | 202, 200, 204 | ⭐⭐ |
| Authentication model, JWT, MFA | Authentication and authorization in Landscape | 857 | ⭐ |
| Airgapped install | How to install Landscape in an airgapped or offline environment | 121 | ⭐⭐⭐ |
| Airgapped repositories | How to manage repositories in an airgapped or offline environment | 235 | ⭐⭐ |
| Tiered / multi-region mirrors | How to create tiered repository mirrors | 238 | ⭐⭐ |
| Repository mirroring concepts | Explanation → Repository mirroring | 827 | ⭐⭐ |
| Mirroring how-to (26.04+) | Manage and mirror repositories from the web portal; end-to-end guide; Debarchive set-up | 205, 227, 145 | ⭐ |
| Network/firewall requirements | About self-hosted Landscape → Network access | 803 | ⭐⭐ |
| Sizing / system requirements | About self-hosted Landscape → System requirements | 802–803 | ⭐⭐ |
| Architecture (server internals) | Landscape Server architecture; Client architecture | 805+ | ⭐ |
| High availability | How to install and configure Landscape for high-availability deployments | 59 | ⭐⭐ |
| Juju / Terraform deployment | How to install Landscape Server with Juju; Terraform and Juju | 56+ | ⭐ |
| Cloud (GCP, Azure, AWS WorkSpaces) | Cloud providers | 16+ | ⭐ |
| Hardening Landscape itself | How to harden your Landscape deployment | 338 | ⭐⭐ |
| FIPS | Install on FIPS-compliant machines | 87 | ⭐⭐ |
| DISA-STIG-compliant install | How to install Landscape in compliance with the DISA STIG | 88 | ⭐⭐ |
| Encryption, crypto, data at rest | Cryptographic technology in Landscape; Data handling | 853, 856 | ⭐⭐ |
| Security event logs | Reference → Logs; 26.04 LTS release notes | 784, 615 | ⭐⭐ |
| Reporting a security issue | Security disclosure and reporting | 860 | ⭐ |
| Ansible comparison | Related tools: Landscape and Ansible | 860–861 | ⭐⭐⭐ |
| WSL | WSL integration; Ubuntu Pro for WSL set-up; WSL profiles | 312+, 317, 324 | ⭐⭐ |
| IoT / Ubuntu Core | IoT for devices; Ubuntu Core image with Client | 282+, 288 | ⭐⭐ |
| NVIDIA DGX Spark | Landscape and NVIDIA DGX Spark; set-up; scripts | 862, 362, 364 | ⭐⭐ |
| FDE recovery keys | Explanation → FDE recovery keys | 849 | ⭐ |
| Autoinstall / provisioning laptops | Ubuntu installer documentation | 329 | ⭐ |
| REST API / automation | How to make a REST API request; REST API reference | 351, 388+ | ⭐⭐ |
| Legacy API | How to use the legacy API | 353+ | ⭐ |
| Upgrading Landscape | How to upgrade your Landscape server | 155 | ⭐ |
| What's new | Release notes (26.10, 26.04 LTS…) | 615–623 | ⭐⭐ |
| Client troubleshooting | How to troubleshoot Landscape Client issues | 366 | ⭐ |

⭐⭐⭐ = know it cold · ⭐⭐ = know the gist and where to look · ⭐ = know it exists

## Outside the Landscape docs

| Topic | Link |
|---|---|
| Ubuntu Pro | <https://ubuntu.com/pro> · docs: <https://documentation.ubuntu.com/pro/> |
| Ubuntu Pro Client (`pro`) | <https://documentation.ubuntu.com/pro-client/en/latest/> |
| Ubuntu Security Notices / CVEs | <https://ubuntu.com/security/notices> · <https://ubuntu.com/security/cves> |
| Livepatch | <https://ubuntu.com/security/livepatch/docs> |
| USG (CIS, DISA-STIG) | <https://documentation.ubuntu.com/security/docs/compliance/usg/> |
| Ubuntu release cycle | <https://ubuntu.com/about/release-cycle> |
| Enterprise Store (snaps in restricted networks) | <https://documentation.ubuntu.com/enterprise-store/main/> |
| Ubuntu on WSL | <https://ubuntu.com/wsl/docs/latest/> |
| NVIDIA DGX Spark lifecycle | <https://docs.nvidia.com/dgx/dgx-spark/enterprise-fleet-lifecycle.html> |
| Landscape scripts collection | <https://github.com/canonical/landscape-scripts> |
| Community forum | <https://discourse.ubuntu.com/c/landscape/89> |
| Managed Landscape | <https://ubuntu.com/landscape/managed> |
