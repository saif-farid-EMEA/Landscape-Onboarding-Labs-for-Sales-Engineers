# Landscape Onboarding Labs for Sales Engineers

**Learn to give a confident Landscape demo, even if you've never used Linux.**

These hands-on labs are for new Canonical Sales Engineers who have never used Linux or Landscape.

## Learning outcomes

By the end of the course, you will be able to:

| ID | Outcome | You will be able to… |
|---|---|---|
| **PO1** | Linux fluency | Use an Ubuntu terminal for basic tasks and explain the Linux concepts that come up on calls: packages and repositories, `sudo`, services, the kernel, CVEs and USNs. |
| **PO2** | Positioning | Explain what Landscape is, how it works, its three editions and how it's licensed through Ubuntu Pro, and recommend an edition from a customer's requirements. |
| **PO3** | Build | Deploy a self-hosted Landscape demo environment and enroll machines with both manual and automated registration. |
| **PO4** | Demonstrate core capabilities | Demonstrate inventory and search, security patching and Livepatch, remote scripts, package and profile policy, CIS/DISA-STIG compliance and RBAC in the web portal, and explain the value of each. |
| **PO5** | Specialized environments | Explain sovereign and airgapped architectures (including the Sovereign AI story), repository mirroring, and how Landscape covers desktops, WSL, IoT devices and AI hardware. |
| **PO6** | Sell | Run discovery, deliver a tailored 20-minute demo, recover from demo failures and handle common objections accurately. |
| **PO7** | Self-sufficiency | Find answers in the official documentation, troubleshoot common problems and keep a demo environment healthy. |

Every lab starts with its own **learning objectives** (e.g. `L06-2`). Each objective names the outcome it supports and how it's checked: a ✅ checkpoint, an exercise, or a tagged *Check yourself* question. The full mapping is in [`reference/learning-objectives.md`](reference/learning-objectives.md).

> [!IMPORTANT]
> **How these labs are designed**
> 1. **Web portal first.** If something can be done in the Landscape web portal, the labs do it there. Customers buy Landscape to *avoid* SSH-ing into hundreds of machines, so your demo should show that too.
> 2. **No magic scripts.** You type every command yourself, and each one comes with a plain-English explanation. When you paste a script into Landscape, it's short and every line is commented. You should always be able to explain what just happened.
> 3. **Sales relevance before depth.** Each lab says *why it matters on a call*. Topics that matter less for sales calls are still covered briefly, with a **📚 Read more** pointer for when a customer asks.

---

## Who this is for

| You are... | You'll be fine because... |
|---|---|
| New to Linux | [Lab 01](labs/01-linux-survival-kit.md) teaches the ~15 commands and ideas you need, in a throwaway virtual machine you can't break. |
| New to Landscape | Labs 02 to 12 build up one capability at a time, using the same demo estate. |
| New to Canonical sales | Every lab ends with **🎤 Say it on the call** talk tracks, and [Lab 13](labs/13-your-first-demo.md) puts it all together. |

## What you need

- A laptop (macOS, Windows 10/11 or Ubuntu) with **16 GB RAM and 40 GB free disk** (recommended). With 8 GB RAM, take the lighter path described in [Lab 00](labs/00-start-here.md).
- Admin rights to install one app ([Multipass](https://canonical.com/multipass), Canonical's free tool for creating Ubuntu virtual machines).
- A free **Ubuntu One** account and a free **Ubuntu Pro** personal token (covers 5 machines). Lab 00 walks you through both.
- About **10 to 12 hours** in total. Spread it over a week if you like; each lab stands on its own.

## The lab map

| # | Lab | What you'll be able to do | Outcomes | Time |
|---|---|---|---|---|
| 00 | [Start here](labs/00-start-here.md) | Set up accounts and tools, and learn how to read these labs | PO1, PO2, PO3 | 30 min |
| 01 | [Linux survival kit](labs/01-linux-survival-kit.md) | Use a terminal, `sudo`, packages, snaps, and understand what a "kernel" or a "CVE" is | PO1 | 60 min |
| 02 | [Landscape: the big picture](labs/02-landscape-big-picture.md) | Explain what Landscape is, the 3 editions, and how licensing works with Ubuntu Pro | PO2, PO6 | 45 min |
| 03 | [Build your demo server](labs/03-build-your-demo-server.md) | Install a self-hosted Landscape server, understanding every step | PO1, PO2, PO3 | 60 min |
| 04 | [Enroll your fleet](labs/04-enroll-your-fleet.md) | Register machines, accept them in the portal, and use registration keys | PO1, PO2, PO3, PO4, PO6, PO7 | 60 min |
| 05 | [Portal tour: see and organize the estate](labs/05-portal-tour-and-organizing.md) | Give the "single pane of glass" opener: inventory, tags, search, alerts, Ubuntu Pro from the UI | PO2, PO4, PO6 | 45 min |
| 06 | [Security patching, CVEs and Livepatch](labs/06-security-patching-and-cves.md) | Run the #1 demo: find a vulnerable machine and patch it from the browser | PO1, PO4, PO6 | 60 min |
| 07 | [Remote scripts and annotations](labs/07-remote-scripts-and-annotations.md) | Run a script on the whole fleet, read its output, and schedule scripts | PO4, PO6 | 45 min |
| 08 | [Packages, snaps and profiles](labs/08-packages-snaps-and-profiles.md) | Install or block software fleet-wide, and set maintenance windows | PO4, PO6 | 60 min |
| 09 | [Compliance: CIS and DISA-STIG with USG](labs/09-compliance-usg-cis-stig.md) | Audit machines against a hardening benchmark and download an audit report | PO1, PO4, PO6 | 60 min |
| 10 | [RBAC and access control](labs/10-rbac-and-access-control.md) | Show least-privilege, multi-team administration | PO2, PO4 | 30 min |
| 11 | [Sovereign, airgapped and repository mirroring](labs/11-sovereign-airgapped-and-repos.md) | Tell the "Sovereign AI / disconnected" story and explain mirrors and snapshots | PO5, PO6 | 45 min |
| 12 | [Beyond servers: desktops, WSL, IoT and AI hardware](labs/12-beyond-servers-wsl-iot-ai.md) | Position Landscape for Windows+WSL, Ubuntu Core devices and NVIDIA DGX Spark | PO4, PO5, PO6 | 30 min |
| 13 | [Your first demo](labs/13-your-first-demo.md) | Rehearse a 20-minute demo with discovery questions and objection handling | PO4, PO6, PO7 | 60 min |
| 14 | [Reset and teardown](labs/14-reset-and-teardown.md) | Reset the demo between calls, or delete everything | PO4, PO6, PO7 | 15 min |

## Reference shelf

- [Learning objectives and coverage](reference/learning-objectives.md): every objective, the outcome it supports, and how it's checked
- [Glossary](reference/glossary.md): every term used in these labs, in plain English
- [Linux cheat sheet](reference/linux-cheat-sheet.md): the commands from Lab 01 on one page
- [Web portal click paths](reference/web-portal-click-paths.md): "where is X in the UI?" for live demos
- [Talk tracks and objection handling](reference/talk-tracks-and-objections.md)
- [Read-more map](reference/read-more-map.md): where to look in the official docs when a customer goes deep
- [Troubleshooting](reference/troubleshooting.md): fixes for the problems new joiners hit most often
- [`scripts/landscape/`](scripts/landscape/): the commented scripts you paste into the Landscape web portal during the labs

## Source of truth

The labs are based on the **official Landscape documentation** (Canonical, 2026; the "latest" edition, which covers Landscape 26.04 LTS and 26.10). Each lab cites the doc section it relies on. Product UIs change: if a button has moved, trust the official docs and open a PR here to fix the lab.

- Official docs: <https://canonical-landscape-documentation.readthedocs-hosted.com/en/latest/>
- Product page: <https://ubuntu.com/landscape>
- Ubuntu Pro: <https://ubuntu.com/pro>
