# Lab 11: Sovereign, airgapped and repository mirroring ⭐ flagship lab

**Time:** about 4 hours, in three sessions: **Story and design** (Parts A–D, 75 min) · **Build a working airgap** (Parts E–J, 2 h) · **Demo and practice** (Parts K–N, 45 min) · **Prerequisite:** Labs 03–08, **full path** (self-hosted server). Light-path learners can do Parts A–D and K–N, then watch a colleague's build or borrow a bigger machine for Parts E–J.

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L11-1 | **Distinguish** data residency, data sovereignty, operational sovereignty, supply-chain security and Sovereign AI, and **map** each to a Landscape capability and edition. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q1, Q2 |
| L11-2 | **Qualify** a sovereign or airgapped opportunity with targeted discovery questions, and **recognize** when to bring in professional services. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q3 |
| L11-3 | **Design** an airgap architecture for a customer scenario: network style (restricted vs. fully disconnected), server layout and tiered mirrors. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Design exercise, Part C · Check yourself Q4 |
| L11-4 | **List** what a self-hosted server reaches on the Internet, what breaks without each endpoint, and the documented offline workaround. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q5 |
| L11-5 | **Isolate** a machine with a host firewall and **prove** its isolation, including from the web portal. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO1](../reference/learning-objectives.md#po1-linux-fluency) | Checkpoints, Parts E3 and J4 · Check yourself Q6 |
| L11-6 | **Install** Landscape Client offline by carrying a checksum-verified bundle across the gap, and **register** the isolated machine. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO3](../reference/learning-objectives.md#po3-build) | Checkpoints, Part F · Check yourself Q7 |
| L11-7 | **Enable** repository management with Debarchive on a self-hosted server. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO3](../reference/learning-objectives.md#po3-build) | Checkpoint, Part G5 · Check yourself Q8 |
| L11-8 | **Build** a filtered mirror and **publish** it signed with your own GPG key, explaining every component on the way. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Checkpoints, Part I · Check yourself Q9, Q10 |
| L11-9 | **Deliver** approved software to the isolated machine with a repository profile, and **demonstrate** that unapproved software can't get in. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoints, Part J · Check yourself Q11 |
| L11-10 | **Explain** snapshot mirrors, ESM mirrors, local repositories and the fully disconnected update process, including their limitations. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q12 |
| L11-11 | **Deliver** the 15-minute sovereignty demo and **answer** airgap objections honestly. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO6](../reference/learning-objectives.md#po6-sell) | Part L demo run-through · Check yourself Q13, Q14 |
| L11-12 | **Estimate** mirror storage and **explain** how to reduce it. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q15 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this is the most important lab in the course

**Sovereignty has become one of the most decisive topics in infrastructure buying.** Governments, defence, critical national infrastructure, banks, telecoms, healthcare, research institutions, and every organization building **Sovereign AI** ask some version of:

- *"Can it run with **no Internet connection** at all?"*
- *"Does **any** of our data, or our operational control, leave our jurisdiction?"*
- *"Can we control **exactly** which software enters our environment, and prove it?"*
- *"If our vendor's cloud goes down or becomes unavailable to us, do we keep working?"*

Supply-chain incidents, such as the 2024 **xz-utils backdoor (CVE-2024-3094)**, turned *"what exactly enters our environment?"* into a board-level question. AI workloads raise the stakes further: the models, training data and GPU fleets are strategic assets that organizations and states want to keep under their own control.

**These are often the largest, longest and most strategic deals**, and they're also where generic SaaS management tools are ruled out on day one. Self-hosted Landscape, with repository mirroring, can be a fit for all four questions. Not many tools can say that, so this is where you can differentiate most.

This lab is deliberately the most thorough in the course. By the end you will have **built a real airgapped machine**, managed it, and fed it **only the software you approved, signed with your own key**. You'll also be able to design and pitch the architecture for a customer.

> [!IMPORTANT]
> **Honesty builds trust in these deals.** Airgapped and sovereign customers are usually technical and sceptical, and they've been burned by "it works offline" claims before. This lab teaches the limitations alongside the strengths (Part M). Say them out loud, early. It's what makes you credible.

---

# Session 1: Story and design

## Part A: The sovereignty vocabulary

Customers use these words loosely. Know the difference, and you can map each one to a concrete Landscape answer.

| Term | What the customer means | Landscape answer |
|---|---|---|
| **Data residency** | "Our data must be stored in country X." | **Self-hosted** Landscape stores inventory, activity history, audit and compliance data in the customer's own PostgreSQL, wherever they run it: on-premises, a sovereign cloud or a specific public-cloud region. |
| **Data sovereignty** | "Our data must be under *our* laws and *our* control, not a foreign provider's." | Self-hosted keeps both the data **and** the keys under their control. They control encryption at rest for their own database (Landscape SaaS encrypts at rest with AES-128; self-hosted is user-controlled). |
| **Operational sovereignty** | "We must be able to operate, even if the vendor or the Internet is unavailable." | Self-hosted Landscape runs **with no dependency on Canonical's cloud**, including fully disconnected. If they want help operating it, **Managed Landscape** is single-tenant and can be deployed **on-premises**, operated by Canonical under an SLA. |
| **Technological sovereignty** | "We want open technology we can inspect, not a black box." | Ubuntu is open source, and Landscape Client is open source on GitHub. Customers can inspect what runs on their machines. |
| **Supply-chain security** | "Nothing enters unless we approved it, and we can prove where it came from." | **Filtered mirrors** (an approved catalogue), **snapshots** (the archive frozen at a date), **publications signed with the customer's own GPG key**, and **repository profiles** that point machines only at approved sources. |
| **Sovereign AI** | "Our AI stack, including models, data and the GPU infrastructure, stays under our control and jurisdiction." | The OS layer under AI infrastructure (for example NVIDIA DGX Spark, whose DGX OS is Ubuntu-based and which NVIDIA recommends managing with Landscape) can be patched, audited, scripted and fed approved software from a Landscape server **inside** the sovereign boundary. |
| **Airgap** | "No network path to the Internet." | Self-hosted install from carried-in packages, plus mirrors. You'll build one in Parts E–J. |

🎤 **Say it on the call:** *"Sovereign AI isn't only about where the model runs. It's about who controls everything underneath it: the operating system, which packages get in, the patches, the audit trail, the admin identities. With self-hosted Landscape, every one of those stays inside your boundary, and it keeps working even if the outside world is unreachable."*

### Which edition answers which sovereignty requirement?

| Requirement | SaaS | Managed | Self-hosted |
|---|---|---|---|
| Data stored in customer-controlled infrastructure | ❌ (Canonical-hosted, multi-tenant) | ✅ dedicated, can be on-premises | ✅ |
| Works with no Internet at all | ❌ | Can be deployed on-premises: confirm the connectivity model with the product team | ✅ |
| Repository mirroring / approved software catalogue | ❌ | ✅ | ✅ |
| Bring your own identity provider (OIDC, AD, PAM) | ❌ | ✅ | ✅ |
| Customer operates it themselves | ❌ | ❌ (Canonical operates under an SLA) | ✅ |

---

## Part B: Discovery that qualifies a sovereign deal

Ask these early. The answers decide the architecture, and whether you need specialists in the room.

| # | Ask | Why it matters |
|---|---|---|
| 1 | "Is the target network **fully disconnected**, or is there a **controlled path** out (a proxy, a firewall rule, a data diode)?" | Decides **restricted vs. fully disconnected** (Part C). This is the biggest single factor in effort. |
| 2 | "How do approved files get **into** the environment today? Who approves them, and how often?" | Tells you the "sneakernet" cadence and process, and who owns it. |
| 3 | "Is there **one** isolated environment, or **several** (sites, classification levels, regions)?" | Several environments point to **tiered mirrors** (Part C). |
| 4 | "Do you need **only Ubuntu**, or also third-party and in-house packages?" | Third-party mirrors and **local repositories** for in-house `.deb`s. |
| 5 | "Do you use **snaps** inside the environment?" | Snaps aren't mirrored by Landscape. That's the **Enterprise Store** conversation. |
| 6 | "Which Ubuntu releases and CPU architectures (amd64, arm64…)?" | Drives **mirror size** (Part D). |
| 7 | "Must every package be **signed by you**, or is the upstream signature acceptable?" | Re-signed vs. **signature-preserving** mirrors. |
| 8 | "Who may operate it: your staff only, cleared staff, or Canonical?" | **Self-hosted vs. Managed**, and professional-services scope. |
| 9 | "Which identity provider do admins use inside the boundary?" | OIDC, AD or PAM (Lab 10). |
| 10 | "What evidence do auditors want: patch status, CIS/DISA-STIG reports, change records?" | Brings in USG (Lab 09), activities and security logs. |
| 11 | "Are there AI or GPU systems in scope?" | DGX Spark / Sovereign AI angle (Lab 12). |

> [!TIP]
> If the answer to #1 is "fully disconnected" and the estate is large, **bring in Canonical's professional services early**. The official docs say that when external network access isn't available, professional services include assistance with setting up Landscape in a fully airgapped environment. It's the right thing for the customer, and it expands the deal.

---

## Part C: Airgap architectures

### Two network styles

| | **Restricted network airgap** (one-way, controlled access) | **Fully disconnected airgap** (manual transfer) |
|---|---|---|
| Connectivity | The inside server can pull updates through a **controlled** connection; clients stay isolated. | **No** connectivity. Everything is carried in on physical media. |
| Effort | Much simpler. Mirrors sync automatically. | Significant: the docs say it "will take a while to set up". |
| You'll build | ✅ **This one**, in Parts E–J | Concepts in Part J |

### Server layouts

```
1) Single server inside          2) Server outside,            3) Two servers (maximum isolation)
   (controlled egress)              clients inside

 Internet                         Internet                       Internet
    │ (controlled)                   │                              │
 ┌──┴─────────┐                 ┌────┴───────┐                 ┌────┴─────┐  outer Landscape
 │ Landscape  │                 │ Landscape  │                 │  server  │  mirrors upstream
 │  server    │                 │  server    │                 └────┬─────┘
 └──┬─────────┘                 └────┬───────┘            ═══ airgap ═╪═══ controlled link or media
 ═══╪═══ airgap ═══          ════════╪═══ airgap ═══           ┌────┴─────┐  inner Landscape
    │                                │                         │  server  │  serves clients
  clients                          clients                     └────┬─────┘
                                                                  clients
```

### Tiered mirrors (multi-region and multi-enclave)

For several isolated networks or regions, Landscape servers can be **layered**. The docs describe two patterns:

- **Role-isolated:** one **management** server manages all clients; separate **repository mirror** servers hold the packages. Clients get packages from the mirror server assigned by their repository profile.
- **Network-isolated:** a **Tier 1 global** server filters packages from public repositories; **Tier 2** servers (one per network or region) mirror from Tier 1 and serve their local clients. Each tier signs with its own key, and the next tier trusts it.

Benefits to name: **regional bandwidth and cost savings**, **one place to decide what's approved** (Tier 1), and **isolation between networks**.

> [!NOTE]
> The docs' detailed tiered-mirror steps are written for Landscape 25.10 and earlier; the concepts apply to all versions. For a 26.04+ design, involve the product team or professional services.

### 🖊️ Design exercise (20 min, do it on paper)

For each scenario, choose the **edition**, **network style** and **server layout**, and list **two risks** to raise. Then compare with the model answers.

**Scenario 1: National AI research centre.** 40 DGX Spark systems plus 200 Ubuntu servers in a secure facility. A controlled proxy is allowed for updates, after security review. The government requires all data and operations to stay in-country, and the centre's own staff must operate everything.

**Scenario 2: Defence contractor.** Three classified enclaves, no network connectivity of any kind. Updates arrive monthly on approved media. Packages must be signed by the contractor's own key, and DISA-STIG evidence is required.

**Scenario 3: European bank.** 6,000 Ubuntu servers across EU regions. Data must stay in the EU. Production networks have no direct Internet access, and the bank wants Canonical to run the management layer.

<details>
<summary>Model answers</summary>

**Scenario 1:** Self-hosted (their staff operate it, in-country). Restricted network airgap with a **single server inside** and controlled egress through the reviewed proxy. Filtered mirrors as the approved catalogue, plus local repositories for in-house AI tooling. DGX Spark managed like any Ubuntu machine, with NVIDIA's reference scripts through Landscape. **Risks:** the proxy allowlist must include the endpoints in Part D; snaps need the Enterprise Store if used; sizing for mirrors (arm64 for DGX Spark, amd64 for servers).

**Scenario 2:** Self-hosted, **fully disconnected**, **two-server** pattern (an outer server mirrors and builds the media; an inner server per enclave serves clients), identical repository structures and the same signing key on both sides. USG profiles with DISA-STIG for evidence. **Risks:** no diff transfer, so the whole repository moves every month (use filtered mirrors to shrink it); the USN database must be carried in manually; involve professional services early.

**Scenario 3:** **Managed Landscape** (Canonical operates it, single-tenant, deployable in the bank's chosen EU infrastructure). Consider **tiered mirrors** per region for bandwidth and isolation. SSO through the bank's IdP, and RBAC by region and team. **Risks:** confirm the Managed deployment and connectivity model with the product team; plan mirror storage per region.
</details>

---

## Part D: What crosses the boundary, and what to do when it can't

### What a self-hosted server normally reaches

From the official *About self-hosted Landscape → Network access*:

| Endpoint | Used for | If blocked… | Offline workaround (from the docs) |
|---|---|---|---|
| `usn.ubuntu.com` (HTTPS) | USN database (security classification) | Security updates can't be told apart from regular ones | Carry the USN database file in and adapt the `update_security_db.sh` job to import it from the local file |
| Ubuntu archive, `changelogs.ubuntu.com` (HTTP) | Package hash database, release information | Release upgrades don't work | Mirrors provide the packages |
| `contracts.canonical.com` (HTTPS) | Ubuntu Pro authentication | Pro can't be attached online | The legacy **license.txt** mechanism exists for offline deployments; confirm current offline Pro options with the product team |
| `esm.ubuntu.com` (HTTPS) | Ubuntu Pro (ESM) packages | No ESM updates | **Mirror the ESM repositories** (the *Ubuntu Pro* mirror type, with a bearer token) |
| `livepatch.canonical.com`, `livepatch-files.canonical.com` | Livepatch | No live kernel patches | Not covered in the Landscape docs: **ask the product team** |
| `ubuntu.com/security` | Security information | — | — |
| `landscape.canonical.com` | New-release notice | Only the notice is missing | — |
| Snap Store (`api.snapcraft.io`…) | Snaps | No snaps | **Enterprise Store** |

Other offline realities from the docs:
- **Admin invitations without email:** with no mail server, an admin can read pending invitation codes from the database and build the invite link by hand (`https://<FQDN>/accept-invitation/<SECURE_ID>`).
- **Pro from the web portal** (Attach token) **isn't available for offline clients**.
- **Clients** only need to reach the Landscape server (HTTPS 443, and HTTP 80 for ping and mirrors), so they sit happily behind the airgap.

### Sizing mirrors

Disk estimates from the docs (April 2026: main+restricted+universe+multiverse; release+updates+security pockets):

| Series | amd64 | amd64 + i386 |
|---|---|---|
| 26.04 Resolute | ~150 GB | ~180 GB |
| 24.04 Noble | ~625 GB | ~680 GB |
| 22.04 Jammy | ~945 GB | ~975 GB |

- Production guidance: **2 TB or more** of extra storage if mirroring.
- A **filesystem** publication target of a re-signed mirror needs room for **both** the synced mirror **and** the published copy: plan for **roughly double**.
- To shrink: skip `restricted` (proprietary drivers), use **filtered mirrors**, and mirror only the architectures you need.

---

# Session 2: Build a working airgap

You'll turn your demo estate into the **"single server inside, controlled egress"** layout:

```
             Internet
                │  (controlled: only the Landscape server can sync)
        ┌───────┴──────────┐
        │ landscape-server │  Landscape + Debarchive + signed mirror (port 8000)
        └───────┬──────────┘
  ══════════════╪═══════════════ host firewall (ufw) on the client ═════
                │  ONLY the Landscape server is reachable
          ┌─────┴─────┐
          │ airgap-01 │  no Internet · registered with Landscape
          └───────────┘  installs only approved, signed packages
```

> [!NOTE]
> **Resources.** You'll add two small VMs (`airgap-01`, and a temporary `staging` VM). If your laptop has 16 GB, stop the VMs you don't need for this lab first:
> ```bash
> multipass stop db-01 legacy-01
> ```
> *What this does:* shuts down two machines you won't use in this lab, freeing about 2 GB of RAM.

**Safety net first.** Take a server snapshot so you can undo this lab:

```bash
multipass stop landscape-server && multipass snapshot landscape-server --name before-lab11 && multipass start landscape-server
```

*What this does:* stops the server, saves a restore point called `before-lab11`, and starts it again. Wait 5 minutes for Landscape to come back up.

---

## Part E: Build an isolated machine

### E1. Create and commission airgap-01

```bash
multipass launch 24.04 --name airgap-01 --cpus 1 --memory 1G --disk 8G
```

Real isolated machines are usually prepared ("commissioned") before they go into the secure zone. We'll do one commissioning step while it's still connected: attaching Ubuntu Pro (attaching needs `contracts.canonical.com`, which will be blocked shortly).

```bash
multipass exec airgap-01 -- sudo pro attach <YOUR_PRO_TOKEN>
```

*What this does:* attaches airgap-01 to your Ubuntu Pro subscription (this uses your 4th or 5th free seat). In real disconnected sites, licensing works differently. See Part D.

### E2. Cut it off from the Internet with a host firewall

You'll use **ufw** ("uncomplicated firewall"), Ubuntu's built-in firewall tool, to allow exactly one destination: your Landscape server.

```bash
multipass shell airgap-01
```

✅ Prompt: `ubuntu@airgap-01:~$`. **Double-check it.** You don't want to firewall the wrong machine.

Run these one at a time, reading each explanation first:

```bash
sudo ufw default deny incoming
```
*What this does:* by default, block all connections **into** this machine.

```bash
sudo ufw default deny outgoing
```
*What this does:* by default, block all connections **out of** this machine. This is the airgap.

```bash
sudo ufw allow in 22/tcp
```
*What this does:* allows incoming SSH (port 22). Multipass uses SSH for `multipass shell`, `exec` and `transfer`, so without this rule you'd lock yourself out.

```bash
sudo ufw allow out 67/udp
```
*What this does:* allows DHCP requests, which the VM uses to keep its network address.

```bash
sudo ufw allow out to <SERVER_IP>
```
*What this does:* the one hole in the wall. airgap-01 may talk to your Landscape server (on any port), and nothing else.

```bash
sudo ufw --force enable
```
*What this does:* switches the firewall on. `--force` skips the "this may disrupt SSH connections" question, which our port-22 rule already handles.

```bash
sudo ufw status verbose
```

✅ **Checkpoint:** status is `active`, defaults are `deny (incoming), deny (outgoing)`, and you see the three ALLOW rules.

### E3. Prove the airgap

```bash
curl -sS --max-time 8 -o /dev/null http://archive.ubuntu.com/ubuntu/ && echo "REACHABLE" || echo "BLOCKED"
```

*What this does:* tries to reach the Ubuntu archive and prints REACHABLE or BLOCKED. (`&&` runs the next command only on success; `||` runs it only on failure.)

```bash
curl -sk --max-time 8 -o /dev/null https://<SERVER_IP>/ && echo "REACHABLE" || echo "BLOCKED"
```

*What this does:* tries to reach your Landscape server's web portal. `-k` accepts the lab's self-signed certificate.

```bash
sudo apt update
```

*What this does:* tries to refresh the package lists from Ubuntu's archive. It **fails** (or times out) with errors about not being able to connect. That's exactly what an airgapped machine looks like.

✅ **Checkpoint:** the archive is **BLOCKED**, the Landscape server is **REACHABLE**, and `apt update` can't reach the Ubuntu archive.

```bash
exit
```

> [!CAUTION]
> If you ever lock yourself out (`multipass shell` hangs), it's a lab VM: `multipass delete airgap-01 --purge` and start Part E again.

---

## Part F: Carry Landscape Client across the gap (offline install)

airgap-01 can't download Landscape Client, so you'll do what real airgapped sites do, following the official *Install Landscape Client in an offline environment* procedure:
1. On an **online** machine, download the client **and all its dependencies**.
2. Record **checksums** (integrity proof), and package everything as a bundle.
3. Carry the bundle across. Here your laptop plays the role of the **approved USB stick**.
4. **Verify** the checksums inside, then install with **network access explicitly disabled**.

### F1. Download on an online "staging" machine

```bash
multipass launch 24.04 --name staging --cpus 1 --memory 1G --disk 8G
```

*What this does:* creates a temporary, Internet-connected machine from the **same Ubuntu image** as airgap-01, so it downloads exactly the dependencies airgap-01 will be missing.

```bash
multipass shell staging
```

```bash
sudo add-apt-repository -y ppa:landscape/latest-stable && sudo apt update
```

```bash
sudo apt clean
```

*What this does:* empties APT's download cache (`/var/cache/apt/archives`), so after the next step it contains **only** what we need.

```bash
sudo apt --download-only -y install landscape-client
```

*What this does:* works out everything needed to install `landscape-client` (the "dependency closure") and **downloads** it without installing anything.

```bash
ls /var/cache/apt/archives/*.deb
```

✅ **Checkpoint:** you see `landscape-client_…deb`, `landscape-common_…deb` and several other `.deb` files.

### F2. Bundle it with checksums

```bash
mkdir -p ~/bundle && cp /var/cache/apt/archives/*.deb ~/bundle/
```

*What this does:* creates a `bundle` folder in your home folder and copies the downloaded packages into it.

```bash
cd ~/bundle && sha256sum *.deb > SHA256SUMS && cat SHA256SUMS
```

*What this does:* computes a **SHA-256 checksum** (a unique fingerprint) for each file and saves them in `SHA256SUMS`. If even one byte changes in transit, the fingerprint won't match. Airgapped sites always verify what they carry in.

```bash
cd ~ && tar czf landscape-client-bundle.tar.gz bundle && ls -lh landscape-client-bundle.tar.gz
```

*What this does:* `tar czf` packs the folder into one compressed file (like a `.zip`).

```bash
exit
```

### F3. Carry it across ("the USB stick")

⌨️ **On your laptop:**

```bash
multipass transfer staging:/home/ubuntu/landscape-client-bundle.tar.gz .
```

*What this does:* copies the bundle from `staging` to the current folder on your laptop. Your laptop is now the "removable media".

```bash
multipass transfer landscape-client-bundle.tar.gz airgap-01:/home/ubuntu/
```

*What this does:* copies the bundle from your laptop into airgap-01. (`multipass transfer` uses the SSH port you deliberately left open. In real life this would be a USB stick, a DVD or a data diode, through an approved transfer process.)

### F4. Verify and install offline

```bash
multipass shell airgap-01
```

```bash
tar xzf landscape-client-bundle.tar.gz && cd bundle && sha256sum -c SHA256SUMS
```

*What this does:* unpacks the bundle, then **checks every file against its recorded fingerprint**.

✅ **Checkpoint:** every line ends with `OK`. If any says `FAILED`, don't install. Repeat the transfer.

```bash
sudo mkdir -p /srv/landscape-packages && sudo cp ~/bundle/*.deb /srv/landscape-packages/
```

```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  -o Acquire::http::No=true \
  -o Acquire::https::No=true \
  /srv/landscape-packages/*.deb
```

*What this does:* installs every `.deb` from the local folder. The two `-o Acquire::…::No=true` options tell APT **not to use the network at all**, so it must resolve dependencies from the files you carried in. This is exactly the command in the official offline-install guide.

✅ **Checkpoint:** the install finishes without errors.

```bash
dpkg -l landscape-client | tail -1
```

*What this does:* asks the package database about `landscape-client`. A line starting with `ii` means "installed correctly". You just installed software on a machine with no Internet access.

### F5. Register airgap-01 with Landscape

```bash
echo | openssl s_client -connect <SERVER_IP>:443 | openssl x509 | sudo tee /etc/landscape/server.pem
```

```bash
sudo landscape-config --silent \
  --account-name standalone \
  --computer-title airgap-01 \
  --url https://<SERVER_IP>/message-system \
  --ping-url http://<SERVER_IP>/ping \
  --ssl-public-key /etc/landscape/server.pem \
  --tags airgapped,sovereign \
  --include-manager-plugins ScriptExecution \
  --script-users root,landscape,ubuntu \
  --registration-key <REG_KEY>
```

*What this does:* exactly what you did in Lab 04: trust the server's certificate, then register with your registration key, tagging the machine `airgapped` and `sovereign`.

```bash
exit
```

✅ **Checkpoint:** 🖱️ **Instances** shows **airgap-01**, online, with the tags `airgapped` and `sovereign`.

### F6. Read the alert

Within a few minutes, airgap-01 raises a **package reporting** alert. Its client can't run `apt update`, because the Ubuntu archive is unreachable. Open airgap-01's **Info** or the alerts view and find it.

🎤 *"This is what an airgapped machine looks like to a management tool: managed, but starving. It can't see updates. Now let's feed it, but only what we approve."*

### F7. Clean up staging

```bash
multipass delete staging --purge
```

*What this does:* deletes the temporary online machine. In the real world, the docs note that the online download machine **can be ephemeral**.

---

## Part G: Turn on repository management (Debarchive)

Since **26.04 LTS**, mirroring is provided by the **Debarchive** service. You'll install it on your server, following the official *How to set up Debarchive with Landscape*.

```bash
multipass shell landscape-server
```

### G1. Install the snap

```bash
sudo snap install landscape-debarchive --channel=latest/stable
```

*What this does:* installs Debarchive as a background service. It will report database errors until you finish the next steps. That's expected.

### G2. Give Debarchive its own database user and database

```bash
sudo -u postgres createuser --pwprompt landscape_debarchive
```

*What this does:* creates a PostgreSQL user named `landscape_debarchive`. `--pwprompt` asks you to type a password twice (nothing appears as you type). **Save it in your notes as `<DEBARCHIVE_DB_PASSWORD>`.**

```bash
sudo -u postgres createdb --owner=landscape_debarchive landscape-standalone-debarchive
```

*What this does:* creates the database `landscape-standalone-debarchive`, owned by that user.

```bash
sudo -u postgres psql -d landscape-standalone-debarchive -c "GRANT USAGE, CREATE ON SCHEMA public TO landscape_debarchive;"
```

*What this does:* lets the user create tables in the database. Debarchive builds its own tables on first connection.

✅ **Checkpoint:** the last command prints `GRANT`.

### G3. Connect the snap to its database

```bash
sudo snap set landscape-debarchive \
    deb.archive.database.name=landscape-standalone-debarchive \
    deb.archive.database.user=landscape_debarchive \
    deb.archive.database.password=<DEBARCHIVE_DB_PASSWORD>
```

*What this does:* stores the database name, user and password in the snap's settings. The snap restarts automatically. (Other settings use Quickstart-friendly defaults: same machine, port 5432, gateway on port **8100**.)

```bash
sudo snap services landscape-debarchive
```

✅ **Checkpoint:** `landscape-debarchive.debarchive` is **active**. If not: `sudo snap logs landscape-debarchive -n 50`.

### G4. Expose Debarchive through Apache

The web portal talks to Debarchive at `https://<SERVER_IP>/debarchive`, so Apache (the front door) must forward that path to Debarchive on port 8100.

```bash
ls /etc/apache2/sites-enabled/
```

*What this does:* lists the enabled Apache sites. You should see Landscape's site file (typically `landscape.conf`).

```bash
sudo nano /etc/apache2/sites-available/landscape.conf
```

1. Press `Ctrl + W`, type `<VirtualHost *:443>` and press Enter. You're now in the HTTPS section.
2. Press `Ctrl + W` again, type `RewriteRule ^/(.*) http://localhost:8080` and press Enter. This is the final "catch-all" rule in that section.
3. Put your cursor at the **start of that line** and paste these lines **above** it:

```apache
    # Landscape Debarchive
    RewriteRule ^/debarchive$ /debarchive/ [R=permanent]
    RewriteRule ^/debarchive/(.*) http://localhost:8100/$1 [P,L]
```

4. Save (`Ctrl + O`, `Enter`) and exit (`Ctrl + X`).

*What these lines do:* the first redirects `/debarchive` to `/debarchive/`. The second **proxies** (`[P]`) anything under `/debarchive/` to Debarchive on port 8100, removing the `/debarchive` prefix. They must come **before** the catch-all, because Apache stops at the first rule that matches (`[L]` = last).

```bash
sudo apache2ctl configtest && sudo systemctl reload apache2
```

*What this does:* checks the Apache configuration for typos (`Syntax OK`), and only if it's OK, reloads Apache with the new rules.

### G5. Verify

```bash
curl -sk -o /dev/null -w "%{http_code}\n" "https://localhost/debarchive/v1/mirrors"
```

*What this does:* calls Debarchive through Apache without logging in.

✅ **Checkpoint:** it prints **`401`** ("unauthorized"). That's success: Debarchive is reachable, and it's protected by the same authentication as Landscape. Then, in 🖱️ the web portal, **Repositories → Mirrors** loads and offers **Add mirror**.

---

## Part H: Create a signing key

You'll publish your approved catalogue **signed with your own key**. Clients will trust only packages signed with it. That's the cryptographic heart of the supply-chain story.

Still on `landscape-server`:

```bash
gpg --batch --passphrase '' --quick-generate-key "Demo Repo Signing <repo-signing@example.com>" rsa4096 sign never
```

*What this does:* creates a new **GPG key pair** (a private key that signs and a public key that verifies), with no questions asked (`--batch`):
- `--passphrase ''`: no passphrase. The docs require this, because Landscape signs automatically and can't type one.
- `"Demo Repo Signing <…>"`: the key's name and email label.
- `rsa4096`: a 4096-bit RSA key (an algorithm the docs recommend).
- `sign`: the key is only used for signing. `never`: no expiry date (fine for a lab; real organizations set one).

(The docs' interactive equivalent is `gpg --full-generate-key`.)

```bash
gpg --armor --export-secret-keys repo-signing@example.com > ~/repo-signing-private.asc
gpg --armor --export repo-signing@example.com > ~/repo-signing-public.asc
```

*What these do:* export the private and public keys as text files (`--armor` = readable text instead of binary).

```bash
exit
```

On your laptop, copy them out so you can paste them into the browser easily:

```bash
multipass transfer landscape-server:/home/ubuntu/repo-signing-private.asc .
multipass transfer landscape-server:/home/ubuntu/repo-signing-public.asc .
```

Open both in a text editor (TextEdit, Notepad, Text Editor).

> [!WARNING]
> **The private key is the crown jewels.** Anyone holding it can sign packages your machines will trust. The docs' guidance: use a **dedicated, new** key (never reuse one), store it securely, and if it's ever compromised, generate a new one, republish, and distribute the new public key. You'll delete your local copies in Part J.

---

## Part I: Build the approved catalogue (filtered, signed mirror)

**The story:** *"The security board has approved exactly two packages for the secure zone: `hello` and `sl`."* They're harmless stand-ins for "your approved applications". Everything else must stay out.

### I1. Check your CPU architecture

```bash
multipass exec airgap-01 -- dpkg --print-architecture
```

*What this does:* prints the machine's CPU architecture.

| Output | Use this **Source URL** | **Architecture** |
|---|---|---|
| `amd64` (Intel/AMD laptops) | the default, `http://archive.ubuntu.com/ubuntu` | `amd64` |
| `arm64` (Apple Silicon Macs) | `http://ports.ubuntu.com/ubuntu-ports` | `arm64` |

🧠 Ubuntu publishes amd64 packages on `archive.ubuntu.com` and other architectures (arm64…) on `ports.ubuntu.com`. Mixed fleets, like DGX Spark (arm64) next to x86 servers, need both. That's a real sizing question.

### I2. Create a publication target (where the repository is written)

🖱️ **Repositories → Publication targets → Add publication target**
- **Name:** `approved-fs`
- **Type:** **Filesystem**
- **Path:** `/approved-noble`
- **Link method:** leave the default (**Hardlink**)
- Click **Add publication target**.

*Meaning:* Debarchive will write the published repository to `/var/snap/landscape-debarchive/common/publications/approved-noble` (the path is relative to Debarchive's published root).

### I3. Create the filtered mirror

🖱️ **Repositories → Mirrors → Add mirror**
- **Name:** `noble-approved`
- **Source type:** **Ubuntu archive**
- **Source URL:** from the table in I1
- **Preserve upstream signing key:** **leave unticked** (we'll re-sign with our key, and filters can't be used on signature-preserving mirrors anyway)
- **Distribution:** `noble`
- **Components:** `main`, `universe`
- **Architectures:** from the table in I1
- **Filter:** `Name (= hello) | Name (= sl)`
- If there's an option to **include dependencies**, leave it **off** for this lab. (These two packages only need libraries airgap-01 already has. For real catalogues, the docs recommend including dependencies.)
- Click **Add mirror**.

> [!NOTE]
> **arm64 only:** if the *Ubuntu archive* source type won't accept the `ports.ubuntu.com` URL, see [Troubleshooting → Lab 11](../reference/troubleshooting.md#lab-11-airgap-and-mirroring) for the third-party-repository workaround.

🧠 *Reading the filter:* `Name (= hello)` means "the package named exactly hello", and `|` means OR. So: "only `hello` or `sl`". A blocklist uses `!`, e.g. `!Name (= telnetd)`.

Then **sync** it: select `noble-approved` → **Update** (from the actions menu).

*What happens:* Debarchive downloads the `noble` package indexes from the Ubuntu archive, verifies them against Ubuntu's official signing keys (already known to Landscape), and keeps **only** the two filtered packages.

✅ **Checkpoint:** the sync finishes after a few minutes, without errors.

### I4. Create the publication (connect mirror → target, with your signature)

🖱️ **Repositories → Publications → Add publication**
- **Name:** `noble-approved-pub`
- **Source type:** **Mirror** → **Source:** `noble-approved`
- **Publication target:** `approved-fs`
- **Architectures:** your architecture from I1
- **Signing GPG key:** paste the **entire** contents of `repo-signing-private.asc`, including the `-----BEGIN PGP PRIVATE KEY BLOCK-----` and `-----END…-----` lines
- If asked for a distribution name, use `noble`.
- Click **Add publication**.

Then **publish**: **Repositories → Mirrors** → select `noble-approved` → **Publish** → **Existing publication** → `noble-approved-pub` → **Publish Mirror**.

*What happens:* Landscape takes a **point-in-time snapshot** of the mirror, builds a complete APT repository, **signs it with your private key**, and writes it to the target.

✅ **Checkpoint:**

```bash
multipass exec landscape-server -- ls -R /var/snap/landscape-debarchive/common/publications/approved-noble | head -30
```

*What this does:* lists the published repository. You should see `dists/noble/…` (the signed indexes) and `pool/…` (the packages, including `hello` and `sl`).

### I5. Serve the repository on port 8000

Landscape doesn't serve filesystem publications itself; a web server does. Quickstart already has Apache, so you'll add a small site on port 8000 (the official example configuration).

```bash
multipass shell landscape-server
```

```bash
echo "Listen 8000" | sudo tee -a /etc/apache2/ports.conf
```

*What this does:* tells Apache to also listen on port 8000. `tee -a` **appends** the line to the file.

```bash
sudo nano /etc/apache2/sites-available/filesystem-repo.conf
```

Paste this in, then save and exit:

```apache
<VirtualHost *:8000>
    ServerName landscape-server
    DocumentRoot /var/snap/landscape-debarchive/common/publications/approved-noble
    <Directory /var/snap/landscape-debarchive/common/publications/approved-noble>
        Options +Indexes
        IndexOptions FancyIndexing NameWidth=* FoldersFirst
        Require all granted
    </Directory>
    ErrorLog /var/log/apache2/repo_error.log
    CustomLog /var/log/apache2/repo_access.log combined
</VirtualHost>
```

*What this does:* defines a website on port 8000 whose content (`DocumentRoot`) is your published repository. `Options +Indexes` shows a browsable file listing; `Require all granted` lets anyone who can reach port 8000 read it. (In production you'd restrict access with firewall rules, IP allowlists or HTTP authentication, as the docs advise.)

```bash
sudo a2ensite filesystem-repo.conf && sudo apache2ctl configtest && sudo systemctl restart apache2
```

*What this does:* enables the new site, checks the configuration, and restarts Apache.

```bash
exit
```

✅ **Checkpoint:** in your browser, open `http://<SERVER_IP>:8000/`. You see a file listing with `dists/` and `pool/`. Click through `pool/` until you find the `hello` and `sl` `.deb` files.

🎤 *"This is the entire software universe for the secure zone: two approved packages, signed with your key, served from inside your boundary."*

---

## Part J: Feed the airgapped machine and prove control

### J1. Create a repository profile for the airgapped zone

🖱️ **Repositories → Repository profiles → Add repository profile** (also reachable from **Profiles**)
- **Profile name:** `secure-zone`
- **Add source:**
  - **Source name:** `approved-noble`
  - **Deb line:** `deb http://<SERVER_IP>:8000/ noble main universe`
  - **GPG key:** paste the **public** key (`repo-signing-public.asc`)
- **Access group:** `global`. **Association:** **Tag(s)** → `airgapped`
- Save.

*What happens:* Landscape creates an activity to apply the profile to every machine tagged `airgapped`. By default, Landscape **replaces** the machine's APT sources with exactly what the profile defines (the old source files are moved to a backup). So airgap-01 will know **only** about your approved repository.

✅ **Checkpoint:** **Activities** shows the repository profile activity on airgap-01 as **Succeeded**.

```bash
multipass exec airgap-01 -- sudo apt update
```

*What this does:* refreshes package lists. This time it **succeeds**: it fetches from your mirror and verifies the signature with your public key. No signature warnings means the chain of trust works.

```bash
multipass exec airgap-01 -- apt-cache policy hello
```

✅ **Checkpoint:** the candidate version comes from `http://<SERVER_IP>:8000 noble/…`, your mirror. Within a few minutes, airgap-01's **package reporting alert clears** on its own.

### J2. Install approved software from the web portal

🖱️ **Instances → airgap-01 → Packages** → search `hello` → **Install** → confirm. Watch **Activities**.

```bash
multipass exec airgap-01 -- hello
```

✅ **Checkpoint:** it prints `Hello, world!`. You just installed software on an **airgapped** machine, from a browser, using a **signed, approved** source inside your boundary.

### J3. Prove that unapproved software can't get in

🖱️ **airgap-01 → Packages** → search `nginx`. It isn't available, because it's not in the approved catalogue.

```bash
multipass exec airgap-01 -- sudo apt-get install -y nginx
```

✅ **Checkpoint:** APT reports it **can't locate** (or has no installation candidate for) `nginx`. The supply-chain control holds even if someone with root tries from the command line.

### J4. Prove the airgap from the web portal (your demo asset)

1. Open [`scripts/landscape/06-prove-airgap.sh`](../scripts/landscape/06-prove-airgap.sh), read it, and replace `<SERVER_IP>`.
2. **Scripts → Add script** → `Prove airgap`. Run it on **airgap-01** as `ubuntu`.
3. Read the output in **Activities**: the Ubuntu archive and public websites are **BLOCKED**, the approved mirror is **REACHABLE**, the only configured source is your mirror, and `hello` comes from it.

✅ **Checkpoint:** that output matches the description above. **Save a screenshot**; it's a strong slide for sovereignty calls.

### J5. Update the catalogue (the approval workflow)

*"The security board has approved one more package: `cowsay`."*

1. **Repositories → Mirrors** → edit `noble-approved` and change the filter to `Name (= hello) | Name (= sl) | Name (= cowsay)` (if the mirror can't be edited, create `noble-approved-v2` with the new filter and use that).
2. **Update** (sync), then **Publish** to the **existing** publication `noble-approved-pub`.
3. On airgap-01, install `cowsay` from the **Packages** tab.

> [!NOTE]
> `cowsay` needs Perl. If APT reports a missing dependency, that's a real-world lesson: turn on **include dependencies** for the mirror, sync and publish again. That's why the docs recommend it for allowlists.

🎤 *"Approving new software is a controlled, auditable change: update the catalogue, publish a new signed snapshot, and the secure zone sees it. Nothing else changes."*

### J6. Tidy up your keys

```bash
multipass exec landscape-server -- rm ~/repo-signing-private.asc ~/repo-signing-public.asc
```

Then delete `repo-signing-private.asc` (and the public key file) from your laptop. The key itself stays in the server's GPG keyring (and in the publication) for the lab. **Good key hygiene is part of the demo story.**

### J7. Snapshot your sovereign demo

```bash
multipass stop airgap-01 landscape-server
multipass snapshot airgap-01 --name sovereign-demo
multipass snapshot landscape-server --name sovereign-demo
multipass start landscape-server airgap-01
```

*What this does:* saves restore points of both machines in their working "sovereign" state, so you can always return to a known-good demo.

---

## Part K: Beyond the lab (snapshots, ESM, local repositories, fully disconnected)

### Snapshot mirrors: freeze time

**Source type: Ubuntu Snapshot** mirrors the Ubuntu archive **as it was on a chosen date** (using `snapshot.ubuntu.com`). The staged-rollout pattern:

1. Monday: create a snapshot mirror for that date and publish it to a **test** publication. Machines tagged `test` get it through a repository profile.
2. Tests pass: publish the **same** snapshot to **production**.
3. Every production machine gets **exactly** the bits that were tested. That's reproducible, auditable, and the kind of change control regulators expect.

🖱️ Try it (don't save): **Repositories → Mirrors → Add mirror** → **Source type: Ubuntu Snapshot** and look at the date picker.

### Mirroring Ubuntu Pro (ESM)

Airgapped machines still need **ESM** security updates. The **Ubuntu Pro** mirror type mirrors Pro repositories using a **bearer token** (not the Pro subscription token). For ESM, it's on a Pro-attached machine in `/etc/apt/auth.conf.d/90ubuntu-advantage`. 🎤 *"Ten years of security maintenance, delivered inside the airgap."*

### Local repositories: your own software

**Repositories → Local repositories** hosts the customer's own `.deb` packages (in-house apps, approved third-party tools, AI tooling), published and signed the same way.

### Third-party repositories

Mirrors can also point at **third-party Debian repositories**. Unless you preserve the upstream signature, you provide the third party's **verification GPG key** so Landscape can validate what it syncs.

### Fully disconnected: the sneakernet process (concepts)

1. **Outside** (online) server and **inside** (offline) server are built with **identical** repository structures and the **same** GPG key.
2. The outside server syncs. Its repository data is copied to approved media, carried in, and placed in the same location on the inside server.
3. The inside server serves clients through repository profiles.
4. **Installing Landscape itself offline:** on an online machine, `apt --download-only install landscape-server-quickstart`, plus `snap download` for `core22`, `snapd`, `landscape-task-handler`, `landscape-outbox` and `landscape-debarchive` (each gives a `.snap` and an `.assert` file). Inside, install the `.deb` files with network access disabled (as you did in Part F), and the snaps with `snap ack <file>.assert` then `snap install <file>.snap`.

> [!NOTE]
> The docs' detailed fully-disconnected **repository** steps use the pre-26.04 storage location and the Legacy API (they apply to Landscape 25.10 and earlier). For a 26.04+ fully disconnected design, engage the product team or professional services. Say exactly that to the customer.

---

# Session 3: Demo and practice

## Part L: The 15-minute sovereignty demo

**Prep:** restore or start the `sovereign-demo` snapshots and wait 10 minutes. Have the J4 screenshot ready as a backup.

| Min | Show | Say |
|---|---|---|
| 0–3 | **Whiteboard** (Part C) of the customer's own environment | "Here's your boundary. Here's what has to stay inside it. Everything I'm about to show runs inside it." |
| 3–5 | **Instances** → filter `tag:airgapped` → **airgap-01** | "This machine has no route to the Internet, yet it's fully managed: inventory, scripts, packages, audit trail." |
| 5–7 | **Run `Prove airgap`** → output in **Activities** | "Proof, from inside the machine: Internet blocked; the only reachable source is your approved, signed mirror." |
| 7–10 | **Repositories** → mirror (filter), publication (signing key), target, browse `http://<SERVER_IP>:8000/` | "Your approved catalogue. A filter decides what gets in, your own key signs it, and it's published inside your walls." |
| 10–12 | **airgap-01 → Packages** → install an approved package; search `nginx` (absent) | "Approved software installs from the browser. Unapproved software doesn't exist, as far as this zone is concerned, even for root." |
| 12–14 | **Snapshot** source type, ESM mirror, tiered mirrors (whiteboard) | "Freeze the archive at a date for reproducible rollouts; bring ESM inside; scale out per region or per enclave." |
| 14–15 | Close | "Which environments would you put behind this first, and who approves what goes in today?" |

> [!TIP]
> Combine with **Lab 09** (DISA-STIG audit on the same machine) and **Lab 10** (SSO + RBAC) for a full "sovereign and compliant" story in 30 minutes.

## Part M: Objections and honest limitations

| They say / ask | Your answer |
|---|---|
| "Does it *really* work with no Internet?" | "Self-hosted Landscape installs from carried-in packages and runs entirely inside your network. Clients only ever talk to your Landscape server. You just saw a machine with no Internet route being managed and patched." |
| "How do updates get in for a fully disconnected site?" | "Your outer server syncs and builds the transfer; you carry it in through your approved media process; the inner server serves it. **Honestly**, today there's no incremental diff: the full repository content moves each time. Filtered mirrors keep that small, and our professional services team helps design the process." |
| "What about snaps?" | "Landscape doesn't mirror snaps. For snaps in restricted networks, Canonical has the **Enterprise Store**." |
| "What about security notices (USNs) offline?" | "The server classifies security updates using the USN database. Offline, you carry the USN database file in and import it locally. The docs describe adapting the scheduled job." |
| "Livepatch offline?" | "Let me confirm current options for disconnected environments with our product team and come back to you." *(It's not covered in the Landscape docs, so don't guess.)* |
| "Can we use our own signing keys?" | "Yes. Publications are signed with **your** private key, and clients verify with your public key. You can also keep upstream signatures with signature-preserving mirrors." |
| "Who at Canonical can access it?" | "With self-hosted, nobody unless you invite them. It runs on your infrastructure, with your identity provider and your RBAC. If you'd prefer Canonical to operate it, Managed Landscape is single-tenant and can run on your premises." |
| "How big is this?" | Part D sizing table: hundreds of GB per full release, so plan 2 TB or more; filtered mirrors and skipping components shrink it. |
| "Can we have several isolated networks?" | "Yes, with tiered mirrors: a global tier decides what's approved, and each network gets its own tier." *(For a 26.04 design, involve the product team.)* |

## Part N: Reset after a demo

- Back to the clean demo state: stop both VMs, `multipass restore airgap-01.sovereign-demo`, `multipass restore landscape-server.sovereign-demo`, start them.
- Undo the whole lab: restore `landscape-server.before-lab11`, and `multipass delete airgap-01 --purge` (detach Pro first to free the seat: `multipass exec airgap-01 -- sudo pro detach --assume-yes`. This needs the firewall off: `multipass exec airgap-01 -- sudo ufw disable`).

---

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. A customer says "our data must stay in Germany" and another says "we must keep operating even if our vendor is unreachable". Which sovereignty concepts are these, and what does Landscape offer each? <em>(L11-1)</em></summary>

The first is **data residency** (or sovereignty): self-hosted, or Managed Landscape, keeps the data in infrastructure they choose. The second is **operational sovereignty**: self-hosted Landscape runs with no dependency on Canonical's cloud, even fully disconnected.
</details>

<details>
<summary>2. Which Landscape edition can't be used in an airgapped environment, and why? <em>(L11-1)</em></summary>

Landscape SaaS. It's hosted by Canonical on shared infrastructure, so clients must reach it over the Internet, and it doesn't offer repository mirroring.
</details>

<details>
<summary>3. Which discovery question has the biggest effect on effort and architecture, and when should you bring in professional services? <em>(L11-2)</em></summary>

"Is the network fully disconnected, or is there a controlled path out?" A fully disconnected and large estate is the cue to involve Canonical's professional services early.
</details>

<details>
<summary>4. A customer has four isolated networks and wants one place to decide which packages are approved. Which architecture do you sketch? <em>(L11-3)</em></summary>

Tiered mirrors (network-isolated pattern): a Tier 1 global server filters what's approved from public repositories, and a Tier 2 server in each network mirrors from Tier 1 and serves local clients.
</details>

<details>
<summary>5. What breaks if the self-hosted server can't reach usn.ubuntu.com, and what's the documented offline workaround? <em>(L11-4)</em></summary>

Landscape can't tell security updates from regular ones. The workaround is to carry the USN database file in and adapt the `update_security_db.sh` job to import it from the local file.
</details>

<details>
<summary>6. In Part E you allowed three things through airgap-01's firewall. What were they, and why each? <em>(L11-5)</em></summary>

Incoming SSH on port 22 (Multipass uses it for shell, exec and transfer), outgoing DHCP on UDP 67 (to keep the network address), and outgoing traffic to the Landscape server's IP (management and the mirror). Everything else is denied.
</details>

<details>
<summary>7. Why did you record SHA-256 checksums before carrying the bundle across, and what does <code>-o Acquire::http::No=true</code> do? <em>(L11-6)</em></summary>

Checksums prove the files weren't changed or corrupted in transit: `sha256sum -c` must say OK for every file before you install. The `Acquire::…::No=true` options stop APT from using the network, so dependencies are resolved only from the carried-in files.
</details>

<details>
<summary>8. After installing Debarchive and editing Apache, calling <code>/debarchive/v1/mirrors</code> returns 401. Is that a problem? <em>(L11-7)</em></summary>

No, it's the expected result. 401 (unauthorized) proves Debarchive is reachable through the reverse proxy and protected by Landscape's authentication.
</details>

<details>
<summary>9. Put these in order and say what each does: publication, mirror, repository profile, publication target. <em>(L11-8)</em></summary>

**Mirror** (local copy of an upstream repository, optionally filtered) → **publication** (point-in-time snapshot of the mirror, signed with your key) → **publication target** (where it's written: filesystem, S3 or Swift) → **repository profile** (points tagged machines' APT sources at the published repository, with the public key). In the lab you created the target first so it was ready when publishing.
</details>

<details>
<summary>10. Why must the signing key have no passphrase, and what do you do if it's compromised? <em>(L11-8)</em></summary>

Landscape signs publications automatically, so it can't type a passphrase. If compromised: generate a new key, update the affected publications and republish, distribute the new public key to clients, and delete the compromised key.
</details>

<details>
<summary>11. Someone with root on airgap-01 runs <code>apt-get install nginx</code>. What happens, and why? <em>(L11-9)</em></summary>

It fails: there's no installation candidate. The repository profile replaced the machine's APT sources with only the approved mirror, which contains only the filtered packages, and the firewall blocks every other source.
</details>

<details>
<summary>12. A regulator asks how you guarantee test and production receive identical packages. Which feature do you describe? <em>(L11-10)</em></summary>

A **snapshot** mirror (the Ubuntu archive as it was on a chosen date), published first to a test publication and then, once validated, the same snapshot to production.
</details>

<details>
<summary>13. Name two honest limitations to raise early with a fully disconnected customer. <em>(L11-11)</em></summary>

Any two of: no incremental diff (the full repository content is transferred each time); snaps aren't mirrored (Enterprise Store needed); the USN database must be carried in manually; Pro can't be attached from the portal for offline clients; Livepatch offline needs confirmation from the product team; the documented fully-disconnected repository steps predate 26.04.
</details>

<details>
<summary>14. A defence customer asks: "Can we sign packages with our own keys?" Give your answer. <em>(L11-11)</em></summary>

Yes. Publications are signed with the customer's own private GPG key, and machines verify with the matching public key delivered by the repository profile. They can also preserve upstream signatures with signature-preserving mirrors.
</details>

<details>
<summary>15. Roughly how much disk does a full Ubuntu 24.04 amd64 mirror need, and give two ways to reduce it. <em>(L11-12)</em></summary>

About 625 GB (docs estimate, April 2026); production guidance is 2 TB or more for mirroring, and a filesystem target of a re-signed mirror needs roughly double. Reduce it by using filtered mirrors, skipping the `restricted` component, or mirroring only the architectures you need.
</details>

## 📚 Read more

- Official docs → *Explanation > Repository mirroring* (mirrors, filtered and signature-preserving mirrors, local repositories, publications, targets, repository profiles, GPG keys)
- Official docs → *How to set up Debarchive with Landscape* and *How to set up repository mirroring end-to-end (26.04 and later)*
- Official docs → *How to manage and mirror repositories from the web portal* (snapshots, Ubuntu Pro mirrors, local repositories)
- Official docs → *How to install Landscape in an airgapped or offline environment* (server, snaps, client, invitations without email, USN database)
- Official docs → *How to manage repositories in an airgapped or offline environment* and *How to create tiered repository mirrors*
- Official docs → *About self-hosted Landscape → Network access* · *How to harden your Landscape deployment → Secure your GPG keys*
- Official docs → *Data handling* and *Cryptographic technology in Landscape*
- Enterprise Store (snaps in restricted networks): <https://documentation.ubuntu.com/enterprise-store/main/>
- Ubuntu snapshot service: <https://snapshot.ubuntu.com/>
- ufw documentation: <https://documentation.ubuntu.com/server/how-to/security/firewalls/>

---

**Next:** [Lab 12: Beyond servers, desktops, WSL, IoT and AI hardware →](12-beyond-servers-wsl-iot-ai.md)
