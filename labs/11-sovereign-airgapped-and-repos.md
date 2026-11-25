# Lab 11: Sovereign, airgapped and repository mirroring

**Time:** 45 minutes · **Mostly concepts and whiteboarding, plus a guided tour of the Repositories UI**

## 🎯 Why this matters on a call

**Sovereignty is one of the hottest topics in enterprise IT right now.** Governments, defence, critical infrastructure, banks, and anyone building **Sovereign AI** (AI infrastructure, models and data kept inside national or organizational boundaries) ask the same questions:

- *"Can we run it with **no Internet connection**?"* (airgapped, disconnected, "dark sites")
- *"Does **any** of our data leave our walls?"*
- *"Can we control **exactly** which software versions enter our environment?"* (software supply-chain security)
- *"Who operates it, us or a vendor?"*

Self-hosted Landscape answers all four, and **repository mirroring** is the feature that makes airgapped patching practical. This lab gives you the vocabulary and the architectures, so you can hold that conversation and know when to bring in a specialist.

---

## Part A: The sovereignty story (learn this narrative)

| Customer concern | Landscape answer |
|---|---|
| **Data residency / sovereignty** | **Self-hosted** Landscape runs entirely on the customer's infrastructure: on-premises, sovereign cloud or any public cloud region. Inventory, activity history and audit data stay in *their* PostgreSQL database. |
| **Don't want to operate it, but need it private** | **Managed Landscape**: single-tenant, can be deployed **on-premises or in public cloud**, operated by Canonical under an SLA. |
| **No Internet (airgap)** | Self-hosted Landscape installs **offline** (packages are downloaded outside and carried in), and **repository mirrors** bring Ubuntu updates inside. |
| **Supply-chain control** | Mirrors, **filtered mirrors**, **snapshots** (the archive as it was on a given date) and **signed publications**: machines only see the packages you've approved. |
| **Identity stays in-house** | Bring your own SSO: OIDC, Active Directory or PAM (Lab 10). |
| **Sovereign AI infrastructure** | GPU fleets and AI workstations (e.g. **NVIDIA DGX Spark**, which NVIDIA recommends managing with Landscape, see Lab 12) can be patched, audited and scripted from a Landscape server **inside** the enclave. |

🎤 **Say it on the call:** *"Sovereign AI isn't only about where the model runs. It's about who controls the whole stack underneath it: the OS, the patches, the packages, the audit trail. With self-hosted Landscape, every piece of that stays inside your boundary, even with no Internet at all."*

---

## Part B: What a self-hosted server normally reaches on the Internet

Before you can talk about airgaps, know what you're cutting off. From the official *About self-hosted Landscape → Network access* section:

| Endpoint | Used for | If it's blocked… |
|---|---|---|
| `usn.ubuntu.com` (HTTPS) | Ubuntu Security Notice database | Landscape can't tell **security** updates from regular ones |
| Ubuntu archive and `changelogs.ubuntu.com` (HTTP) | Package hash database, new releases | Release upgrades don't work |
| `contracts.canonical.com` (HTTPS) | Ubuntu Pro authentication | — |
| `esm.ubuntu.com` (HTTPS) | Ubuntu Pro (ESM) packages | — |
| `livepatch.canonical.com`, `livepatch-files.canonical.com` | Livepatch | — |
| `ubuntu.com/security` | Security information | — |
| `landscape.canonical.com` | Checking for new Landscape releases | Only a notice is missing |
| Snap Store endpoints (`api.snapcraft.io`, etc.) | Snaps | — |

Clients only need to reach the **Landscape server**, on ports **443** (HTTPS) and **80** (HTTP ping).

> [!IMPORTANT]
> The docs say that if this external access isn't available, **Canonical's professional services include assistance with setting up Landscape in a fully airgapped environment.** That's your cue to bring in your services colleagues, and an upsell opportunity.

---

## Part C: Airgap architectures (whiteboard these)

**Network styles**

- **Restricted network airgap (one-way, controlled access):** the inside server can reach out through a controlled path (proxy, firewall rule, or an outside Landscape server). Updates flow in automatically. **Much simpler**.
- **Fully disconnected airgap (manual transfer):** no connectivity at all. Updates are carried in on physical media ("sneakernet").

**Server layouts**

```
1) Single server inside          2) Server outside,            3) Two servers (maximum isolation)
   (firewall allows                 clients inside
    controlled egress)
                                                                Internet
 Internet                         Internet                         │
    │ (controlled)                   │                        ┌────┴─────┐  outer Landscape
 ┌──┴─────────┐                 ┌────┴───────┐               │  server   │  mirrors upstream
 │ Landscape  │                 │ Landscape  │               └────┬─────┘
 │  server    │                 │  server    │          ═══ airgap ═╪═══ (controlled link or media)
 └──┬─────────┘                 └────┬───────┘               ┌────┴─────┐  inner Landscape
 ═══╪═══ airgap ═══          ════════╪═══ airgap ═══         │  server   │  serves clients
  clients                         clients                     └────┬─────┘
                                                                 clients
```

The two-server pattern is also the basis of **tiered mirrors**: an upstream Landscape mirrors from the Internet, and downstream Landscapes (per region or per enclave) mirror from it. That's ideal for **multi-region** and **airgapped** estates.

**An honest limitation to know (it builds trust):** for **fully disconnected** sites, Landscape can't currently produce a "diff" of repository changes, so each update means transferring the **entire** repository content. An Ubuntu release's full archive is **hundreds of GB** (Noble amd64 ≈ 625 GB, per the docs as of April 2026). Filtered mirrors (only the packages you need) shrink this dramatically.

✅ **Checkpoint:** draw all three layouts from memory and explain when each fits.

---

## Part D: Repository mirroring, the concepts

In Landscape **26.04 LTS and later**, mirroring is handled by the **Debarchive** service (`landscape-debarchive`) and uses a **publication model**:

```
 Upstream repo ──sync──► MIRROR ──┐
 (archive.ubuntu.com,             │                      ┌─────────────────────┐   REPOSITORY PROFILE
  third-party, Ubuntu Pro)        ├─► PUBLICATION ─────► │ PUBLICATION TARGET  │ ◄── (APT sources pushed
                                  │  (point-in-time,     │ filesystem / S3 /   │     to tagged machines)
 Your own .deb files ──► LOCAL ───┘   GPG-signed)        │ Swift (MinIO, Ceph) │
                         REPOSITORY                       └─────────────────────┘
```

| Concept | Plain English |
|---|---|
| **Mirror** | A local copy of an upstream repository, e.g. `noble-security` from `archive.ubuntu.com`. You choose the distribution, components (main, universe…) and architectures (amd64, arm64…). |
| **Filtered mirror** | Only the packages matching a filter (optionally with their dependencies). Smaller and tighter control. |
| **Signature-preserving mirror** | Keeps the upstream GPG signatures (no filters allowed). Clients verify against the original publisher. |
| **Snapshot** | Mirror the Ubuntu archive **as it was on a given date**. Great for reproducibility and controlled rollouts. |
| **Local repository** | Hosts the customer's **own** `.deb` packages (internal apps). |
| **Publication** | Publishes a mirror or local repo to a target, **signed with the customer's GPG key**, as a point-in-time snapshot. |
| **Publication target** | Where it's written: a **filesystem** (served by Apache/Nginx; good for airgaps), **S3** (or S3-compatible, e.g. MinIO) or **OpenStack Swift**. |
| **Repository profile** | Points tagged machines at the published repository (Lab 08 family). |
| **Ubuntu Pro mirrors** | You can mirror **ESM** repositories too, so airgapped machines get extended security updates. |

> [!NOTE]
> **Snaps can't be mirrored by Landscape.** For snaps in restricted networks, Canonical offers the **Enterprise Store** (<https://documentation.ubuntu.com/enterprise-store/main/>). Customers will ask, so know the answer.

🎤 **Say it on the call:** *"Picture a staged rollout. On Monday you snapshot the archive. Your test machines get that snapshot through a repository profile. When they pass, you publish the same snapshot to production. Every machine gets exactly the same bits, signed with your key, and nothing enters that you didn't approve. That's software supply-chain control for your OS."*

---

## Part E: Guided tour of the Repositories UI (hands-on, nothing saved)

Your demo server doesn't have Debarchive installed (it needs extra setup and, for real mirrors, lots of disk), so you'll **explore the forms without saving**. That's enough to demo the workflow and explain each field.

1. In the sidebar, open **Repositories**. Notice the sub-sections: **Mirrors**, **Local repositories**, **Publication targets**, **Publications** (and repository **profiles** under **Profiles**).
2. **Mirrors → Add mirror.** For each field, say out loud what it means (use Part D):
   - **Source Type:** *Ubuntu archive*, *Ubuntu Snapshot*, *Ubuntu Pro* (needs a **bearer token**, which is different from the Pro subscription token), or a third-party Debian repository
   - **Source URL**, **Distribution** (e.g. `noble-security`), **Components**, **Architectures**
   - **Preserve upstream signing key** and **Filter**
3. Switch **Source Type** to **Ubuntu Snapshot** and look at the **date** selector.
4. **Publication targets → Add publication target**: note the **filesystem / S3 / Swift** options.
5. **Cancel** everything.

> [!TIP]
> If the Repositories pages show an error because Debarchive isn't installed, that's expected. Use this lab's diagrams to explain the workflow instead, or read the forms' field list in the official guide *How to manage and mirror repositories from the web portal*.

✅ **Checkpoint:** you can explain, without notes, the path from upstream repository → mirror → publication → target → repository profile → machine.

### 🧗 Stretch goal (advanced, optional)

Want a real mirror in your lab? Follow the official guides **"How to set up Debarchive with Landscape"** and **"How to set up repository mirroring end-to-end (26.04 and later)"**, using a **filtered** mirror (a handful of packages) so it fits on your laptop. Budget 2+ hours and give `landscape-server` more disk.

---

## Part F: Disk-space reality check (useful in sizing conversations)

From the official docs (estimates as of April 2026, for main+restricted+universe+multiverse, release+updates+security pockets):

| Series | amd64 | amd64 + i386 |
|---|---|---|
| 26.04 Resolute | ~150 GB | ~180 GB |
| 24.04 Noble | ~625 GB | ~680 GB |
| 22.04 Jammy | ~945 GB | ~975 GB |

Production sizing guidance: **2 TB+** of additional storage if mirroring repositories. Skipping the `restricted` component (proprietary drivers) or using filtered mirrors cuts this significantly.

---

## ❓ Check yourself

<details>
<summary>1. A defence customer has a fully disconnected network. Which edition, and what's the main operational challenge?</summary>

Self-hosted Landscape, installed offline, with repository mirrors (often the two-server pattern). The main challenge is moving repository content in on physical media: there's currently no diff, so the whole repository is transferred each time. Filtered mirrors help, and Canonical professional services can assist.
</details>

<details>
<summary>2. What does a snapshot mirror give the customer?</summary>

The Ubuntu archive as it was at a specific point in time. That gives reproducible, controlled rollouts: test and production get exactly the same package versions.
</details>

<details>
<summary>3. Can Landscape mirror snaps?</summary>

No. Use Canonical's Enterprise Store for snaps in restricted environments.
</details>

<details>
<summary>4. Which three publication target types exist?</summary>

Filesystem (served by your own web server), S3 or S3-compatible object storage, and OpenStack Swift.
</details>

<details>
<summary>5. What breaks if the self-hosted server can't reach usn.ubuntu.com?</summary>

Landscape can't distinguish security updates from regular updates. (In airgapped designs this is handled as part of the offline architecture; involve professional services.)
</details>

## 📚 Read more

- Official docs → *Explanation > Repository mirroring* (concepts, process, hierarchy)
- Official docs → *How to install Landscape in an airgapped or offline environment*
- Official docs → *How to manage repositories in an airgapped or offline environment*
- Official docs → *How to create tiered repository mirrors for multi-region and airgapped deployments*
- Official docs → *How to set up Debarchive with Landscape* and *How to manage and mirror repositories from the web portal*
- Official docs → *About self-hosted Landscape → Network access*

---

**Next:** [Lab 12: Beyond servers, desktops, WSL, IoT and AI hardware →](12-beyond-servers-wsl-iot-ai.md)
