# Lab 01: Linux survival kit

**Time:** 60 minutes · **Prerequisite:** [Lab 00](00-start-here.md) (Multipass installed)

## 🎯 Why this matters on a call

You don't need to be a Linux administrator to sell Landscape, but your audience usually *is*. If you know what `apt`, a kernel, a CVE or `sudo` means, you'll understand their pain, follow their questions, and avoid sounding scripted. This lab covers only what you need for that, using a throwaway VM called `sandbox`.

---

## Part A: Get a sandbox and open a shell

⌨️ **In the terminal** (on your laptop)

```bash
multipass launch 24.04 --name sandbox
```

*What this does:* downloads an Ubuntu 24.04 image (the first time only) and starts a new virtual machine named `sandbox` from it. This takes 1 to 3 minutes.

```bash
multipass list
```

*What this does:* lists your VMs, their state (Running/Stopped) and their IP addresses.

```bash
multipass shell sandbox
```

*What this does:* opens a **shell** (a text session) *inside* the VM. From now on, everything you type runs on `sandbox`, not on your laptop.

✅ **Checkpoint:** Your prompt changes to something like `ubuntu@sandbox:~$`.

🧠 **Linux moment: reading the prompt**

```
ubuntu@sandbox:~$
  │      │    │ └─ $ = you're a normal user (# would mean you're "root", the all-powerful admin)
  │      │    └─── ~ = you're in your home folder
  │      └──────── the machine's name (its "hostname")
  └─────────────── your username
```

Always check the prompt before typing. *"Which machine am I on?"* is the #1 question Linux admins ask themselves.

---

## Part B: Find your way around (5 commands)

Type each one and look at the output before moving on.

| Command | What it does | Try it |
|---|---|---|
| `pwd` | **P**rint **w**orking **d**irectory: where am I? | `pwd` |
| `ls` | **L**i**s**t the files in this folder | `ls -l /etc` (`-l` = long format) |
| `cd` | **C**hange **d**irectory | `cd /var/log` then `pwd`, then `cd ~` to go home |
| `cat` | Print a file's contents | `cat /etc/os-release` |
| `clear` | Clear the screen | `clear` |

🧠 **Linux moment: "everything is a file"**
On Linux, settings live in plain text files, mostly in **`/etc`**. Logs live in **`/var/log`**. Landscape follows the same rules. Its client settings are in `/etc/landscape/client.conf`, and you'll edit that file in Lab 04.

✅ **Checkpoint:** `cat /etc/os-release` shows `Ubuntu 24.04 LTS` and the codename **Noble Numbat**.

🧠 **Linux moment: Ubuntu releases and "LTS"**
- Ubuntu releases are named `YY.MM`. **24.04** = April 2024.
- Releases in April of even years are **LTS (Long Term Support)**: 22.04 *Jammy*, 24.04 *Noble*, 26.04 *Resolute*.
- An LTS gets **5 years** of standard security maintenance. **Ubuntu Pro** extends that to **10 years** (Expanded Security Maintenance, "ESM"), and more with the Legacy add-on.
- Customers run *mixed estates*: some 22.04, some 24.04, maybe a forgotten 20.04. Landscape shows them all side by side (Lab 05).

---

## Part C: Edit a file with `nano`

```bash
nano notes.txt
```

*What this does:* opens (or creates) `notes.txt` in **nano**, a simple text editor.

1. Type: `Landscape is included in Ubuntu Pro.`
2. Press `Ctrl + O` then `Enter` to **save** ("O" for "write Out").
3. Press `Ctrl + X` to **exit**.

```bash
cat notes.txt
```

✅ **Checkpoint:** you see your sentence.

---

## Part D: Superpowers with `sudo`

Try to read a protected file:

```bash
cat /etc/shadow
```

You get `Permission denied`. This file holds password hashes, so only the admin (**root**) can read it.

```bash
sudo cat /etc/shadow | head -3
```

*What this does:* `sudo` ("**s**uper**u**ser **do**") runs the command as root. `| head -3` passes the output to `head`, which shows only the first 3 lines. The `|` ("pipe") connects commands together.

🧠 **Linux moment: why `sudo` matters in sales**
Giving people `sudo` (root) on production servers is a big security risk. A key Landscape benefit is **delegation without root**: a team member can patch machines from the web portal through a role you give them (Lab 10), without ever getting SSH or `sudo` on those machines.

---

## Part E: Software — packages, repositories and updates

This is the most important part for Landscape demos. Take your time.

🧠 **Linux moment: packages and repositories**
- A **package** is an installable piece of software (like an app installer), e.g. `curl`, `nginx`, `openssl`. Ubuntu packages are `.deb` files.
- A **repository** ("repo", "archive") is an online store of packages. Ubuntu's official archive is split into **main** (Canonical-maintained) and **universe** (community-maintained, 30,000+ packages).
- **APT** is the tool that installs packages from repositories.

```bash
sudo apt update
```

*What this does:* **refreshes the catalogue.** It downloads the latest list of available package versions. It does **not** install anything.

```bash
apt list --upgradable
```

*What this does:* lists the installed packages that have a newer version available.

```bash
sudo apt install -y tree
```

*What this does:* installs the `tree` package. `-y` answers "yes" to the confirmation prompt.

```bash
tree -L 1 /etc/landscape 2>/dev/null || echo "Landscape client is not installed here (yet)"
```

*What this does:* tries to show the `/etc/landscape` folder. `2>/dev/null` hides error messages, and `||` means "if that failed, run this instead". Don't worry about memorizing this. The point is that on a plain VM, Landscape isn't there until we add it.

```bash
sudo apt upgrade
```

*What this does:* **actually installs** every available update. It asks for confirmation. Type `n` and press Enter to cancel; you just wanted to see the list.

> [!IMPORTANT]
> **`apt update` ≠ `apt upgrade`.** *Update* refreshes the list of what's available. *Upgrade* installs it. Customers mix these up all the time. Landscape takes care of both for you, on every machine, on a schedule (Lab 08).

🧠 **Linux moment: CVE and USN (you'll hear these on every security call)**
- **CVE** (Common Vulnerabilities and Exposures): a public ID for one security flaw, e.g. `CVE-2024-6387` (a well-known OpenSSH flaw called "regreSSHion"). Security teams track CVEs.
- **USN** (Ubuntu Security Notice): Canonical's announcement that a fixed package is available, e.g. `USN-6859-1`. One USN can fix several CVEs. Browse them at <https://ubuntu.com/security/notices>.
- Landscape gets its security data **from the USN database**. That's how it can tell a *security* update from an ordinary one (Lab 06).
- **ESM Apps** (part of Ubuntu Pro) extends security fixes to the **universe** repository. Most customers don't realize that, without Pro, universe packages get only *community* security support. 🎤 This is a strong discovery point.

---

## Part F: Snaps

Snaps are another package format from Canonical. They bundle an app with its dependencies, update themselves automatically, and run confined (sandboxed).

```bash
snap list
```

*What this does:* lists installed snaps. You'll see things like `core24` and `snapd`.

Landscape manages **both** `.deb` packages **and** snaps from the web portal (Lab 08).

---

## Part G: The kernel and services

```bash
uname -r
```

*What this does:* prints the running **kernel** version, e.g. `6.8.0-xx-generic`.

🧠 **Linux moment: the kernel and the dreaded reboot**
The **kernel** is the core of the operating system. It talks to the hardware. A kernel security fix normally takes effect only **after a reboot**, and rebooting production servers means downtime, change-approval meetings and weekend work.
**Livepatch** (included in Ubuntu Pro) applies critical and high kernel security fixes **while the machine is running**, with no reboot. Landscape shows the Livepatch status of every machine (Lab 06). 🎤 This is a crowd-pleaser.

```bash
systemctl status ssh --no-pager
```

*What this does:* shows whether the **SSH service** (a program that runs in the background) is running. Look for `active (running)`. Background programs on Linux are called **services** (or "daemons"). Landscape Client also runs as a service: `landscape-client`.

```bash
hostname -I
```

*What this does:* prints this machine's IP address(es).

---

## Part H: Leave and clean up

```bash
exit
```

*What this does:* leaves the VM shell. Your prompt goes back to your laptop.

```bash
multipass delete sandbox --purge
```

*What this does:* deletes the `sandbox` VM. `--purge` also frees the disk space.

✅ **Checkpoint:** `multipass list` no longer shows `sandbox`.

---

## 🎤 Say it on the call

- *"Without a management tool, patching means someone SSHs into each machine and runs `apt update` and `apt upgrade`. That works for 5 machines. It doesn't work for 5,000, and nothing records who did what."*
- *"Landscape knows which pending updates are **security** updates, because it uses Canonical's own Ubuntu Security Notice data."*
- *"With Livepatch, critical kernel fixes go in without a reboot, so your patch window stops being your downtime window."*

## ❓ Check yourself

<details>
<summary>1. What's the difference between <code>apt update</code> and <code>apt upgrade</code>?</summary>

`update` refreshes the list of available versions. `upgrade` installs the newer versions.
</details>

<details>
<summary>2. A customer says "we're tracking CVE-2024-6387". What is that, and how does Ubuntu publish the fix?</summary>

It's the public ID of a specific vulnerability (the OpenSSH "regreSSHion" flaw). Canonical publishes fixed packages and announces them in an Ubuntu Security Notice (USN).
</details>

<details>
<summary>3. Why do kernel updates usually cause downtime, and what reduces that?</summary>

The new kernel normally loads only after a reboot. Livepatch (Ubuntu Pro) applies critical and high kernel fixes to the running kernel without a reboot.
</details>

<details>
<summary>4. What does the <code>$</code> at the end of the prompt tell you?</summary>

You're a normal user, not root. A `#` means you're root.
</details>

## 📚 Read more

- [`reference/linux-cheat-sheet.md`](../reference/linux-cheat-sheet.md): all of the above on one page
- Ubuntu Server docs: <https://documentation.ubuntu.com/server/>
- Ubuntu release cycle: <https://ubuntu.com/about/release-cycle>
- Ubuntu Security Notices: <https://ubuntu.com/security/notices>

---

**Next:** [Lab 02: Landscape, the big picture →](02-landscape-big-picture.md)
