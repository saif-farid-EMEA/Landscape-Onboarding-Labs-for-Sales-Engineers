# Lab 12: Beyond servers. Desktops, WSL, IoT and AI hardware

**Time:** 30 minutes (plus an optional Windows 11 stretch goal) · **Mostly concepts, one web-portal exercise**

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L12-1 | **Manage** local Linux users from the web portal. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part A · Check yourself Q5 |
| L12-2 | **Explain** desktop features: FDE recovery keys, Sanitize and autoinstall provisioning. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q3 |
| L12-3 | **Explain** how Landscape manages Windows machines running WSL, including WSL profiles. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q1, Q6 |
| L12-4 | **Explain** how Landscape manages Ubuntu Core and IoT devices. | [PO5](../reference/learning-objectives.md#po5-specialized-environments) | Check yourself Q2 |
| L12-5 | **Position** Landscape for AI hardware such as NVIDIA DGX Spark, and **state** what stays with NVIDIA tooling. | [PO5](../reference/learning-objectives.md#po5-specialized-environments), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q4 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

Customers rarely have "just servers". They have **developer laptops**, **Windows machines running Ubuntu on WSL**, **edge and IoT devices** in factories and shops, and increasingly **AI workstations and GPU systems**. A big part of Landscape's value is that it's **one tool for every kind of Ubuntu**. This lab gives you the talking points for each, plus one more hands-on capability: managing local users from the browser.

---

## Part A: Manage local users without SSH (hands-on)

Offboarding a contractor, creating a break-glass account or locking a compromised login are everyday tasks that normally need SSH and `sudo`.

🖱️ **In the web portal**

1. **Instances → db-01 → Users** tab. You'll see the local Linux users (e.g. `ubuntu`) and groups.
2. **Add user**: username `auditor`, a name and a password. Primary group is optional.
3. Watch the activity under **Activities** until it **Succeeds**.
4. Back on **Users**, select `auditor` → **Lock**. (Locking disables login without deleting the account.)

✅ **Checkpoint:** check it from your laptop:

```bash
multipass exec db-01 -- id auditor
```

*What this does:* `id` prints a user's ID and groups. If the user exists, you'll see a line starting with `uid=`.

🎤 **Say it on the call:** *"When someone leaves, you lock their local accounts across every machine from one screen, and the activity log proves when it happened. That's a common audit finding closed."*

---

## Part B: Desktops and laptops

Landscape manages **Ubuntu Desktop** the same way as servers: inventory, patches, scripts, profiles. Desktop-specific highlights:

| Capability | Talking point |
|---|---|
| **FDE recovery keys** (26.04 LTS+) | For machines with TPM-backed full-disk encryption, Landscape can request, store and retrieve **recovery keys** centrally (client 26.04+ with the `FDERecoveryKeyManager` plugin, snapd 2.74+). *"The helpdesk can unlock a locked-out laptop without a sticky note."* |
| **Sanitize** (25.04+) | Remotely and **irreversibly** erases the LUKS encryption key slots on a machine, making its encrypted data unrecoverable, then shuts it down. *"A laptop is stolen: you wipe it remotely."* (**Instances → machine → Info → Sanitize**. ⚠️ Never click it on a machine you care about.) |
| **Provisioning with autoinstall** (25.10+, experimental) | The Ubuntu installer (26.04 and later) can fetch an autoinstall file from Landscape for an OIDC-authenticated employee, which opens up zero-touch laptop provisioning. |
| **Users tab** | See Part A. |

---

## Part C: Windows + WSL ("Ubuntu on every Windows laptop")

Developers on Windows increasingly run Ubuntu through **WSL** (Windows Subsystem for Linux). For IT, that's a **shadow-IT blind spot**: unmanaged Linux on corporate laptops.

How Landscape closes it:
- **Ubuntu Pro for WSL** is a Microsoft Store app that runs on the **Windows 11** host. It registers the Windows machine with Landscape and attaches Ubuntu Pro to its WSL instances.
- In Landscape, the **Windows machine** appears as a host, with its **WSL instances** as child instances.
- **WSL profiles** define which Ubuntu WSL instances **must** exist on Windows hosts (from the Microsoft Store or a **custom image**, optionally customized with **cloud-init**), and can flag or prevent WSL instances that **weren't** created through Landscape (compliance settings).

🎤 **Say it on the call:** *"Your developers get the Ubuntu they want on Windows. You get it inventoried, patched, Pro-covered and compliant, with no unmanaged Linux hiding on corporate laptops."*

### 🧗 Stretch goal (Windows 11 users only)

Follow the official guide **"How to set up Ubuntu Pro for WSL and register WSL hosts to Landscape"**. In short: install **WSL** and an **Ubuntu** app from the Microsoft Store, install **Ubuntu Pro for WSL**, enter your Pro token, then your Landscape server address (Quickstart serves the WSL host agent on port **6554**) and its certificate. Then accept the Windows host in **Instances** and look at its child WSL instances. The guide also covers certificate requirements and troubleshooting. Expect to spend some time on the certificate if you use your self-signed lab server.

---

## Part D: IoT and edge, Ubuntu Core

**Ubuntu Core** is the minimal, fully containerized ("snapped") Ubuntu for devices: kiosks, gateways, robots, signage, industrial PCs.

- Devices run the **Landscape Client snap**, which is strictly confined, works with **limited or intermittent connectivity**, and needs self-hosted Landscape 23.10+.
- From the portal you can manage snaps, run **remote scripts**, manage users, and use annotations, without anyone visiting the device.
- Snap updates are **transactional with automatic rollback on failure**, so a bad update doesn't brick a device in a remote location.
- You can build an **Ubuntu Core image with Landscape Client included**, so devices register themselves on first boot.

🎤 **Say it on the call:** *"Your devices sit on factory floors or in thousands of stores. Nobody's driving out to patch them. Landscape lets you choose exactly when and what they update, check their health remotely, and roll back automatically if something goes wrong."*

---

## Part E: AI hardware, NVIDIA DGX Spark

**NVIDIA DGX Spark** is a compact AI computer, a desktop-sized AI supercomputer, running **DGX OS**, which is based on Ubuntu. **NVIDIA describes Landscape as its primary recommended management platform for DGX Spark.**

- A DGX Spark registers like any Ubuntu machine (Landscape SaaS or self-hosted) and gets the same inventory, patching, tags, access groups and scripts.
- NVIDIA publishes **Landscape reference scripts** (e.g. signing verification, encryption at rest) built for Landscape's remote script execution. You add them under **Scripts**, with attachments where needed, and run them across the fleet, with every run tracked as an activity.
- Landscape manages the **Ubuntu-based OS layer**. For firmware, drivers, recovery and out-of-band management, customers use NVIDIA's own tooling.

🎤 **Say it on the call:** *"AI teams are buying GPU workstations faster than IT can govern them. NVIDIA's own answer for managing DGX Spark fleets is Landscape: same console, same RBAC, same audit trail as the rest of your Ubuntu estate. And if those AI systems sit in a sovereign or disconnected environment, self-hosted Landscape goes in with them."*

---

## Part F: Clouds

- **Ubuntu Pro images on AWS, Azure and Google Cloud come already attached to Pro**. Register them with Landscape and they're licensed.
- The docs include guides for running the **Landscape server** itself on **Google Cloud** and **Microsoft Azure**, and for registering **Amazon WorkSpaces** Ubuntu desktops with Landscape SaaS.

---

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. What app connects a Windows 11 machine's WSL instances to Landscape? <em>(L12-3)</em></summary>

Ubuntu Pro for WSL, from the Microsoft Store.
</details>

<details>
<summary>2. Which Landscape Client variant runs on Ubuntu Core devices? <em>(L12-4)</em></summary>

The Landscape Client snap (strictly confined).
</details>

<details>
<summary>3. What does "Sanitize" do, and can you undo it? <em>(L12-2)</em></summary>

It erases the LUKS key slots on all encrypted volumes, making their data unrecoverable, then shuts the machine down. It's irreversible once the activity is delivered.
</details>

<details>
<summary>4. What does Landscape manage on an NVIDIA DGX Spark, and what does it leave to NVIDIA tools? <em>(L12-5)</em></summary>

Landscape manages the Ubuntu-based DGX OS: inventory, packages, security updates, tags and access groups, and scripts (including NVIDIA's Landscape reference scripts). Hardware, firmware, drivers, recovery and out-of-band management use NVIDIA's tooling.
</details>

<details>
<summary>5. A contractor leaves today. How can Landscape help, without anyone using SSH? <em>(L12-1)</em></summary>

Open each machine's Users tab and lock (or remove) the contractor's local account. Each change runs as an activity, which also records when it happened.
</details>

<details>
<summary>6. What does a WSL profile let IT enforce on Windows machines? <em>(L12-3)</em></summary>

Which Ubuntu WSL instance must be installed (from the Microsoft Store or a custom image, optionally with cloud-init), and how to treat WSL instances that weren't created through Landscape. Landscape flags Windows machines that don't comply.
</details>

## 📚 Read more

- Official docs → *WSL integration* (set up Ubuntu Pro for WSL, WSL profiles, common tasks)
- Official docs → *IoT for devices* (Client snap, Ubuntu Core image with client included, scripts and annotations on Core)
- Official docs → *Landscape and NVIDIA DGX Spark*, *How to set up NVIDIA DGX Spark for Landscape management*
- Official docs → *Explanation > FDE recovery keys*, *Web portal > Sanitize instances*
- NVIDIA DGX Spark enterprise lifecycle: <https://docs.nvidia.com/dgx/dgx-spark/enterprise-fleet-lifecycle.html>
- Ubuntu on WSL docs: <https://ubuntu.com/wsl/docs/latest/>

---

**Next:** [Lab 13: Your first demo →](13-your-first-demo.md)
