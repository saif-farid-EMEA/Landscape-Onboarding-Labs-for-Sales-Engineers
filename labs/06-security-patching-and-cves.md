# Lab 06: Security patching, CVEs and Livepatch

**Time:** 60 minutes · **Mostly web portal** 🖱️ (one short terminal step)

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L06-1 | **Identify** every machine with outstanding security updates, in at least two ways. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part A · Check yourself Q5 |
| L06-2 | **Interpret** a USN (the CVEs it fixes, priority, affected releases) and **explain** where Landscape's security data comes from. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO1](../reference/learning-objectives.md#po1-linux-fluency) | Checkpoint, Part A · Check yourself Q1, Q6 |
| L06-3 | **Apply** security fixes to one machine and to many, and **explain** the difference between the bulk options. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoints, Parts D and E · Check yourself Q2 |
| L06-4 | **Interpret** the Kernel tab's Livepatch statuses. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Check yourself Q3 |
| L06-5 | **Deliver** the 5-minute security demo, including how to prove a fix to an auditor. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO6](../reference/learning-objectives.md#po6-sell) | Practice table · Check yourself Q4 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

This is **the** Landscape demo. Almost every customer has some version of: *"A critical CVE drops. How fast can we find every affected machine, patch it and prove it's done?"* Attackers increasingly use automation, and now AI, to turn new CVEs into working exploits faster, so the window between *disclosure* and *exploitation* keeps shrinking. Your demo shows that window closing with a few clicks:

**Discover → understand → fix → verify → automate.**

---

## Part A: Discover. Which machines are exposed?

🖱️ **In the web portal**

1. **Overview** → in the **Upgrades** section, click the instances link next to **Security**.
   *Or:* **Instances** → **Status** filter → **Security upgrades**.
   *Or:* search `alert:security-upgrades`.
2. Open **legacy-01** → **Security issues** tab.

You'll most likely see several outstanding issues already. Older releases and freshly attached ESM coverage usually reveal some. Each row references a **USN**.

✅ **Checkpoint:** you can name one USN that affects legacy-01.

> [!NOTE]
> **No security issues showing?** Lucky you, but you need some for the demo. Do **Part B** to create one on purpose.

---

## Part B: Create a vulnerability on purpose (demo prep)

To make the demo predictable, you'll **downgrade** a package on `web-01` to an older version that's missing security fixes. We'll use **`less`** (the text viewer from Lab 03), which has had security fixes since Ubuntu 24.04 was released.

> [!WARNING]
> Never do this on a real system. You're deliberately making web-01 vulnerable so you have something to fix in the demo.

### Option 1: in the web portal (preferred)

1. **Instances** → **web-01** → **Packages** tab → search `less`.
2. Select **less** → **Downgrade**.
3. Pick the **oldest** version offered (the one that originally shipped with 24.04) and confirm.
4. Watch the activity under **Activities** until it shows **Succeeded**.

### Option 2: in the terminal (if Downgrade isn't offered)

⌨️ **In the terminal** (on your laptop)

```bash
multipass exec web-01 -- apt-cache policy less
```

*What this does:* lists every version of `less` that APT knows about. The `***` marks the installed version. The **oldest** version listed (usually from the `noble/main` release pocket) is the one you want. Copy its version string.

```bash
multipass exec web-01 -- sudo apt-get install -y --allow-downgrades less=<OLD_VERSION>
```

*What this does:* installs that exact older version. `--allow-downgrades` is needed because APT normally refuses to go backwards.

### Wait for Landscape to notice

The client reports package changes on its next check-in, which can take a few minutes. Then:

✅ **Checkpoint:** web-01 now appears under **Security upgrades**, and its **Security issues** tab lists a USN for `less`.

> [!TIP]
> Do Part B **before** every demo (it takes 2 minutes), and Lab 14 includes it in the pre-demo reset checklist.

---

## Part C: Understand. Read a USN like a security engineer

1. On web-01's **Security issues** tab, note the USN number for `less` (e.g. `USN-XXXX-1`).
2. In a new browser tab, open `https://ubuntu.com/security/notices/USN-XXXX-1` (with your number).
3. On that page, find:
   - the **CVE IDs** it fixes
   - the **priority/severity**
   - the **affected Ubuntu releases** and the **fixed package versions**
4. Click one CVE to open its page on `ubuntu.com/security`. Notice that it shows the status for **every** Ubuntu release, including releases covered only by **Ubuntu Pro / ESM**.

🎤 **Say it on the call:** *"Landscape doesn't just say 'an update exists'. It ties the update to the Ubuntu Security Notice and the CVEs behind it, straight from Canonical's security team, the people who build the fixes. Your security team gets the CVE, your ops team gets the fix, and they're looking at the same data."*

---

## Part D: Fix. Patch one machine from the browser

1. **Instances** → **web-01** → **Security issues**.
2. Select the `less` issue (or **all** issues) → **Upgrade** → confirm.
3. Go to **Activities** and watch: **Queued → In progress → Succeeded**. Click the activity to see its details: who requested it, when, and the result.

✅ **Checkpoint:** after the next check-in, web-01 no longer appears under **Security upgrades**.

🧠 **Linux moment: what just happened on web-01?**
Landscape queued a package-change activity. On its next check-in, web-01's client picked it up and ran the APT upgrade for `less` locally, as root, just like `sudo apt install --only-upgrade less`. Then it reported the result back. **Nobody SSH'd anywhere.**

---

## Part E: Fix at fleet scale

### E1. Patch several machines at once

1. **Instances** → tick **legacy-01** and **db-01**.
2. Choose one:
   - **Upgrade** upgrades **all** packages on the selected machines (security *and* regular updates), or
   - **Deb management → Upgrade** (Landscape 26.10 and later) lets you choose **which** packages to upgrade across up to 100 machines and shows a summary before running.
3. Confirm, and watch **Activities**.

✅ **Checkpoint:** after a few minutes, the security-upgrades count on **Overview** goes down, ideally to 0.

### E2. Fix one specific CVE everywhere (preview)

Sometimes the security team says: *"Fix **this** CVE on **these** machines, and nothing else."* Landscape does that with a remote script that runs Ubuntu Pro's `pro fix` command. You'll do it in [Lab 07](07-remote-scripts-and-annotations.md#part-d-fix-one-specific-cve-across-machines).

### E3. Make it automatic

Doing it by hand is good for the demo. Customers want it **automatic**: an **upgrade profile** that installs **security-only** updates every night in a maintenance window. You'll build that in [Lab 08](08-packages-snaps-and-profiles.md).

---

## Part F: Verify. Reboots and Livepatch

### F1. Reboot required?

1. Search `needs:reboot`.
2. If any machine shows up (common after library or kernel updates), open it and use **Restart instance** (or select several → **Restart**).

### F2. The Livepatch story

1. **Instances** → **web-01** → **Kernel** tab.
2. Look at:
   - **Current kernel version** (with Upgrade/Downgrade kernel buttons)
   - **Status**: one of *Fully patched*, *Kernel upgrade available*, *Restart required*, *Livepatch disabled*, *End of life*, or *Waiting for status*
   - **Livepatch coverage**: the date until which this kernel is supported by Livepatch
   - **Patches discovered since last restart**: kernel fixes applied *live*

> [!NOTE]
> In a lab VM you may see *Livepatch disabled* or *Waiting for status*. Livepatch was enabled when you attached Pro, but it depends on the kernel and the virtualization platform. That's fine: the important thing is knowing what each status **means**, so you can talk to it. To check from the VM itself: `multipass exec web-01 -- sudo canonical-livepatch status`.

🎤 **Say it on the call:** *"Kernel fixes normally mean reboots, and reboots mean maintenance windows, change boards and weekend work. Livepatch applies high and critical kernel fixes to the running kernel. Landscape shows you, machine by machine, whether it's fully patched and how long its kernel stays covered. You reboot on **your** schedule, not the attacker's."*

---

## The 5-minute security demo (practice this out loud)

![The security demo in five steps: Discover (Overview security upgrades count), Understand (Security issues, USN, CVEs), Fix (select and Upgrade, or one CVE with pro fix), Verify (Activities succeeded, Kernel tab Livepatch status), Automate (upgrade profile, security-only, nightly). Powered by Ubuntu Security Notices; Livepatch applies high and critical kernel fixes without a reboot.](../diagrams/security-demo-flow.svg)

<sub>🖼️ Reuse it in your slides: [PNG](../diagrams/png/security-demo-flow.png) · [SVG](../diagrams/security-demo-flow.svg) · [how these diagrams are designed](../diagrams/README.md)</sub>

| Step | Click path | Say |
|---|---|---|
| 1. Discover | Overview → **Security** upgrades count | "Here's our exposure right now." |
| 2. Drill down | web-01 → **Security issues** → USN | "Here's exactly which flaw, and the CVEs behind it." |
| 3. Context | Open the USN page | "Canonical's security team publishes this. It's the same data your security team uses." |
| 4. Fix | Select → **Upgrade** → **Activities** | "One click, fully recorded: who, what, when, result." |
| 5. Verify | Security count drops; **Kernel** tab | "Verified, and the kernel is covered by Livepatch, so no reboot tonight." |
| 6. Automate | (tease Lab 08) Upgrade profile | "And tonight this happens on its own, security-only, in your maintenance window." |

---

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. Where does Landscape get the information that an update is a security update? <em>(L06-2)</em></summary>

From the Ubuntu Security Notices (USN) database, which Landscape Server downloads from Canonical (usn.ubuntu.com). That's why, without that access, security updates can't be told apart from regular ones.
</details>

<details>
<summary>2. If you select several machines and click Upgrade, are only security updates installed? <em>(L06-3)</em></summary>

No. That upgrades all packages. For security-only, upgrade from each instance's Security issues tab, choose specific packages with Deb management (26.10+), or use an upgrade profile set to security-only.
</details>

<details>
<summary>3. What does the Livepatch status "Restart required" mean? <em>(L06-4)</em></summary>

A new kernel has been installed, and the machine needs a restart to start using it.
</details>

<details>
<summary>4. A customer asks: "How do I prove to an auditor that the fix was applied?" <em>(L06-5)</em></summary>

Every fix is an activity with its creator, timestamps and result; the machine's Security issues tab and Packages tab show the current state; and USG audits (Lab 09) and compliance reports give point-in-time evidence.
</details>

<details>
<summary>5. Name two ways to list the machines that need security updates. <em>(L06-1)</em></summary>

Any two of: the Security link in Overview's Upgrades section; Instances → Status → Security upgrades; searching `alert:security-upgrades`.
</details>

<details>
<summary>6. You open a USN page. Which three things do you look for to brief a customer? <em>(L06-2)</em></summary>

The CVE IDs it fixes, their priority or severity, and the affected Ubuntu releases with the fixed package versions.
</details>

## 📚 Read more

- Official docs → *How to apply security patches and upgrades* (including *Apply an individual CVE or USN fix*)
- Official docs → *Web portal > Manage Livepatch and kernel updates*
- Livepatch docs: <https://ubuntu.com/security/livepatch/docs>
- Ubuntu Security Notices: <https://ubuntu.com/security/notices> · CVE tracker: <https://ubuntu.com/security/cves>
- Pro Client, fixing a specific CVE: <https://documentation.ubuntu.com/pro-client/en/latest/howtoguides/fix_how_to_resolve_given_cve/>

---

**Next:** [Lab 07: Remote scripts and annotations →](07-remote-scripts-and-annotations.md)
