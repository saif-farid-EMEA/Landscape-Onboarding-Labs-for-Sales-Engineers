# Lab 02: Landscape, the big picture

**Time:** 45 minutes · **Mostly reading and whiteboarding, plus one optional web sign-up**

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L02-1 | **Describe** Landscape in one sentence and **name** who uses it. | [PO2](../reference/learning-objectives.md#po2-positioning) | Whiteboard exercise |
| L02-2 | **Explain** the client–server architecture, including activities and the fact that clients connect outbound. | [PO2](../reference/learning-objectives.md#po2-positioning) | Whiteboard exercise · Check yourself Q2, Q4 |
| L02-3 | **Match** Landscape's capability pillars to the customer problems they solve. | [PO2](../reference/learning-objectives.md#po2-positioning) | Check yourself Q5 |
| L02-4 | **Compare** SaaS, Managed and self-hosted Landscape and **recommend** one from customer requirements. | [PO2](../reference/learning-objectives.md#po2-positioning) | Check yourself Q1, Q3 |
| L02-5 | **Explain** how Landscape is licensed through Ubuntu Pro. | [PO2](../reference/learning-objectives.md#po2-positioning) | Check yourself Q6 |
| L02-6 | **Position** Landscape against Ansible and within the Canonical portfolio. | [PO2](../reference/learning-objectives.md#po2-positioning), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q7 |
| L02-7 | **Explain** the difference between Landscape LTS and latest-stable releases. | [PO2](../reference/learning-objectives.md#po2-positioning) | Check yourself Q8 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

In the first 5 minutes of a call, a customer decides whether you understand their world. You need to be able to say, without slides, **what Landscape is, how it works, how it's delivered and how it's licensed.** This lab gives you that.

---

## 1. Landscape in one sentence

> **Landscape is Canonical's systems management tool for Ubuntu.** From one web portal (or API), you can inventory, patch, secure, audit and automate every Ubuntu machine you own: servers, desktops, cloud instances, IoT devices, WSL on Windows, and AI workstations.

It's for **sysadmins, security teams, IT managers and compliance officers**, and it scales from a handful of machines to large enterprise estates in on-premises, cloud and hybrid environments.

## 2. How it works: client and server

![Architecture diagram: admins use the web portal or REST API over HTTPS to reach Landscape Server (web portal, REST API, message system; running on PostgreSQL, RabbitMQ and HAProxy or Apache), which pulls data from Canonical: Ubuntu Security Notices, the Ubuntu archive, Ubuntu Pro and Livepatch. Servers, desktops, cloud instances, WSL, IoT devices and AI systems each run Landscape Client and connect outbound over HTTPS; no inbound SSH is needed.](../diagrams/landscape-architecture.svg)

<sub>🖼️ Reuse it in your slides: [PNG](../diagrams/png/landscape-architecture.png) · [SVG](../diagrams/landscape-architecture.svg) · [how these diagrams are designed](../diagrams/README.md)</sub>

- **Landscape Server** is the central brain. You use it through the **web portal** or the **API**. Behind the scenes it uses **PostgreSQL** (database), **RabbitMQ** (task queue) and usually **HAProxy or Apache** (HTTPS front door).
- **Landscape Client** is a small agent installed on each managed machine. It sends information (hardware, packages, security status) to the server and carries out the actions you request.
- **Activities:** when you click "upgrade" in the portal, Landscape doesn't reach into the machine. It queues an *activity*. The next time the client checks in, it collects the activity, runs it and reports back "Succeeded" or "Failed". You'll watch this happen in Lab 04.

![Activity lifecycle in six steps: 1 an admin asks in the portal or API; 2 the activity is queued or scheduled on the server; 3 the client checks in over outbound HTTPS and collects it; 4 it runs locally; 5 the result is reported; 6 it is recorded as Succeeded or Failed with who, when and output. States: Queued, Scheduled, Waiting, Blocked, In progress, Succeeded, Failed, Canceled.](../diagrams/activity-lifecycle.svg)

<sub>🖼️ Reuse it in your slides: [PNG](../diagrams/png/activity-lifecycle.png) · [SVG](../diagrams/activity-lifecycle.svg) · [how these diagrams are designed](../diagrams/README.md)</sub>

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

![Comparison of the three editions. Landscape SaaS: operated by Canonical in its cloud, multi-tenant, no airgap, no repository mirroring, no bring-your-own SSO; best to start today. Managed Landscape: operated by Canonical under an SLA, public cloud or on-premises, single-tenant, mirroring and SSO, airgap to be confirmed; best for private and dedicated without running it. Self-hosted: operated by your team anywhere, single-tenant, airgap, mirroring and SSO; best for airgapped, regulated, full control.](../diagrams/landscape-editions.svg)

<sub>🖼️ Reuse it in your slides: [PNG](../diagrams/png/landscape-editions.png) · [SVG](../diagrams/landscape-editions.svg) · [how these diagrams are designed](../diagrams/README.md)</sub>

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

Each question is tagged with the learning objective it checks.

<details>
<summary>1. A bank says "nothing leaves our data center, and we have no Internet on our production network." Which edition? <em>(L02-4)</em></summary>

Self-hosted Landscape, possibly with repository mirroring for the airgapped network (Lab 11). Managed Landscape deployed on-premises is also worth raising if they don't want to operate it themselves.
</details>

<details>
<summary>2. Do clients need inbound SSH open for Landscape to manage them? <em>(L02-2)</em></summary>

No. The client connects out to the server over HTTPS and picks up queued activities.
</details>

<details>
<summary>3. Which Landscape edition doesn't offer repository mirroring? <em>(L02-4)</em></summary>

Landscape SaaS.
</details>

<details>
<summary>4. What is an "activity"? <em>(L02-2)</em></summary>

A tracked unit of work, such as running a script or installing a package. It's queued on the server, delivered to the client when the client checks in, and its result (Succeeded/Failed) plus who requested it is recorded.
</details>

<details>
<summary>5. A customer says "patching is slow, and kernel reboots hurt us". Which capabilities do you lead with? <em>(L02-3)</em></summary>

Security patching (Security upgrades, USNs, one-click upgrades and upgrade profiles) and Livepatch status on the Kernel tab. See Labs 06 and 08.
</details>

<details>
<summary>6. A customer already pays for Ubuntu Pro on 500 servers. What extra do they need to buy to start using Landscape SaaS? <em>(L02-5)</em></summary>

Nothing extra for Landscape itself: Landscape SaaS is included in Ubuntu Pro. (Managed Landscape is a separate conversation with Sales.)
</details>

<details>
<summary>7. In two sentences, how do Landscape and Ansible differ, and how can they work together? <em>(L02-6)</em></summary>

Ansible is agentless and defines and enforces configuration from code; Landscape is agent-based and continuously observes and manages the state of an Ubuntu estate, tied to USNs, Livepatch and Pro, with RBAC. A common pattern is to provision with Ansible (its last task registers the Landscape client) and use Landscape for ongoing patching, auditing and delegated operations.
</details>

<details>
<summary>8. Which self-hosted Landscape release would you recommend for production, and why? <em>(L02-7)</em></summary>

The current LTS (26.04 LTS at the time of writing). LTS releases get standard support for 5 years plus ESM, while latest-stable releases are only supported until the next release.
</details>

## 📚 Read more

- Official docs → *What is Landscape?*, *About Landscape*, *Landscape deployment models*, *About self-hosted Landscape*
- Official docs → *Related tools: Landscape and Ansible*
- Product page: <https://ubuntu.com/landscape> · Managed Landscape: <https://ubuntu.com/landscape/managed>

---

**Next:** [Lab 03: Build your demo server →](03-build-your-demo-server.md)
