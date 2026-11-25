# Lab 07: Remote scripts and annotations

**Time:** 45 minutes · **Web portal** 🖱️ · Scripts are in [`scripts/landscape/`](../scripts/landscape/)

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L07-1 | **Add** a script, **run** it on selected machines and **read** its output in Activities. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoints, Parts A and B · Check yourself Q5 |
| L07-2 | **Explain** the safeguards around remote script execution. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q1 |
| L07-3 | **Create** annotations with a script, **search** by annotation and **distinguish** annotations from tags. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part C · Check yourself Q2 |
| L07-4 | **Fix** one specific CVE across machines with `pro fix` run through Landscape. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part D · Check yourself Q6 |
| L07-5 | **Schedule** scripts with script profiles, and **explain** archiving vs. redacting. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part E · Check yourself Q3, Q4 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

Every operations team has a moment like *"we need to check or change X on all 400 machines, now"*. Without Landscape, that means SSH loops, shared root keys and no audit trail. With Landscape, you pick the machines, pick a script and click **Run**. Every run is an **activity**: who ran it, where, when, and what it printed.

It also matters for the **AI-hardware and edge story** (Lab 12): NVIDIA publishes reference scripts for DGX Spark that are designed to be run through Landscape's remote script execution.

> [!IMPORTANT]
> Remote scripts are powerful. A script running as `root` can do *anything*. That's exactly why the lab scripts are short and commented, and why Landscape gates script execution behind a client-side opt-in (`ScriptExecution`), an allow-list of users (`script_users`) and RBAC permissions (Lab 10).

---

## Part A: Your first remote script

### A1. Add the script

1. Open [`scripts/landscape/01-hello-world.sh`](../scripts/landscape/01-hello-world.sh) and **read every comment**.
2. 🖱️ **Scripts** (sidebar) → **Add script**.
3. **Title:** `Hello World`. Paste the script into the editor. **Access group:** `global`. Click **Add script**.

### A2. Run it on one machine

1. **Instances** → tick **web-01** → **Operations → Run script**.
2. In the side panel, choose **Hello World**, **Run as user:** `ubuntu`, and leave the default time limit. (The **time limit** is how long the script may run before Landscape stops it.)
3. Click **Run**.

### A3. Read the result

1. **Activities** → click the newest *script execution* activity (or **Instances → web-01 → Activities**).
2. Watch the status move from **Queued** to **In progress** to **Succeeded**, then open it to read the **output**: `Created /home/ubuntu/hello-from-landscape.txt on web-01`.

✅ **Checkpoint:** confirm it on the machine itself (and practise the `multipass exec` pattern):

```bash
multipass exec web-01 -- cat /home/ubuntu/hello-from-landscape.txt
```

*What this does:* runs `cat` inside web-01 to print the file the script created.

🧠 **Linux moment: why "Queued" first?**
Landscape doesn't push commands into machines. The client **checks in**, finds the queued activity, runs it locally and reports back. That's why there's a short delay, and why it works for machines behind NAT or firewalls that only allow outbound HTTPS.

---

## Part B: A safe, read-only fleet report (great for live demos)

1. Read [`02-fleet-health-report.sh`](../scripts/landscape/02-fleet-health-report.sh). It **only reads** information.
2. Add it as a script titled `Fleet health report`.
3. **Instances** → tick **all three** machines → **Operations → Run script** → `Fleet health report` → run as `ubuntu`.
4. In **Activities**, open each result and compare the OS, kernel, disk and reboot status across machines.

✅ **Checkpoint:** you see three separate results, one per machine. legacy-01 shows Ubuntu 22.04.

🎤 **Say it on the call:** *"I just ran the same check on every machine I selected. It could be three or three thousand. Each result is stored per machine, and nobody needed SSH access or a root password."*

---

## Part C: Annotations, so machines describe themselves

**Annotations** are key/value facts that a machine reports about itself, e.g. `owner-team = payments` or `rack = B12`. Under the hood, each file in `/var/lib/landscape/client/annotations.d/` on the client becomes one annotation: the **file name is the key** and the **file contents are the value**.

1. Read [`03-set-annotations.sh`](../scripts/landscape/03-set-annotations.sh). Notice the `case` block that picks a team from the hostname.
2. Add it as `Set annotations` and run it on **all three** machines, **as `root`** (the folder belongs to the system).
3. Wait for **Succeeded**, then open **web-01 → Info**. Your annotations appear there (it may take a few minutes for the client to report them).
4. Search the Instances list:

| Search | Finds |
|---|---|
| `annotation:owner-team` | Every machine that has an `owner-team` annotation |
| `annotation:owner-team:finance-apps` | Only legacy-01 |

✅ **Checkpoint:** `annotation:owner-team:data` returns only db-01.

> [!NOTE]
> Annotation keys and values are **case-sensitive**, and the search is a simple text match. Searching `attached` would also match `unattached`, so choose distinct names.

🎤 **Say it on the call:** *"Annotations let each machine report business context, like owner, cost centre or application, which you can then search, save and target. Tags are labels **you** put on machines. Annotations are facts **the machines** report."*

---

## Part D: Fix one specific CVE across machines

Your security team says: *"Fix **CVE-XXXX** on these machines, today, and nothing else."*

1. Make web-01 vulnerable again by repeating [Lab 06, Part B](06-security-patching-and-cves.md#part-b-create-a-vulnerability-on-purpose-demo-prep).
2. Open the USN for `less` (Lab 06, Part C) and copy **one CVE ID** from it.
3. Open [`04-pro-fix-cve.sh`](../scripts/landscape/04-pro-fix-cve.sh) and **replace `CVE-YYYY-NNNN`** with your CVE ID. Add it as `Pro fix CVE`.
4. Run it on **web-01** and **db-01** as **`root`**.
5. Read the output in **Activities**:
   - on **web-01**: `pro fix` upgrades `less` and reports the CVE as **resolved**
   - on **db-01**: it reports the CVE is **already resolved** (or doesn't affect the machine), so nothing changes

✅ **Checkpoint:** web-01 disappears from the **Security upgrades** list after its next check-in.

🎤 **Say it on the call:** *"Landscape plus the Ubuntu Pro client can surgically fix one CVE without touching anything else. That's ideal for testing a fix on a canary group before a wider rollout."*

---

## Part E: Schedule it with script profiles (self-hosted 25.04 and later)

A **script profile** runs a script automatically, triggered by:
- **Post enrollment:** every newly registered machine runs it (e.g. baseline setup or annotations)
- **On a date:** once, at a set UTC time
- **Recurring:** on a cron-style schedule

1. **Profiles → Script profiles → Add script profile**.
2. Fill in:
   - **Name:** `Daily health report`
   - **Script:** `Fleet health report`
   - **Run as user:** `ubuntu`
   - **Time limit:** `300`
   - **Trigger:** **Recurring**, starting today, with the cron schedule `0 6 * * *`

     🧠 *Cron in 10 seconds:* the five fields are **minute hour day-of-month month day-of-week**. `0 6 * * *` means "at 06:00 every day". (Times are UTC.)
   - **Association:** **Tag(s)** → `production`
3. Save, then create a second profile: **Name** `Annotate new machines`, **Script** `Set annotations`, run as `root`, **Trigger:** **Post Enrollment**, **Association:** **All instances**.

✅ **Checkpoint:** both profiles appear under **Profiles → Script profiles**, the recurring one with its next run time.

> [!TIP]
> Scheduled runs can start a little later than the selected time. When you no longer want a profile, **archive** it: it stops running but stays on record. Scripts themselves can be **archived** (stop future runs, keep the record) or **redacted** (permanently remove the contents but keep a record of who did it and when). Both actions are irreversible.

---

## Bonus concepts for the call (no hands-on needed)

- **Any language:** scripts can be Bash, Python and so on, as long as the interpreter is installed on the client.
- **Attachments:** a script can carry files (e.g. a config file). On the client, Landscape puts them in a temporary folder and exposes its path through the `LANDSCAPE_ATTACHMENTS` environment variable.
- **API:** everything you clicked can also be done with the **REST API**, for CI/CD pipelines, ITSM integrations, or AI agents and automation that drive operations programmatically.
- **Ubuntu Core:** the Landscape Client snap also supports remote scripts, with some differences (see docs).
- **Canonical's script library:** <https://github.com/canonical/landscape-scripts>

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. Name three safeguards around remote script execution. <em>(L07-2)</em></summary>

(1) The `ScriptExecution` plugin is off by default on clients. (2) `script_users` restricts which local users scripts can run as. (3) RBAC roles control which admins can run scripts, and on which access groups. Plus, every run is recorded as an activity with its output.
</details>

<details>
<summary>2. What's the difference between a tag and an annotation? <em>(L07-3)</em></summary>

A tag is a label an administrator applies in Landscape. An annotation is a key/value pair the machine reports about itself, created by files in `/var/lib/landscape/client/annotations.d/`.
</details>

<details>
<summary>3. What are the three script profile triggers? <em>(L07-5)</em></summary>

Post enrollment, on a date, and recurring (cron schedule).
</details>

<details>
<summary>4. What's the difference between archiving and redacting a script? <em>(L07-5)</em></summary>

Archiving stops future runs but keeps the script's record and contents. Redacting permanently removes the contents and attachments but keeps a record of who redacted it and when.
</details>

<details>
<summary>5. Why does a script activity show "Queued" before it runs? <em>(L07-1)</em></summary>

Landscape doesn't push commands into machines. The activity waits until the client next checks in, then the client collects it, runs it locally and reports back. That's also why it works behind firewalls that only allow outbound HTTPS.
</details>

<details>
<summary>6. Your security team wants one CVE fixed on 50 machines and nothing else upgraded. How do you do it in Landscape? <em>(L07-4)</em></summary>

Add a script that runs `pro fix CVE-…` (as root), then run it on those machines. Each machine gets its own activity with the output showing whether the CVE is resolved. The machines need Ubuntu Pro attached.
</details>

## 📚 Read more

- Official docs → *Web portal > Use remote script execution*, *Use annotations*, *Use profiles > Script profiles*
- Official docs → *Explanation > Remote script execution* and *Activities* (states and life cycle)
- Official docs → *How to use remote script execution with the Landscape Client snap*

---

**Next:** [Lab 08: Packages, snaps and profiles →](08-packages-snaps-and-profiles.md)
