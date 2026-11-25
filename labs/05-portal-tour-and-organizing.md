# Lab 05: Portal tour, see and organize the estate

**Time:** 45 minutes · **Everything in this lab happens in the web portal** 🖱️

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L05-1 | **Deliver** a 60-second estate-overview opener from the Overview page. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO6](../reference/learning-objectives.md#po6-sell) | Check yourself Q5 |
| L05-2 | **Search** for instances with query prefixes (`tag:`, `distribution:`, `alert:`…) and **save** a search. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Saved search in Part B · Check yourself Q1 |
| L05-3 | **Find** any detail about a machine (OS, kernel, hardware, packages) in under 15 seconds. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part C |
| L05-4 | **Attach** Ubuntu Pro from the web portal and **explain** what that changes on the machines. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities), [PO2](../reference/learning-objectives.md#po2-positioning) | Checkpoint, Part D · Check yourself Q3 |
| L05-5 | **Organize** machines with tags and **distinguish** tags, access groups and annotations. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Checkpoint, Part E · Check yourself Q2 |
| L05-6 | **Configure** alert subscriptions and **explain** the main alerts. | [PO4](../reference/learning-objectives.md#po4-demonstrate-core-capabilities) | Offline test in Part F · Check yourself Q4 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 🎯 Why this matters on a call

This is your **demo opener**: the "single pane of glass" moment. Before you show any action, show that Landscape *knows* the estate: what's running where, what's vulnerable, what needs a reboot and what isn't licensed. Many customers can't answer *"how many Ubuntu machines do you have, and on which releases?"* in under a day. You'll answer it in 10 seconds.

---

## Part A: The Overview page (60-second opener)

1. Click **Overview** in the sidebar.
2. Find these areas. Names can differ slightly between versions; look for their meaning:
   - **Instance counts and status:** online, offline, pending
   - **Upgrades:** how many instances have **security** upgrades and how many have regular upgrades
   - **Alerts / items needing attention:** e.g. reboot required, pending instances
3. Click the number next to **Security** upgrades. You land on a filtered list of the machines that need security fixes. (Lab 06 fixes them.)

🎤 **Say it on the call:** *"This is your estate's health at a glance. Three machines here; it's the same view with thirty thousand. The number I care about first is this one: how many machines have outstanding **security** updates."*

---

## Part B: The Instances list and search

1. Click **Instances**. You should see `web-01`, `db-01` and `legacy-01`.
2. Look at the columns: **status**, **OS and version**, **tags**. Notice that `legacy-01` is on **22.04** while the others are on **24.04**.
3. Try these in the **search bar**, one at a time:

| Type this | It finds |
|---|---|
| `tag:production` | Machines tagged `production` |
| `distribution:jammy` | Machines running Ubuntu 22.04 (`distribution:22.04` also works) |
| `alert:security-upgrades` | Machines with outstanding security updates |
| `needs:reboot` | Machines waiting for a reboot |
| `tag:production NOT distribution:noble` | Production machines that are *not* on 24.04 |

> [!TIP]
> `OR` and `NOT` must be in CAPITALS. The search box also suggests syntax as you type.

### Saved searches (Landscape 26.04 LTS and later, self-hosted)

1. Type `alert:security-upgrades tag:production` in the search bar.
2. Click **Save search**, give it the title `Prod needing security fixes` and click **Add saved search**.
3. Clear the search, click the search bar again and pick your saved search from the list.

🎤 **Say it on the call:** *"Your security lead can save 'production machines with open security fixes' once and check it every morning. Saved searches are also how you target actions at the right machines."*

---

## Part C: One machine, every detail

Click **web-01** and visit each tab. Don't change anything yet; just look.

| Tab | What to notice | Why customers care |
|---|---|---|
| **Info** | Status, last ping time, access group, tags, registration details, Ubuntu Pro status | "When did we last hear from this box?" |
| **Hardware** | CPU, memory, disks, network | Asset inventory without a separate CMDB scan |
| **Packages** | Every installed `.deb` with its version; filters for upgrades and security upgrades | "Which machines still run the vulnerable OpenSSL?" |
| **Snaps** | Installed snaps, channels and held snaps | Snaps are managed too |
| **Kernel** | Running kernel, Livepatch status and coverage | The no-reboot story (Lab 06) |
| **Security issues** | Outstanding USNs for this machine | Lab 06 |
| **Activities** | Everything Landscape has done or will do on this machine | Audit trail |
| **Users** | Local Linux users and groups | Create, lock or remove local users without SSH |

✅ **Checkpoint:** you can find web-01's kernel version and total RAM in under 15 seconds. Practice until you can; in a live demo, hesitating looks like unfamiliarity.

---

## Part D: Attach Ubuntu Pro from the browser

In Lab 04 you enabled the `ProManagement` plugin on the clients. Now you'll license all three machines **without opening a terminal**.

1. Go to **Instances** and tick **web-01**, **db-01** and **legacy-01**.
2. Click **Attach token** (it may be under an actions or **Operations** menu).
3. Paste your **Ubuntu Pro token** and complete the prompts.
4. Go to **Activities**. You'll see one activity per machine, moving from **Queued** to **In progress** to **Succeeded** within a few minutes.

✅ **Checkpoint:** each instance's **Info** tab shows Ubuntu Pro as attached, and **Org. settings > Licenses** shows your license in use.

> [!NOTE]
> Attaching Pro from the portal needs Landscape Server and Client **25.10 or later** with the `ProManagement` plugin, and it isn't available for offline clients or Ubuntu Core devices. If the button is missing or the activity fails (for example on `legacy-01` with an older client), attach from the terminal instead:
> ```bash
> multipass exec legacy-01 -- sudo pro attach <YOUR_PRO_TOKEN>
> ```
> *What this does:* `multipass exec` runs one command inside the VM without opening a full shell. Everything after `--` is the command to run.

🧠 **Linux moment: what attaching Pro just did on each machine**
It turned on **ESM Infra** and **ESM Apps** (10-year security updates, including the *universe* repository) and **Livepatch**. The machines will now report more available security updates, because ESM updates are now visible to them. Remember that for Lab 06.

🎤 **Say it on the call:** *"Licensing a hundred machines is select, attach token, done. And Landscape warns you before a Pro contract expires, up to 90 days ahead, so coverage doesn't lapse silently."*

---

## Part E: Organize with tags

Tags are free-form labels. You can put as many tags as you like on a machine, and **profiles** (Lab 08) target machines by tag.

1. In **Instances**, tick **web-01** and **db-01**.
2. Click **Grouping > Assign tags** and add the tag `eu-west`. Click **Assign**.
3. Open **legacy-01**, click **Edit**, add the tag `us-east` and click **Save changes**.
4. Search `tag:eu-west`.

✅ **Checkpoint:** the search returns exactly web-01 and db-01.

> [!IMPORTANT]
> Adding a tag can **change a machine's configuration**: any profile linked to that tag applies to the machine automatically. That's powerful. Mention it when you demo profiles, and be careful with tags on real customer systems.

**Tags vs. access groups vs. annotations** (you'll get asked):

| | **Tags** | **Access groups** (Lab 10) | **Annotations** (Lab 07) |
|---|---|---|---|
| What it is | Labels set by admins | Security boundary for *who can manage what* | Key/value facts the **machine reports about itself** |
| Per machine | Many | Exactly **one** | Many |
| Typical use | Target profiles and actions, filter lists | Delegate admin rights by team, site or department | Rack location, owner, asset ID, app version |

---

## Part F: Alerts

1. Go to **Account settings > Alerts** (in your user menu).
2. Look at the list. These are the alerts you'll mention most:

| Alert | Triggers when |
|---|---|
| **Security upgrades** | Security updates are available |
| **Computer reboot** | A machine needs a reboot (e.g. after a kernel update) |
| **Computer offline** | A machine hasn't contacted Landscape for 5 minutes |
| **ESM disabled** | ESM updates are turned off on a machine |
| **Pending computers** | Machines are waiting for approval |
| **Ubuntu Pro contract expiration** | A Pro contract is about to expire |
| **Package profiles** | A machine doesn't comply with its package profile |

3. Subscribe to **Computer offline** and **Security upgrades**.

> [!NOTE]
> On self-hosted Landscape, alert **emails** are sent only once Postfix is configured on the server (see the docs: *How to configure Postfix for emails*). In your lab, alerts appear in the portal but may not reach your inbox. That's fine for demos.

### Try it: make a machine go "offline"

⌨️ **In the terminal** (on your laptop)

```bash
multipass stop db-01
```

*What this does:* shuts down the `db-01` VM.

Wait about 5 minutes, then check **Instances**: db-01 shows as **offline**, and the alert is active. Then bring it back:

```bash
multipass start db-01
```

✅ **Checkpoint:** after a few minutes db-01 is back online and the alert returns to OK by itself.

🎤 **Say it on the call:** *"Alerts tell you when something needs a human: a machine stopped reporting, a reboot is pending, ESM got switched off. Fix the cause and the alert clears itself."*

---

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. A customer asks: "Show me every 22.04 machine in production that still needs security fixes." What do you type? <em>(L05-2)</em></summary>

`distribution:jammy tag:production alert:security-upgrades` (or `distribution:22.04 …`). Then save it as a saved search.
</details>

<details>
<summary>2. How many access groups can a machine be in? How many tags? <em>(L05-5)</em></summary>

Exactly one access group; any number of tags.
</details>

<details>
<summary>3. Why did the number of available security updates go up after attaching Ubuntu Pro? <em>(L05-4)</em></summary>

Attaching Pro enabled ESM Infra and ESM Apps, so the machines can now see (and get) extended security updates, including fixes for packages in universe.
</details>

<details>
<summary>4. After how long does Landscape consider a machine offline? <em>(L05-6)</em></summary>

When it hasn't contacted Landscape within the last five minutes.
</details>

<details>
<summary>5. On the Overview page, which number do you point at first in a demo, and why? <em>(L05-1)</em></summary>

The number of instances with outstanding **security** upgrades. It's the clearest measure of the customer's current exposure, and it leads straight into the patching demo.
</details>

## 📚 Read more

- Official docs → *Web portal > Manage instances* (search, saved searches, actions on multiple instances)
- Official docs → *Explanation > Alerts* (every alert and how subscriptions work)
- Official docs → *Reference > Terms*: Tags, Access groups
- Official docs → *How to attach your Ubuntu Pro subscription* (automated attachment across multiple clients)

---

**Next:** [Lab 06: Security patching, CVEs and Livepatch →](06-security-patching-and-cves.md)
