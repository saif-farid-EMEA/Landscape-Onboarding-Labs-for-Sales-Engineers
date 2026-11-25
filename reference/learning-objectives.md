# Learning objectives and coverage

This page shows, for every course-level **learning outcome**, which lab objectives build it, where each objective is taught, and how it's checked. If you change a lab, update its objectives table and this page together (see [CONTRIBUTING.md](../CONTRIBUTING.md)).

## Learning outcomes

| ID | Outcome | Description | Lab objectives |
|---|---|---|---|
| PO1 | **Linux fluency** | Use an Ubuntu terminal for basic tasks and explain the Linux concepts that come up on calls: packages and repositories, `sudo`, services, the kernel, CVEs and USNs. | 12 |
| PO2 | **Positioning** | Explain what Landscape is, how it works, its three editions and how it's licensed through Ubuntu Pro, and recommend an edition from a customer's requirements. | 12 |
| PO3 | **Build** | Deploy a self-hosted Landscape demo environment and enroll machines with both manual and automated registration. | 10 |
| PO4 | **Demonstrate core capabilities** | Demonstrate inventory and search, security patching and Livepatch, remote scripts, package and profile policy, CIS/DISA-STIG compliance and RBAC in the web portal, and explain the value of each. | 34 |
| PO5 | **Specialized environments** | Explain sovereign and airgapped architectures, repository mirroring, and how Landscape covers desktops, WSL, IoT devices and AI hardware. | 10 |
| PO6 | **Sell** | Run discovery, deliver a tailored 20-minute demo, recover from demo failures and handle common objections accurately. | 16 |
| PO7 | **Self-sufficiency** | Find answers in the official documentation, troubleshoot common problems and keep a demo environment healthy. | 7 |

## Outcome → lab objectives

### PO1: Linux fluency

| Objective | Lab | Checked by |
|---|---|---|
| **L00-3** **Explain** what a virtual machine is in one sentence a customer would understand. | [Lab 00: Start here](../labs/00-start-here.md) | Check yourself Q3 |
| **L01-1** **Open** a shell in an Ubuntu VM, **read** the prompt and **navigate** the filesystem with `pwd`, `ls`, `cd` and `cat`. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Checkpoints, Parts A and B · Check yourself Q4 |
| **L01-2** **Edit** a text file with `nano` and **run** commands as root with `sudo`, and **explain** why broad `sudo` access is a security risk. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Checkpoint, Part C · Check yourself Q5 |
| **L01-3** **Explain** packages and repositories (including *main* vs. *universe*) and the difference between `apt update` and `apt upgrade`. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Check yourself Q1, Q6 |
| **L01-4** **Explain** what a CVE and a USN are and how they relate. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Check yourself Q2 |
| **L01-5** **Explain** why kernel updates usually need a reboot and what Livepatch changes. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Check yourself Q3 |
| **L01-6** **Recognize** snaps and services, and **check** whether a service is running. | [Lab 01: Linux survival kit](../labs/01-linux-survival-kit.md) | Check yourself Q7 |
| **L03-2** **Explain** what a PPA is and **choose** between the LTS and latest-stable Landscape PPAs. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Check yourself Q5 |
| **L04-1** **Install** Landscape Client and **explain** each setting in `client.conf`. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Checkpoints, Part B · Check yourself Q3, Q4 |
| **L04-6** **Diagnose** a failed registration using the client's configuration file and logs. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Check yourself Q6 |
| **L06-2** **Interpret** a USN (the CVEs it fixes, priority, affected releases) and **explain** where Landscape's security data comes from. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Checkpoint, Part A · Check yourself Q1, Q6 |
| **L09-1** **Explain** CIS Benchmarks, DISA-STIG, USG and tailoring files in plain language. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Check yourself Q4, Q5 |

### PO2: Positioning

| Objective | Lab | Checked by |
|---|---|---|
| **L00-2** **Explain** how Landscape relates to Ubuntu Pro and what the free tier includes. | [Lab 00: Start here](../labs/00-start-here.md) | Check yourself Q1, Q2 |
| **L02-1** **Describe** Landscape in one sentence and **name** who uses it. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Whiteboard exercise |
| **L02-2** **Explain** the client–server architecture, including activities and the fact that clients connect outbound. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Whiteboard exercise · Check yourself Q2, Q4 |
| **L02-3** **Match** Landscape's capability pillars to the customer problems they solve. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q5 |
| **L02-4** **Compare** SaaS, Managed and self-hosted Landscape and **recommend** one from customer requirements. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q1, Q3 |
| **L02-5** **Explain** how Landscape is licensed through Ubuntu Pro. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q6 |
| **L02-6** **Position** Landscape against Ansible and within the Canonical portfolio. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q7 |
| **L02-7** **Explain** the difference between Landscape LTS and latest-stable releases. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q8 |
| **L03-6** **Contrast** a Quickstart lab install with production deployment options. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Check yourself Q3 |
| **L04-5** **Describe** the options for registering machines at scale. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Check yourself Q5 |
| **L05-4** **Attach** Ubuntu Pro from the web portal and **explain** what that changes on the machines. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Checkpoint, Part D · Check yourself Q3 |
| **L10-4** **Explain** the single sign-on options and what Landscape does and doesn't take from the identity provider. | [Lab 10: RBAC and access control](../labs/10-rbac-and-access-control.md) | Check yourself Q3, Q6 |

### PO3: Build

| Objective | Lab | Checked by |
|---|---|---|
| **L00-1** **Set up** the accounts and tools the labs need: an Ubuntu One account, a free Ubuntu Pro token and Multipass. | [Lab 00: Start here](../labs/00-start-here.md) | Checkpoint, section 3 |
| **L00-4** **Choose** the full or light lab path based on your laptop's resources. | [Lab 00: Start here](../labs/00-start-here.md) | Section 4 |
| **L03-1** **Create** a VM with Multipass and **find** its IP address. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Checkpoint, Step 1 |
| **L03-2** **Explain** what a PPA is and **choose** between the LTS and latest-stable Landscape PPAs. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Check yourself Q5 |
| **L03-3** **Install** Landscape Server in Quickstart mode and **name** the components it installs. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Checkpoint, Step 5 · Check yourself Q1 |
| **L03-4** **Configure** the background-service snaps required since 26.04 and **verify** that every service is running. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Checkpoints, Step 6 · Check yourself Q6 |
| **L03-5** **Create** the first administrator and **identify** the self-hosted account name. | [Lab 03: Build your demo server (self-hosted Landscape)](../labs/03-build-your-demo-server.md) | Checkpoint, Step 8 · Check yourself Q2, Q4 |
| **L04-1** **Install** Landscape Client and **explain** each setting in `client.conf`. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Checkpoints, Part B · Check yourself Q3, Q4 |
| **L04-2** **Register** a machine and **accept** it manually in the web portal. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Checkpoint, Part B5 · Check yourself Q1 |
| **L04-3** **Register** machines automatically with a registration key. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Checkpoint, Part C3 · Check yourself Q1 |

### PO4: Demonstrate core capabilities

| Objective | Lab | Checked by |
|---|---|---|
| **L04-4** **Explain** the safeguards around remote script execution on clients. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Check yourself Q2 |
| **L05-1** **Deliver** a 60-second estate-overview opener from the Overview page. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Check yourself Q5 |
| **L05-2** **Search** for instances with query prefixes (`tag:`, `distribution:`, `alert:`…) and **save** a search. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Saved search in Part B · Check yourself Q1 |
| **L05-3** **Find** any detail about a machine (OS, kernel, hardware, packages) in under 15 seconds. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Checkpoint, Part C |
| **L05-4** **Attach** Ubuntu Pro from the web portal and **explain** what that changes on the machines. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Checkpoint, Part D · Check yourself Q3 |
| **L05-5** **Organize** machines with tags and **distinguish** tags, access groups and annotations. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Checkpoint, Part E · Check yourself Q2 |
| **L05-6** **Configure** alert subscriptions and **explain** the main alerts. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Offline test in Part F · Check yourself Q4 |
| **L06-1** **Identify** every machine with outstanding security updates, in at least two ways. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Checkpoint, Part A · Check yourself Q5 |
| **L06-2** **Interpret** a USN (the CVEs it fixes, priority, affected releases) and **explain** where Landscape's security data comes from. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Checkpoint, Part A · Check yourself Q1, Q6 |
| **L06-3** **Apply** security fixes to one machine and to many, and **explain** the difference between the bulk options. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Checkpoints, Parts D and E · Check yourself Q2 |
| **L06-4** **Interpret** the Kernel tab's Livepatch statuses. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Check yourself Q3 |
| **L06-5** **Deliver** the 5-minute security demo, including how to prove a fix to an auditor. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Practice table · Check yourself Q4 |
| **L07-1** **Add** a script, **run** it on selected machines and **read** its output in Activities. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Checkpoints, Parts A and B · Check yourself Q5 |
| **L07-2** **Explain** the safeguards around remote script execution. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Check yourself Q1 |
| **L07-3** **Create** annotations with a script, **search** by annotation and **distinguish** annotations from tags. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Checkpoint, Part C · Check yourself Q2 |
| **L07-4** **Fix** one specific CVE across machines with `pro fix` run through Landscape. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Checkpoint, Part D · Check yourself Q6 |
| **L07-5** **Schedule** scripts with script profiles, and **explain** archiving vs. redacting. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Checkpoint, Part E · Check yourself Q3, Q4 |
| **L08-1** **Install** and **hold** packages on one machine and across many. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Checkpoints, Parts A and B · Check yourself Q2 |
| **L08-2** **Manage** snaps (install, hold, channels) from the web portal. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Checkpoint, Part C · Check yourself Q5 |
| **L08-3** **Create** a package profile and **explain** how tags turn profiles into policy. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Checkpoint, Part D · Check yourself Q1, Q3 |
| **L08-4** **Create** a security-only upgrade profile with a maintenance window. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Checkpoint, Part E · Check yourself Q6 |
| **L08-5** **Explain** reboot and removal profiles and their business value. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Check yourself Q4 |
| **L08-6** **Choose** the right profile type for a customer requirement. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Check yourself Q7 |
| **L09-1** **Explain** CIS Benchmarks, DISA-STIG, USG and tailoring files in plain language. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Check yourself Q4, Q5 |
| **L09-2** **Prepare** machines for USG audits from the web portal. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Checkpoint, Part A · Check yourself Q2 |
| **L09-3** **Create** a USG profile, and **explain** its three modes and scheduling rules. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Check yourself Q1, Q3 |
| **L09-4** **Download** and **interpret** a USG audit report, and **use** it in a compliance story. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Checkpoint, Part C · Check yourself Q6 |
| **L10-1** **Build** an access-group hierarchy and **assign** machines to it. | [Lab 10: RBAC and access control](../labs/10-rbac-and-access-control.md) | Checkpoints, Parts A and B · Check yourself Q1, Q2 |
| **L10-2** **Create** roles that give least-privilege access. | [Lab 10: RBAC and access control](../labs/10-rbac-and-access-control.md) | Checkpoint, Part C · Check yourself Q4 |
| **L10-3** **Explain** how administrator invitations work and their limits. | [Lab 10: RBAC and access control](../labs/10-rbac-and-access-control.md) | Check yourself Q5 |
| **L10-4** **Explain** the single sign-on options and what Landscape does and doesn't take from the identity provider. | [Lab 10: RBAC and access control](../labs/10-rbac-and-access-control.md) | Check yourself Q3, Q6 |
| **L12-1** **Manage** local Linux users from the web portal. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Checkpoint, Part A · Check yourself Q5 |
| **L13-2** **Deliver** the 20-minute security-led demo in under 20 minutes, without notes. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Practice exercise and rubric |
| **L14-3** **Explain** what removing a machine from Landscape does, and doesn't do. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Check yourself Q2 |

### PO5: Specialized environments

| Objective | Lab | Checked by |
|---|---|---|
| **L11-1** **Articulate** the sovereignty and Sovereign AI story, and how each edition answers it. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Check yourself Q6 |
| **L11-2** **List** the external endpoints a self-hosted server uses and **explain** what breaks without them. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Check yourself Q5 |
| **L11-3** **Draw** the three airgap layouts, **compare** restricted and fully disconnected airgaps, and **state** the main limitation honestly. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Checkpoint, Part C · Check yourself Q1 |
| **L11-4** **Explain** the repository-mirroring concepts: mirrors, filtered and signature-preserving mirrors, snapshots, local repositories, publications, targets and profiles. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Check yourself Q2, Q3, Q4 |
| **L11-5** **Navigate** the Repositories pages and **describe** each field of the mirror form. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Checkpoint, Part E |
| **L11-6** **Use** disk-space estimates in a sizing conversation. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Check yourself Q7 |
| **L12-2** **Explain** desktop features: FDE recovery keys, Sanitize and autoinstall provisioning. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Check yourself Q3 |
| **L12-3** **Explain** how Landscape manages Windows machines running WSL, including WSL profiles. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Check yourself Q1, Q6 |
| **L12-4** **Explain** how Landscape manages Ubuntu Core and IoT devices. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Check yourself Q2 |
| **L12-5** **Position** Landscape for AI hardware such as NVIDIA DGX Spark, and **state** what stays with NVIDIA tooling. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Check yourself Q4 |

### PO6: Sell

| Objective | Lab | Checked by |
|---|---|---|
| **L02-6** **Position** Landscape against Ansible and within the Canonical portfolio. | [Lab 02: Landscape, the big picture](../labs/02-landscape-big-picture.md) | Check yourself Q7 |
| **L04-5** **Describe** the options for registering machines at scale. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Check yourself Q5 |
| **L05-1** **Deliver** a 60-second estate-overview opener from the Overview page. | [Lab 05: Portal tour, see and organize the estate](../labs/05-portal-tour-and-organizing.md) | Check yourself Q5 |
| **L06-5** **Deliver** the 5-minute security demo, including how to prove a fix to an auditor. | [Lab 06: Security patching, CVEs and Livepatch](../labs/06-security-patching-and-cves.md) | Practice table · Check yourself Q4 |
| **L07-2** **Explain** the safeguards around remote script execution. | [Lab 07: Remote scripts and annotations](../labs/07-remote-scripts-and-annotations.md) | Check yourself Q1 |
| **L08-5** **Explain** reboot and removal profiles and their business value. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Check yourself Q4 |
| **L08-6** **Choose** the right profile type for a customer requirement. | [Lab 08: Packages, snaps and profiles](../labs/08-packages-snaps-and-profiles.md) | Check yourself Q7 |
| **L09-4** **Download** and **interpret** a USG audit report, and **use** it in a compliance story. | [Lab 09: Compliance, CIS and DISA-STIG with USG](../labs/09-compliance-usg-cis-stig.md) | Checkpoint, Part C · Check yourself Q6 |
| **L11-1** **Articulate** the sovereignty and Sovereign AI story, and how each edition answers it. | [Lab 11: Sovereign, airgapped and repository mirroring](../labs/11-sovereign-airgapped-and-repos.md) | Check yourself Q6 |
| **L12-5** **Position** Landscape for AI hardware such as NVIDIA DGX Spark, and **state** what stays with NVIDIA tooling. | [Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware](../labs/12-beyond-servers-wsl-iot-ai.md) | Check yourself Q4 |
| **L13-1** **Run** discovery and **choose** the demo storyline that fits the customer's answers. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Check yourself Q1 |
| **L13-2** **Deliver** the 20-minute security-led demo in under 20 minutes, without notes. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Practice exercise and rubric |
| **L13-3** **Adapt** the demo for compliance, operations, sovereignty and AI/developer audiences. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Check yourself Q2 |
| **L13-4** **Recover** smoothly from common demo failures. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Check yourself Q3 |
| **L13-5** **Handle** common objections accurately, and say "let me confirm" when unsure. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Practice exercise (skeptical CISO role-play) · Check yourself Q4 |
| **L14-1** **Prepare** the demo estate before a call with the pre-demo checklist. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Pre-demo checklist |

### PO7: Self-sufficiency

| Objective | Lab | Checked by |
|---|---|---|
| **L04-6** **Diagnose** a failed registration using the client's configuration file and logs. | [Lab 04: Enroll your fleet](../labs/04-enroll-your-fleet.md) | Check yourself Q6 |
| **L13-4** **Recover** smoothly from common demo failures. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Check yourself Q3 |
| **L13-6** **Locate** the official documentation section that answers a customer's deep technical question. | [Lab 13: Your first demo](../labs/13-your-first-demo.md) | Check yourself Q5 |
| **L14-1** **Prepare** the demo estate before a call with the pre-demo checklist. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Pre-demo checklist |
| **L14-2** **Pause**, **resume** and **roll back** the estate with Multipass snapshots. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Check yourself Q1 |
| **L14-3** **Explain** what removing a machine from Landscape does, and doesn't do. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Check yourself Q2 |
| **L14-4** **Tear down** the estate and **free** your Ubuntu Pro seats. | [Lab 14: Reset and teardown](../labs/14-reset-and-teardown.md) | Checkpoint, Full teardown · Check yourself Q3 |

## How objectives are checked

- **Checkpoint:** a ✅ step in the lab that only passes if the task actually worked.
- **Check yourself Qn:** a quiz question at the end of the lab, tagged with the objective ID.
- **Exercise / practice:** a whiteboard, demo or role-play activity (Labs 02 and 13).
- **Final readiness:** the demo-readiness checklist in [Lab 13](../labs/13-your-first-demo.md#-youre-demo-ready-when-you-can) covers outcomes PO2, PO3, PO4 and PO6 end to end.
