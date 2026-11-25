# Lab 13: Your first demo

**Time:** 60 minutes (and then practice, practice, practice) · **Prerequisite:** Labs 04 to 10

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L13-1 | **Run** discovery and **choose** the demo storyline that fits the customer's answers. | [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q1 |
| L13-2 | **Deliver** the 20-minute security-led demo in under 20 minutes, without notes. | [PO6](../reference/learning-objectives.md#po6-sell), [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Practice exercise and rubric |
| L13-3 | **Adapt** the demo for compliance, operations, sovereignty and AI/developer audiences. | [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q2 |
| L13-4 | **Recover** smoothly from common demo failures. | [PO6](../reference/learning-objectives.md#po6-sell), [PO7](../reference/learning-objectives.md#po7-self-sufficiency) | Check yourself Q3 |
| L13-5 | **Handle** common objections accurately, and say "let me confirm" when unsure. | [PO6](../reference/learning-objectives.md#po6-sell) | Practice exercise (skeptical CISO role-play) · Check yourself Q4 |
| L13-6 | **Locate** the official documentation section that answers a customer's deep technical question. | [PO7](../reference/learning-objectives.md#po7-self-sufficiency) | Check yourself Q5 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Goal

Run a **20-minute, story-driven Landscape demo** on your own estate, tailored to the person in front of you, and handle the questions that follow.

> [!TIP]
> **A good demo is a story, not a feature tour.** Start with the customer's pain, show the shortest path to relief, then stop. Your demo estate has only 3 machines. Say *"the same view works for 30,000"* once, then let the product speak.

---

## 1. Before the call: discovery questions

Ask these (or find out from the account team) **before** you demo. The answers tell you which story to tell.

**Estate**
1. How many Ubuntu machines do you run? Servers, desktops, cloud, edge? Which releases?
2. Do you have Windows developers using WSL? Any AI or GPU systems (e.g. DGX)?
3. Any machines on releases approaching end of standard support?

**Today's process**
4. Walk me through what happens when a critical CVE is announced. Who finds out, and how long until it's patched everywhere?
5. How do you patch today? Scripts, Ansible, a cron job, manually?
6. How do you handle kernel updates and reboots?

**Security and compliance**
7. Which frameworks do you report against: CIS, DISA-STIG, ISO 27001, PCI DSS, NIS2, DORA, FedRAMP?
8. How do you produce evidence for auditors today?
9. Who has root/SSH on production? How is access revoked when people leave?

**Environment and constraints**
10. Any airgapped or restricted networks? Data-sovereignty requirements?
11. SaaS acceptable, or must it be self-hosted? Would you rather Canonical operated it?
12. Do you already have Ubuntu Pro? (If yes, they already own Landscape.)

---

## 2. Choose your storyline

| If they care most about… | Lead with | Labs |
|---|---|---|
| **Security / CVEs** (CISO, SecOps) | Discover → fix → verify a vulnerability; Livepatch | 06, 07D |
| **Compliance** (GRC, auditors, public sector) | USG audit → report → fix; RBAC; security logs | 09, 10 |
| **Operations efficiency** (IT ops, platform team) | Inventory → profiles → scheduled upgrades → scripts | 05, 08, 07 |
| **Sovereignty / airgap** (government, defence, Sovereign AI) | Self-hosted architecture, mirrors and snapshots, SSO | 11, 10 |
| **Developer and AI fleets** | WSL, DGX Spark, desktops | 12 |

---

## 3. The 20-minute demo (security-led, the most common)

**Prep (5 minutes before the call):** run the [pre-demo checklist](14-reset-and-teardown.md#pre-demo-checklist-run-before-every-call). In particular, make **web-01** vulnerable again (Lab 06, Part B).

| Min | Show (click path) | Say (talk track) |
|---|---|---|
| **0–2** | *No screen yet.* | Recap their pain in their words: *"You told me a critical CVE takes you about two weeks to close across 800 servers, and you find out from the news. Let me show you what that looks like with Landscape."* |
| **2–5** | **Overview** → instance counts, **Security** upgrades count | *"This is your whole Ubuntu estate, servers, desktops, cloud, edge, in one place. The first number I look at is this one: machines with open security fixes."* |
| **5–7** | **Instances** → search `alert:security-upgrades tag:production` → **Save search** | *"Production machines with open security issues: saved, so your team sees it every morning."* |
| **7–10** | **web-01 → Security issues** → open the **USN** on ubuntu.com → CVEs | *"Not just 'an update exists': this is the exact Ubuntu Security Notice and the CVEs behind it, published by Canonical's security team, the people who built the fix."* |
| **10–12** | Select → **Upgrade** → **Activities** (Queued → Succeeded) | *"One click. No SSH, no shared root password. And here's the record: who did it, when, on which machines, and the result."* |
| **12–14** | **web-01 → Kernel** tab | *"Kernel fixes usually mean reboots. Livepatch applies critical and high kernel fixes live. Here's this machine's patch status and how long its kernel stays covered."* |
| **14–17** | **Profiles → Upgrade profiles** → `nightly-security` (+ glance at **Reboot profiles**) | *"Now take people out of the loop: security-only updates every night in your window, on everything tagged production, staggered. Reboots on Sunday, staggered, so the cluster stays up. New machines inherit this automatically."* |
| **17–19** | **Profiles → USG profiles** → **Download audit** (have a CSV ready) | *"And when the auditor asks: CIS or DISA-STIG, every machine, every rule, weekly, with history."* |
| **19–20** | *Back to them.* | *"Which of these would make the biggest difference for your team in the next 90 days?"* **Then stop talking.** |

> [!IMPORTANT]
> **Activities take a minute or two** (the client has to check in). Don't stare at the spinner in silence. Start the upgrade, say *"while that runs on the machine, let me show you…"*, move on, and come back to it.

---

## 4. Variations (5-minute inserts)

- **Compliance-led:** open with **USG profiles → Download audit** (pass rate, one failing high-severity rule and its rationale), then RBAC (*"auditors get read-only access"*), then security event logging.
- **Ops-led:** open with **Instances** (mixed releases, tags, saved searches, annotations), then **Deb management** across machines, **package profile** (`production-baseline`), then a read-only **script** across the fleet.
- **Sovereignty-led:** start on a whiteboard (Lab 11 layouts), then show the self-hosted portal, the **Repositories** pages and SSO options. Close with *"every byte stays inside your boundary."*
- **AI/developer-led:** WSL hosts and child instances, the DGX Spark story, running NVIDIA reference scripts as Landscape scripts.

---

## 5. When things go wrong (they will)

| Problem | Recovery line, then the fix |
|---|---|
| Activity stuck in **Queued** | *"The agent checks in on an interval. It's designed for machines behind firewalls. Let's look at the result in a minute."* Then continue. (Fix later: [Troubleshooting](../reference/troubleshooting.md#activities-stay-queued).) |
| No security issues to show | *"Good news, this estate is clean! Let me show you what it looks like when it isn't."* Then switch to a USG audit or a screenshot you prepared. Next time, do the pre-demo checklist. |
| Laptop or VMs dead | Switch to your **SaaS** account (Lab 02) or recorded screenshots. Always have a plan B. |
| A question you can't answer | *"Great question. I want to give you a precise answer, so let me confirm with our product team and come back to you by Friday."* Write it down, and **do** follow up. |

---

## 6. Practice exercise

1. Run the 20-minute demo **out loud**, alone, with a timer. Record it.
2. Watch it back and score yourself with the rubric below.
3. Run it again for a colleague or your manager, who plays a **skeptical CISO**. Ask them to use at least three objections from [Talk tracks and objections](../reference/talk-tracks-and-objections.md).

**Self-assessment rubric** (score 1–3 each)

| | 1 | 3 |
|---|---|---|
| Opened with *their* pain | Started with "let me show you features" | Restated their problem in their words |
| Navigation | Hunted for buttons | Every click was purposeful |
| Explained, not narrated | "Now I click here…" | "This lets your team…" |
| Handled waiting time | Silence while spinners ran | Filled with value and moved on |
| Accuracy | Guessed at an answer | Precise, or "let me confirm" |
| Close | Ended on a feature | Ended with a question about their priorities |

---

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. In discovery, a customer says: "Our auditors gave us three findings about unpatched servers, and we report against CIS." Which storyline do you choose? <em>(L13-1)</em></summary>

Compliance-led (USG audit report, then patching and RBAC), with security patching as the second act. See section 2.
</details>

<details>
<summary>2. You're demoing to a government agency that mentions "no data may leave our network". What do you change in your demo? <em>(L13-3)</em></summary>

Lead with the sovereignty storyline: whiteboard the self-hosted and airgapped architecture, then show the self-hosted portal, the Repositories pages and SSO options (section 4).
</details>

<details>
<summary>3. Mid-demo, your upgrade activity is stuck on "Queued". What do you say and do? <em>(L13-4)</em></summary>

Explain that the agent checks in on an interval (designed for machines behind firewalls), move on to the next part of the story, and come back to the result later. Fix the underlying issue after the call.
</details>

<details>
<summary>4. A CISO says: "Agents are a security risk." Give your answer. <em>(L13-5)</em></summary>

The client connects outbound over HTTPS, so there's no inbound port to open; remote script execution is off by default and limited to the users you allow; every action is an audited activity governed by RBAC. Compare that with shared SSH keys or root on every box.
</details>

<details>
<summary>5. After the demo, the customer's architect asks: (a) which outbound hosts the server needs, (b) how passwords and data at rest are protected, (c) how to run Landscape highly available. Where do you look? <em>(L13-6)</em></summary>

(a) *About self-hosted Landscape → Network access*; (b) *Cryptographic technology in Landscape* and *Data handling*; (c) *How to install and configure Landscape for high-availability deployments*. All are listed in the [Read-more map](../reference/read-more-map.md). Send the links, then follow up with any answer you need to confirm.
</details>

---

## ✅ You're demo-ready when you can…

- [ ] Explain Landscape, the 3 editions and Ubuntu Pro licensing in 60 seconds without slides
- [ ] Rebuild the demo estate from scratch (Labs 03–04) without the lab instructions open
- [ ] Run the 20-minute security demo with no notes, in under 20 minutes
- [ ] Answer: *"Isn't this just Ansible?"*, *"Can it run airgapped?"*, *"How is it licensed?"*, *"What's Livepatch?"*, *"Can we use our Okta?"*
- [ ] Explain CVE vs. USN, `apt update` vs. `apt upgrade`, tags vs. access groups vs. annotations
- [ ] Say where to look in the docs for anything you can't answer ([Read-more map](../reference/read-more-map.md))

---

**Next:** [Lab 14: Reset and teardown →](14-reset-and-teardown.md)
