# Lab 08: Packages, snaps and profiles

**Time:** 60 minutes · **Web portal** 🖱️

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L08-1 | **Install** and **hold** packages on one machine and across many. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoints, Parts A and B · Check yourself Q2 |
| L08-2 | **Manage** snaps (install, hold, channels) from the web portal. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part C · Check yourself Q5 |
| L08-3 | **Create** a package profile and **explain** how tags turn profiles into policy. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part D · Check yourself Q1, Q3 |
| L08-4 | **Create** a security-only upgrade profile with a maintenance window. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part E · Check yourself Q6 |
| L08-5 | **Explain** reboot and removal profiles and their business value. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q4 |
| L08-6 | **Choose** the right profile type for a customer requirement. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q7 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

Lab 06 was *reactive*: find a problem and fix it. This lab is about **policy**: telling Landscape *how things should be* and letting it keep them that way.
- *"Every production server must have X and must never have Y."* → **package profile**
- *"Security updates go in every night between 02:00 and 04:00, no exceptions."* → **upgrade profile**
- *"Reboots happen Sunday morning, staggered so the cluster stays up."* → **reboot profile**
- *"Decommissioned machines shouldn't eat license seats."* → **removal profile**

🧠 **Key idea: profiles + tags = policy at scale.** A profile is attached to an **access group** and, optionally, to **tags**. Any machine with a matching tag gets the profile **automatically**, including machines that join next year.

---

## Part A: Install and hold a package on one machine

1. **Instances → web-01 → Packages**. Search for `nginx` (a popular web server). It isn't installed yet.
2. Select **nginx → Install**, confirm, and watch **Activities**.
3. Verify from your laptop:

```bash
multipass exec web-01 -- systemctl is-active nginx
```

*What this does:* asks web-01 whether the `nginx` service is running. It should print `active`.

4. Back in **web-01 → Packages**, select **nginx → Hold**.

🧠 **Linux moment: what's a "hold"?** A held package is **pinned at its current version**: automatic and fleet-wide upgrades skip it until you **unhold** it. Admins hold packages when an application is certified against one exact version (common with databases and in regulated environments).

✅ **Checkpoint:** nginx shows as installed **and held** on web-01.

---

## Part B: Manage packages across the fleet

> Requires Landscape **26.10** or later (bulk Deb management).

1. **Instances** → tick **all three** machines → **Deb management → Install**.
2. Search for `htop` (an interactive system monitor), add it, click **Next**, review the summary and confirm.
3. Watch **Activities**: there's one activity per machine.

✅ **Checkpoint:** `htop` appears in the **Packages** tab of all three machines.

> [!NOTE]
> Bulk actions work on up to **100 instances** and **500 packages** per action. The side panel only offers packages the operation applies to. For example, **Upgrade** only lists packages that have upgrades available on the selected machines.

---

## Part C: Snaps

1. **Instances → db-01 → Snaps**. Look at what's installed (e.g. `core24`, `snapd`) and the **channel** each snap tracks.
2. **Instances** → tick **web-01** and **db-01** → choose the **snap install** action → search for `hello-world` → install it from the `latest/stable` channel.
3. On **web-01 → Snaps**, select `hello-world` → **Hold**.

🧠 **Linux moment: channels.** Snaps follow a **channel**, like `latest/stable`, `latest/edge` or `1.2/stable`, and refresh automatically within it. In Landscape you can **switch channels**, **pin a revision** or **hold** a snap so it doesn't refresh. Enterprises want that control. Landscape will also warn you before installing a snap that uses **classic confinement** (meaning it isn't sandboxed).

✅ **Checkpoint:** `hello-world` is installed on both machines and held on web-01.

🎤 **Say it on the call:** *"Debs and snaps, managed in the same place, with the same audit trail. You decide when snaps refresh. They don't decide for you."*

---

## Part D: Package profile, a "production baseline"

You'll create a policy: **every production machine must have `fail2ban` (brute-force protection) and must never have `telnetd` (an insecure remote-login server).**

1. **Profiles → Package profiles → Add package profile**.
2. **Name:** `production-baseline`. **Access group:** `global`.
3. Add the constraints **manually**:
   - **Depends on** `fail2ban`
   - **Conflicts with** `telnetd`
4. **Association:** **Tag(s)** → `production`.
5. Save.
6. Watch **Activities**: Landscape creates activities to bring **web-01** and **db-01** (tagged `production`) into compliance by installing `fail2ban`. **legacy-01** (tagged `staging`) is left alone.

✅ **Checkpoint:** a few minutes later, `fail2ban` is installed on web-01 and db-01 but **not** on legacy-01.

### Test the guard rail

```bash
multipass exec db-01 -- sudo apt-get install -y telnetd
```

*What this does:* installs the forbidden package directly on db-01, bypassing Landscape, the way a careless admin might.

Package profiles are **re-evaluated periodically**. After the next evaluation, Landscape flags db-01 as **non-compliant** (the *package profiles* alert) and creates an activity to **remove** `telnetd`. Check **db-01 → Activities**.

> [!NOTE]
> Want to stop a package from being installed in the first place, not just remove it afterwards? The docs describe combining the profile with a remote script that adds an APT "pin" with negative priority (*Web portal > Manage packages > Prevent a package from being installed*).

🧠 **Linux moment: why fail2ban is a good Ubuntu Pro story.** `fail2ban` lives in the **universe** repository. Without Ubuntu Pro, universe packages only get community security support. With Pro (**ESM Apps**), Canonical provides security fixes for them for up to 10 years. 🎤 *"Most of your stack likely comes from universe. Is it covered?"*

---

## Part E: Upgrade profile, security patches on autopilot

1. **Profiles → Upgrade profiles → Add upgrade profile**.
2. Fill in:
   - **Name:** `nightly-security`
   - **Upgrade type:** **security upgrades only**
   - **Schedule:** every day, at `02:00` (UTC)
   - **Randomize delivery** over a window, e.g. 60 minutes, so not every machine upgrades at the same second
   - **Access group:** `global`. **Association:** **Tag(s)** → `production`
3. Save.

✅ **Checkpoint:** the profile is listed with its schedule. Tomorrow morning, check **Activities** for the upgrades it ran overnight.

🎤 **Say it on the call:** *"Security fixes go in every night, inside your maintenance window, only on the machines you tagged, staggered so you don't hammer your network. If a run misses its window, it's skipped rather than run at a bad time."*

---

## Part F: Reboot profile and removal profile

### Reboot profile (Landscape 25.04 and later)

1. **Profiles → Reboot profiles → Add reboot profile**.
2. **Name:** `sunday-reboots` · **Days:** Sunday · **Time:** `03:00` (UTC) · **Expires after:** e.g. 2 hours · **Randomize delivery:** Yes · **Association:** **Tag(s)** → `production`.
3. Save. The list shows the **next scheduled reboot**.

🎤 *"Patches that need a reboot actually get applied, at a time you choose, staggered so the cluster stays up."*

### Removal profile

1. **Profiles → Removal profiles → Add removal profile**.
2. **Name:** `cleanup-30-days` · **Days without exchange:** `30` · **Access group:** `global`.
3. Save.

Machines that haven't reported for 30 days are removed from Landscape automatically, which **frees their license seats**. (This only removes the machine from Landscape's management. It doesn't touch the machine itself.)

---

## Part G: Release upgrades at scale (concept)

Since 26.04 LTS, you can trigger **Ubuntu release upgrades** (for example 22.04 → 24.04) for many machines from the web portal. It's a big deal for customers facing end-of-standard-support deadlines. Don't run it on legacy-01 now (it takes a long time), but know it exists.

🎤 *"Moving a fleet to the next LTS is a project, not a click. But the click part, scheduling and tracking the upgrades, is in Landscape."*

---

## The profile family (cheat sheet)

| Profile | Does | Availability |
|---|---|---|
| **Package** | Must-have / must-not-have packages; re-evaluated periodically | All |
| **Upgrade** | Scheduled upgrades: all or security-only | All |
| **Reboot** | Scheduled, staggered reboots | 25.04+ |
| **Removal** | Remove machines that stopped reporting | All |
| **Script** | Run scripts post-enrollment, on a date, or on a schedule | Self-hosted 25.04+ |
| **USG** | CIS / DISA-STIG audit and fix (Lab 09) | Self-hosted 25.04+ |
| **Repository** | Which APT sources and pockets machines use (Lab 11) | Self-hosted |
| **WSL** | Which Ubuntu WSL instances Windows machines must have (Lab 12) | — |

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. You add the tag <code>production</code> to legacy-01. What happens? <em>(L08-3)</em></summary>

Every profile associated with the `production` tag (in the same access group) now applies to legacy-01: the package profile installs fail2ban, and the upgrade and reboot profiles start including it.
</details>

<details>
<summary>2. What does holding a package do? <em>(L08-1)</em></summary>

It pins the package at its current version, so automatic and bulk upgrades skip it until it's unheld. It can still be upgraded manually.
</details>

<details>
<summary>3. Why does fail2ban make a good Ubuntu Pro talking point? <em>(L08-3)</em></summary>

It's in the universe repository. Security fixes for universe packages come from Canonical only with Ubuntu Pro (ESM Apps).
</details>

<details>
<summary>4. What does a removal profile do for licensing? <em>(L08-5)</em></summary>

It automatically removes machines that haven't contacted Landscape for N days, which releases the license seats they held.
</details>

<details>
<summary>5. What's a snap channel, and what are your options if a customer doesn't want a snap to refresh automatically? <em>(L08-2)</em></summary>

A channel (e.g. `latest/stable`) is the release stream a snap tracks and refreshes from. In Landscape you can hold the snap, pin a specific revision or switch channels.
</details>

<details>
<summary>6. A customer wants security updates installed automatically every night, but only on production. What do you set up? <em>(L08-4)</em></summary>

An upgrade profile set to security upgrades only, scheduled daily in their maintenance window (with randomized delivery), associated with the `production` tag.
</details>

<details>
<summary>7. Which profile type fits each request: (a) staggered weekly reboots, (b) run a baseline script on every new machine, (c) audit against CIS every week? <em>(L08-6)</em></summary>

(a) Reboot profile, (b) script profile with a post-enrollment trigger, (c) USG profile with a recurring schedule.
</details>

## 📚 Read more

- Official docs → *Web portal > Manage packages and snaps* and *Use profiles*
- Official docs → *Reference > Terms > Profiles* (definitions of every profile type)
- Official docs → *Explanation > Package reporting* (how Landscape tracks package state)

---

**Next:** [Lab 09: Compliance, CIS and DISA-STIG with USG →](09-compliance-usg-cis-stig.md)
