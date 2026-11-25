# Lab 09: Compliance, CIS and DISA-STIG with USG

**Time:** 60 minutes (some of it waiting) · **Web portal** 🖱️ · **Self-hosted Landscape 25.04 or later**

## 🎯 Why this matters on a call

Regulated customers (banks, governments, defence, healthcare, telecoms) don't just need machines to *be* secure. They need to **prove** it, repeatedly, to auditors. Frameworks such as **CIS Benchmarks** and **DISA-STIG** define hundreds of hardening rules, and regulations such as **NIS2** and **DORA** in the EU, or **FedRAMP** in the US, raise the bar for evidence.

Landscape + **USG (Ubuntu Security Guide, part of Ubuntu Pro)** lets you **audit an entire fleet on a schedule, optionally fix it automatically, and download the evidence as a report.** That's continuous compliance instead of a spreadsheet exercise once a year.

🧠 **Key terms**
- **CIS Benchmark:** industry-consensus hardening rules from the Center for Internet Security, usually at **Level 1** (practical baseline) and **Level 2** (stricter).
- **DISA-STIG:** the US Defense Information Systems Agency's Security Technical Implementation Guides, required for US Department of Defense systems and widely copied elsewhere.
- **USG:** Canonical's tool that **audits** Ubuntu against these benchmarks and can **apply fixes**. It's an Ubuntu Pro service.
- **Tailoring file:** a customization of a benchmark, e.g. "we accept the risk on rule X because…". Auditors expect documented exceptions.

---

## Part A: Prepare the machines (via remote script)

USG has to be installed on each machine you want to audit. You'll install it on the two **production** machines, from the web portal.

> Prerequisites already done: Ubuntu Pro is attached (Lab 05), and the `UsgManager` client plugin is enabled (Lab 04, `include_manager_plugins`).

1. Read [`scripts/landscape/05-prepare-usg.sh`](../scripts/landscape/05-prepare-usg.sh). It has two real steps: `pro enable usg`, then `apt-get install -y usg`.
2. **Scripts → Add script** → title `Prepare USG`, paste it in, then **Add script**.
3. **Instances** → tick **web-01** and **db-01** → **Operations → Run script** → `Prepare USG`, run as **`root`**, **Time limit `600`** seconds.
4. Watch **Activities** until both show **Succeeded**. The output ends with `USG installed on …`.

✅ **Checkpoint:** both activities succeeded.

> [!NOTE]
> If you registered a machine **without** `UsgManager`, add it to the `include_manager_plugins` line in `/etc/landscape/client.conf` (e.g. `include_manager_plugins = ScriptExecution,UsgManager,ProManagement`), then restart the client with `sudo systemctl restart landscape-client`. That's the procedure in the official docs.

---

## Part B: Create a USG profile (audit only)

1. **Profiles → USG profiles → Add USG profile**.
2. Fill in:
   - **Profile name:** `cis-level1-audit`
   - **Access group:** `global`
   - **Base profile:** the **CIS Level 1 Server** benchmark (the exact label depends on the version)
   - **Mode:** **Audit** (check only, change nothing)
   - **Schedule:** **On a date**, 5 to 10 minutes from now. ⚠️ The time is in **UTC**. Search "UTC time now" in your browser if you're unsure.
   - **Association:** **Tag(s)** → `production`
3. Save.

**The three modes** (memorize these, customers always ask):

| Mode | What it does | When customers use it |
|---|---|---|
| **Audit** | Checks every rule and reports pass/fail. Changes nothing. | Always start here. |
| **Fix and audit** | Changes settings to fix failing rules, then audits | After testing on a non-production group |
| **Fix, restart, audit** | As above, plus restarts the machines so every change takes effect | In maintenance windows |

> [!TIP]
> **Recurring** schedules can run at most **once every 7 days**. That's a sensible weekly-audit cadence. Scheduled runs may start a little after the selected time.

---

## Part C: Download and read the audit report

Wait until a few minutes after the scheduled time (an audit takes a few minutes per machine).

1. **Profiles → USG profiles** → open the **⋮ (Actions)** menu on `cis-level1-audit` → **Download audit**.
2. **Audit timeframe:** **Specific date** → today. **Level of detail:** **Detailed view**.
3. When the notification *"Your requested audit is ready"* appears, click **Download audit**. You get a **CSV** file.
4. Open it in Excel, Google Sheets or LibreOffice:
   - Find the **overall pass rate** for web-01 and db-01. Out-of-the-box Ubuntu is far from 100% against CIS, and that's normal.
   - Pick **3 failing rules** and read their **severity**, **description** and **rationale**.

✅ **Checkpoint:** you can say, from the report, *"web-01 passes X% of CIS Level 1, and here's one high-severity rule it fails, and why it matters."*

🎤 **Say it on the call:** *"This report is what your auditor wants: every machine, every rule, pass or fail, with severity and rationale. Schedule it weekly and you have a compliance history, not a snapshot. And because it's the **Summary** or **Detailed** view over any **date range**, you can show the trend: we were at 62%, now we're at 97%."*

---

## Part D (optional): Let Landscape fix it

> [!WARNING]
> Fix modes change real system settings (SSH, passwords, kernel parameters, services…). In production, customers test on a small group first. Here, take a snapshot first so you can undo it.

⌨️ **Safety net** (on your laptop):

```bash
multipass stop db-01 && multipass snapshot db-01 --name before-cis-fix && multipass start db-01
```

*What this does:* stops db-01, saves a restore point called `before-cis-fix`, and starts it again.

🖱️ Then:
1. **Profiles → USG profiles** → ⋮ on `cis-level1-audit` → **Duplicate**.
2. Name it `cis-level1-fix-db`, set **Mode:** **Fix and audit**, **Association:** **Tag(s)** → `database`, and schedule it a few minutes ahead.
3. After it runs, **download the audit** for today and compare db-01's pass rate with web-01's.

✅ **Checkpoint:** db-01's pass rate is significantly higher than web-01's.

To undo: `multipass restore db-01.before-cis-fix` (the VM must be stopped first).

---

## Part E: Beyond the basics (talking points)

- **DISA-STIG** works the same way: just choose a DISA-STIG base profile.
- **Tailoring files** let customers customize a benchmark (disable rules, change values). A tailoring file **replaces** the base profile, and auditors want to see these documented exceptions.
- **FIPS:** Ubuntu Pro also provides FIPS-validated cryptographic packages. The Landscape docs cover installing Landscape itself on FIPS-compliant machines, and there's a **DISA-STIG-compliant Landscape install** guide.
- **Landscape hardens itself too:** 26.04 LTS added **security event logging** (logins, failed logins, role and permission changes, token events) for the customer's own audit trail.
- **Compliance report API** (26.10+): `GET /computers/compliance-report` returns compliance and security status for up to 10,000 instances, for SIEM and GRC integrations.

🎤 **Say it on the call:** *"Compliance stops being a once-a-year fire drill. You choose the benchmark, CIS or DISA-STIG, tailored to your exceptions. Landscape audits weekly, fixes where you allow it, and keeps the evidence."*

## ❓ Check yourself

<details>
<summary>1. What are the three USG profile modes?</summary>

Audit; Fix and audit; Fix, restart, audit.
</details>

<details>
<summary>2. What does a machine need before Landscape can audit it with USG?</summary>

Ubuntu Pro attached, USG enabled and installed (`pro enable usg`, `apt install usg`), and the `UsgManager` plugin enabled in the client configuration. The server must be self-hosted Landscape 25.04 or later.
</details>

<details>
<summary>3. A customer wants daily audits. What do you say?</summary>

Recurring USG profiles run at most once every 7 days, so weekly is the cadence. For something in between, they can schedule an extra one-off ("on a date") run or run an audit on demand from the profile's actions menu.
</details>

<details>
<summary>4. What's a tailoring file, and why do auditors care?</summary>

It's a customization of a benchmark (rules disabled or values changed). It documents the organization's accepted exceptions, which is what auditors expect to see.
</details>

## 📚 Read more

- Official docs → *How to use USG profiles* (create, download audit) and *Reference > Terms > USG profile*
- Ubuntu Security Guide docs: <https://documentation.ubuntu.com/security/docs/compliance/usg/>
- Customizing CIS with tailoring files: <https://documentation.ubuntu.com/security/docs/compliance/usg/cis-customize/>
- Official docs → *How to install Landscape in compliance with the DISA STIG*, *How to harden your Landscape deployment*

---

**Next:** [Lab 10: RBAC and access control →](10-rbac-and-access-control.md)
