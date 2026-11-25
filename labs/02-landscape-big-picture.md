# Lab 02: Landscape, the big picture

**Time:** 45 minutes · **Mostly reading and whiteboarding, plus one optional web sign-up**

## 🎯 Why this matters on a call

In the first 5 minutes of a call, a customer decides whether you understand their world. You need to be able to say, without slides, **what Landscape is, how it works, how it's delivered and how it's licensed.** This lab gives you that.

---

## 1. Landscape in one sentence

> **Landscape is Canonical's systems management tool for Ubuntu.** From one web portal (or API), you can inventory, patch, secure, audit and automate every Ubuntu machine you own: servers, desktops, cloud instances, IoT devices, WSL on Windows, and AI workstations.

It's for **sysadmins, security teams, IT managers and compliance officers**, and it scales from a handful of machines to large enterprise estates in on-premises, cloud and hybrid environments.

## 2. How it works: client and server

```
  Admins (browser / REST API)
              │ HTTPS
              ▼
 ┌────────────────────────┐          Canonical data sources
 │    Landscape Server     │ ───────► Ubuntu Security Notices (USNs),
 │  web portal · API ·     │          Ubuntu archive, Ubuntu Pro,
 │  message system         │          Livepatch
 │  (PostgreSQL, RabbitMQ) │
 └────────────────────────┘
      ▲        ▲        ▲      Each client "phones home" over HTTPS:
      │        │        │      it reports inventory and status, then
 ┌────┴──┐ ┌───┴───┐ ┌──┴────┐ picks up queued work ("activities")
 │Client │ │Client │ │Client │
 └───────┘ └───────┘ └───────┘
  servers   desktops   IoT/WSL/cloud
```

- **Landscape Server** is the central brain. You use it through the **web portal** or the **API**. Behind the scenes it uses **PostgreSQL** (database), **RabbitMQ** (task queue) and usually **HAProxy or Apache** (HTTPS front door).
- **Landscape Client** is a small agent installed on each managed machine. It sends information (hardware, packages, security status) to the server and carries out the actions you request.
- **Activities:** when you click "upgrade" in the portal, Landscape doesn't reach into the machine. It queues an *activity*. The next time the client checks in, it collects the activity, runs it and reports back "Succeeded" or "Failed". You'll watch this happen in Lab 04.

🎤 **Say it on the call:** *"Clients connect **out** to the server over HTTPS. You don't need to open inbound SSH to every machine, and every action is recorded as an activity: who asked for it, when, and what happened."*

## 3. What Landscape does (the 6 capability pillars)

| Pillar | Customer problem | Lab |
|---|---|---|
| **Inventory and monitoring** | "We don't actually know what we're running." | 05 |
| **Security patching and Livepatch** | "Patching is slow and manual, and reboots hurt." | 06 |
| **Remote script execution** | "We need to run X on 400 machines *now*." | 07 |
| **Package, snap and profile management** | "Keep software consistent, and do upgrades in maintenance windows." | 08 |
| **Compliance (CIS / DISA-STIG via USG)** | "Our auditors want proof." | 09 |
| **RBAC and access control** | "Different teams own different machines." | 10 |
| **Repository mirroring** (self-hosted) | "We're airgapped / we need to control exactly which versions get in." | 11 |

## 4. The three editions

| | **Landscape SaaS** | **Managed Landscape** | **Self-hosted Landscape** |
|---|---|---|---|
| Who runs the server? | Canonical, on shared (multi-tenant) infrastructure | Canonical runs it, but on **dedicated** single-tenant infrastructure, in public cloud or on-premises | The customer |
| Canonical uptime SLA | — | ✅ | — (support via Ubuntu Pro) |
| Setup effort | None: sign up and go | Canonical does it | Customer installs it (Quickstart, Manual or Juju charms) |
| Works without Internet (airgapped) | ❌ | Can be deployed on-premises | ✅ |
| Repository mirroring | ❌ | ✅ | ✅ |
| Bring your own SSO / identity provider | ❌ | ✅ | ✅ (OIDC, Active Directory, PAM) |
| Inventory, compliance, security, hardening | ✅ | ✅ | ✅ |

> [!NOTE]
> This table is based on the official "About Landscape" and "What is Landscape?" pages. Feature availability can change between releases. Before you commit to anything in writing, double-check the current docs or ask your product team.

**How to choose (rule of thumb for discovery):**
- *"We want it working this afternoon and we're fine with cloud."* → **SaaS**
- *"We need data residency / our own SSO / repo mirrors, but we don't want to run it ourselves."* → **Managed**
- *"We're airgapped, or regulated, or we want full control."* → **Self-hosted**

## 5. Licensing: it's Ubuntu Pro

- **Ubuntu Pro is Landscape's main licensing mechanism.** Landscape SaaS is *included* in Ubuntu Pro. Most self-hosted deployments also license through Pro.
- When a client is attached to Ubuntu Pro, Landscape detects the entitlement and licenses that machine automatically.
- **Free tier:** up to 5 machines with a personal Pro subscription.
- Ubuntu Pro also brings: **ESM** (10-year security maintenance for main *and* universe), **Livepatch**, **FIPS** packages, **USG** (CIS/DISA-STIG hardening) and more. Landscape is where you *see and drive* all of these.
- On public clouds (AWS, Azure, Google Cloud), "Ubuntu Pro" images come already attached.

🎤 **Say it on the call:** *"You don't buy Landscape on its own. It's part of Ubuntu Pro. So the question isn't 'can we afford another tool', it's 'are we getting full value from the Pro we already have?'"*

📚 **Read more:** official docs → *Explanation > Landscape licenses*, and *How to attach your Ubuntu Pro subscription*.

## 6. Self-hosted release cadence (for when IT asks)

- **LTS** versions every two years (e.g. **26.04 LTS**, **24.04 LTS**), recommended for production. Standard support for 5 years, then **ESM** for longer (26.04 LTS: standard support until April 2031, ESM until April 2038).
- **Latest stable** versions every 6 months (e.g. **26.10**). They get new features first, but are supported only until the next release.
- **Landscape SaaS** gets new features through a phased rollout.

In this course you'll install **latest-stable (26.10)**, because it has the newest web portal and features for demos. Production customers usually choose an **LTS**.

## 7. "Isn't this just Ansible?" (you WILL be asked)

| | **Landscape** | **Ansible** |
|---|---|---|
| Main goal | **Observe and manage state** continuously (health, security, compliance) | **Define and enforce state** (configure servers from playbooks) |
| Agent | Agent-based (continuous status) | Agentless (SSH on demand) |
| Focus | Ubuntu-native: USNs, Livepatch, Ubuntu Pro, ESM | Cross-platform, general purpose |
| Interface | Web portal and REST API | CLI and YAML playbooks |

**They complement each other.** A common pattern is to *provision* with Ansible (the last task installs and registers Landscape Client) and then use Landscape for *ongoing* patching, auditing and delegated operations.

🎤 **Say it on the call:** *"Keep your Ansible. Landscape gives you what Ansible doesn't: a live, historical view of your Ubuntu estate's security posture, tied directly to Canonical's security notices, plus role-based access so people can patch without SSH keys."*

## 8. Where Landscape fits in the Canonical portfolio

- **MAAS** provisions bare-metal servers → **Juju** deploys and operates applications (and can deploy Landscape for high availability) → **Landscape** manages the Ubuntu machines day to day → **COS** (Canonical Observability Stack) monitors the whole stack.
- **Ubuntu Pro** licenses everything and provides ESM, Livepatch, FIPS and USG.

---

## 🖱️ Optional hands-on: create a Landscape SaaS account (10 min)

Even on the full path, a SaaS account is a useful **backup demo environment** if your laptop fails before a call.

1. Go to <https://landscape.canonical.com/signup> and sign in with Ubuntu One.
2. Enter an organization name (e.g. `yourname-demo`) and click **Sign up**.
3. Look around the empty portal. Find your **account name** on the home page (you'd need it to register machines).

✅ **Checkpoint:** you can log in at <https://landscape.canonical.com>.

---

## 🖊️ Exercise: whiteboard it

Without looking at this page, draw on paper:
1. Server, 3 clients, the admin's browser, and the direction of each connection.
2. Where PostgreSQL and RabbitMQ sit.
3. Where the USN data comes from.

Then explain the drawing out loud in 60 seconds, as if to a customer. Record yourself on your phone if you can. It feels awkward, and it works.

## ❓ Check yourself

<details>
<summary>1. A bank says "nothing leaves our data center, and we have no Internet on our production network." Which edition?</summary>

Self-hosted Landscape, possibly with repository mirroring for the airgapped network (Lab 11). Managed Landscape deployed on-premises is also worth raising if they don't want to operate it themselves.
</details>

<details>
<summary>2. Do clients need inbound SSH open for Landscape to manage them?</summary>

No. The client connects out to the server over HTTPS and picks up queued activities.
</details>

<details>
<summary>3. Which Landscape edition doesn't offer repository mirroring?</summary>

Landscape SaaS.
</details>

<details>
<summary>4. What is an "activity"?</summary>

A tracked unit of work, such as running a script or installing a package. It's queued on the server, delivered to the client when the client checks in, and its result (Succeeded/Failed) plus who requested it is recorded.
</details>

## 📚 Read more

- Official docs → *What is Landscape?*, *About Landscape*, *Landscape deployment models*, *About self-hosted Landscape*
- Official docs → *Related tools: Landscape and Ansible*
- Product page: <https://ubuntu.com/landscape> · Managed Landscape: <https://ubuntu.com/landscape/managed>

---

**Next:** [Lab 03: Build your demo server →](03-build-your-demo-server.md)
