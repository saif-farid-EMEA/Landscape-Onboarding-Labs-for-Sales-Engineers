# Lab 03: Build your demo server (self-hosted Landscape)

**Time:** 60 minutes (about 20 of it waiting for installs) · **Path:** Full path only. On the light path, skip to [Lab 04](04-enroll-your-fleet.md) and use your SaaS account.

## 🎯 Why this matters on a call

1. You get a demo environment that **you own**: no shared-tenant surprises, and every self-hosted feature is available.
2. Customers will ask *"How hard is it to install?"* After this lab you can answer honestly: *"For an evaluation, about half an hour on one VM. For production, there are Manual and Juju (high-availability) options."*
3. You'll understand the moving parts (PostgreSQL, RabbitMQ, Apache, background services) well enough to follow an architecture conversation.

> [!NOTE]
> This lab follows the official guides **"Getting started with Landscape"** (tutorial) and **"How to install Landscape Server with quickstart mode"**. Quickstart puts everything on one machine. It's great for demos and evaluations, but it's **not** the recommended production setup.

---

## Step 1: Create the server VM

⌨️ **In the terminal** (on your laptop)

```bash
multipass launch 24.04 --name landscape-server --cpus 2 --memory 8G --disk 25G
```

*What this does:* creates an Ubuntu 24.04 VM with 2 CPUs, 8 GB of RAM and 25 GB of disk. The Quickstart guide asks for a dual-core CPU, 8 GB RAM and 20 GB disk. If your laptop is tight on RAM, `--memory 6G` works for a small demo (the official tutorial uses 6 GB).

> [!IMPORTANT]
> Use Ubuntu **24.04** (or 22.04) for the server. The Quickstart package is **not** supported on Ubuntu 26.04, even though Landscape Server itself is.

```bash
multipass info landscape-server
```

*What this does:* shows details about the VM. Find the line `IPv4:` and **copy that IP address into your notes as `<SERVER_IP>`**. You'll use it many times.

✅ **Checkpoint:** you have an IP address like `10.x.x.x` or `192.168.x.x`.

---

## Step 2: Open a shell on the server

```bash
multipass shell landscape-server
```

✅ **Checkpoint:** your prompt is `ubuntu@landscape-server:~$`. **Check the prompt before every command in this lab.**

---

## Step 3: (Optional) Attach Ubuntu Pro to the server

```bash
sudo pro attach <YOUR_PRO_TOKEN>
```

*What this does:* attaches this machine to your Ubuntu Pro subscription, which turns on ESM security updates and Livepatch for the server itself. The Quickstart guide recommends it. It uses 1 of your 5 free seats. If you want to keep seats for managed machines, skip this step: the demo works either way.

---

## Step 4: Add the Landscape software source (a "PPA")

```bash
sudo apt update && sudo apt install -y software-properties-common
```

*What this does:* refreshes the package list, then installs `software-properties-common`, which provides the `add-apt-repository` tool. `&&` means "run the second command only if the first one succeeded".

```bash
sudo add-apt-repository -y ppa:landscape/latest-stable
```

*What this does:* adds the **Landscape PPA** to this machine's software sources, so APT can find Landscape Server packages.

🧠 **Linux moment: what's a PPA?**
A **PPA** (Personal Package Archive) is an extra repository hosted on Launchpad, Canonical's build service. Landscape ships through PPAs:

| PPA | What it is | Use it for |
|---|---|---|
| `ppa:landscape/self-hosted-26.04` | **26.04 LTS** (long-term support) | Production. This is what most customers run. |
| `ppa:landscape/latest-stable` | Newest release (**26.10** at the time of writing). Supported until the next release. | **Demos and labs** (newest portal and features) |
| `ppa:landscape/self-hosted-beta` | Beta | Testing only |

🎤 If a customer asks *"which version should we run?"*: *"For production, the current LTS. Today that's 26.04, with standard support to 2031 and ESM to 2038."*

---

## Step 5: Install Landscape Server (Quickstart)

```bash
sudo apt-get update
```

*What this does:* refreshes the package list again so it includes packages from the PPA you just added.

```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y landscape-server-quickstart
```

*What this does:* installs Landscape Server **plus everything it needs on this one machine**:
- **PostgreSQL**, the database that stores your estate's data
- **RabbitMQ**, the message queue for background jobs
- **Apache**, the web server and HTTPS front door, with a **self-signed certificate**
- the Landscape services themselves

`DEBIAN_FRONTEND=noninteractive` tells the installer not to stop and ask questions; it uses sensible defaults.

⏳ This takes about **5 to 10 minutes** and prints a lot of text. That's normal. Use the time to reread [Lab 02, section 2](02-landscape-big-picture.md#2-how-it-works-client-and-server).

✅ **Checkpoint:** the command returns to the prompt without a red `E:` error line at the end.

---

## Step 6: Install the background-service snaps (Landscape 26.04 and later)

Since 26.04 LTS, two of Landscape's background services ship as **snaps**:
- **landscape-task-handler** runs background tasks.
- **landscape-outbox** delivers outgoing messages and work.

They need a small amount of setup. Go slowly here: this is the most "Linux-y" part of the course.

### 6a. Install the task handler

```bash
sudo snap install landscape-task-handler
```

*What this does:* installs the task handler snap from the Snap Store.

### 6b. Give the task handler its own database

```bash
sudo -u postgres createdb landscape-standalone-task-handler
```

*What this does:* runs `createdb` **as the `postgres` user** (`-u postgres`), the PostgreSQL admin account. It creates an empty database named `landscape-standalone-task-handler`.

```bash
sudo -u postgres psql landscape-standalone-task-handler -c \
  "GRANT CONNECT ON DATABASE \"landscape-standalone-task-handler\" TO landscape;"
```

```bash
sudo -u postgres psql landscape-standalone-task-handler -c \
  "GRANT CREATE ON SCHEMA public TO landscape;"
```

*What these do:* `psql` is the PostgreSQL command-line client, and `-c` runs one SQL command. Together they let the `landscape` database user connect to the new database and create tables in it. (The `\` at the end of a line just means "the command continues on the next line".)

✅ **Checkpoint:** each `psql` command prints `GRANT`.

### 6c. Find the database password Landscape generated

During Step 5, Quickstart generated a database password and stored it in Landscape's main config file. Let's read it:

```bash
sudo grep -A 10 '^\[stores\]' /etc/landscape/service.conf
```

*What this does:* `grep` searches a file for text. This finds the line `[stores]` and shows it plus the 10 lines after it (`-A 10`). The file is protected, so you need `sudo`.

Find the line that starts with `password =` and copy the value after `=`.

- If the value starts with **`b64:`**, it's base64-encoded (a reversible text encoding, **not** encryption). Decode it, replacing the placeholder with the value **without** the `b64:` prefix:

  ```bash
  echo '<VALUE_WITHOUT_B64_PREFIX>' | base64 -d; echo
  ```

  *What this does:* sends the text into `base64 -d` (decode), which prints the real password. The final `echo` just adds a line break.

- Otherwise, the value is already the plain password.

Save it in your notes as `<DB_PASSWORD>`.

> [!TIP]
> Prefer reading the file yourself? Run `sudo less /etc/landscape/service.conf`, type `/stores` and press Enter to jump to that section, then press `q` to quit. You'll see the same thing.

### 6d. Point the task handler at its database

```bash
sudo snap set landscape-task-handler \
  landscape.database.task-handler.host=localhost \
  landscape.database.task-handler.port=5432 \
  landscape.database.task-handler.name=landscape-standalone-task-handler \
  landscape.database.task-handler.user=landscape \
  landscape.database.task-handler.password=<DB_PASSWORD> \
  landscape.database.task-handler.ssl=disable \
  landscape.task-handler.server.grpc-port=50053 \
  landscape.task-handler.server.host=localhost
```

*What this does:* `snap set` stores configuration for a snap. Line by line, this says: the database is on this machine (`localhost`) on PostgreSQL's standard port `5432`; here are its name, user and password; don't use SSL to reach it (it's on the same machine); and the task handler should listen on port `50053`.

```bash
sudo snap services landscape-task-handler
```

*What this does:* shows the snap's services and whether they're running.

✅ **Checkpoint:** `landscape-task-handler.server` and `landscape-task-handler.worker` show **active**. Other entries (like `cleanup`) may say *inactive*. That's expected: they run on timers.

### 6e. Install the outbox

```bash
sudo snap install landscape-outbox
```

```bash
sudo snap connect landscape-outbox:grpc-client-certs landscape-task-handler:grpc-client-certs
```

*What this does:* snaps are sandboxed. `snap connect` explicitly allows the outbox to use the task handler's client certificates, so the two can talk securely.

```bash
sudo snap services landscape-outbox
```

✅ **Checkpoint:** `landscape-outbox.outbox` is **active**.

> [!NOTE]
> A third snap, **landscape-debarchive**, adds repository management (mirrors). We don't need it for the demo estate. Lab 11 explains what it does and where to find setup instructions.

### 6f. Check every Landscape service

```bash
sudo lsctl status
```

*What this does:* `lsctl` is Landscape's own service-control tool. `status` lists each Landscape Server service and whether it's running. (`sudo lsctl restart` restarts them all, which is handy when something misbehaves.)

✅ **Checkpoint:** the services show as active/running.

---

## Step 7: Leave the server

```bash
exit
```

✅ **Checkpoint:** your prompt is back on your laptop.

---

## Step 8: Create the first administrator (web browser)

🖱️ **In the web portal**

1. In your browser, go to `https://<SERVER_IP>`.
2. Your browser warns about the certificate (*"Your connection is not private"*). That's because Quickstart created a **self-signed** certificate, one that no public authority vouches for. For a lab, accept the risk: usually **Advanced > Proceed to … (unsafe)** or **Accept the Risk and Continue**.
3. Fill in the form to create the **first administrator** (your name, email and a password you'll remember).
4. Landscape creates your account. On self-hosted Landscape, the **account name is `standalone`**. Write that down: clients need it to register.

🎤 **Say it on the call** (if a customer sees the warning on your screen): *"That's just my lab's self-signed certificate. In production you'd use your own CA or Let's Encrypt. The Quickstart guide does it with Certbot in one command."*

5. **Web portal vs. legacy portal.** Landscape 26.10 opens the modern **web portal** by default, with a left **sidebar** (Overview, Instances, Activities, Scripts, Profiles, Org. settings...). These labs always use the modern portal. If you ever land in the older-looking **legacy portal** (for example on a 26.04 LTS server, where it's still the default), look for the link to the new web portal in the header.

6. **Set the system email address.** Go to **Settings** (in the legacy portal: **Settings** in the header) and check the **System email address**, for example `noreply@example.com`. Landscape uses it as the sender address for invitations and alerts.

✅ **Checkpoint:** you're logged in and see an empty **Overview** with 0 instances. Bookmark the page.

---

## Step 9: Snapshot your server (your safety net)

⌨️ **In the terminal** (on your laptop)

```bash
multipass stop landscape-server
```

```bash
multipass snapshot landscape-server --name fresh-install
```

```bash
multipass start landscape-server
```

*What these do:* stop the VM, save a **snapshot** (a restore point) called `fresh-install`, and start the VM again. If you break something later, Lab 14 shows how to roll back in one command instead of reinstalling.

---

## What you just built (and what production looks like)

| | Your lab (Quickstart) | Production |
|---|---|---|
| Machines | 1 VM: everything together | Separate or multiple machines for Landscape Server, PostgreSQL and RabbitMQ, behind HAProxy |
| Install method | `landscape-server-quickstart` | **Manual** (Debian packages, full control) or **Juju charms** (recommended for **high availability**, also deployable with Terraform) |
| Certificate | Self-signed | Your own CA, or Let's Encrypt |
| Login | Email and password | **OIDC**, **Active Directory** or **PAM** single sign-on |
| Hardening | Defaults | Hardening guide, FIPS-compliant install, DISA-STIG-compliant install guide |
| Sizing (per node) | 2 vCPU / 8 GB / 20 GB | Starting point 8 vCPU / 16 GB / 512 GB, plus 2 TB or more if mirroring repositories |

## ❓ Check yourself

<details>
<summary>1. What are the three main third-party services behind Landscape Server?</summary>

PostgreSQL (database), RabbitMQ (message queue) and a reverse proxy/web server: Apache for Quickstart, HAProxy for charmed/HA deployments.
</details>

<details>
<summary>2. What's the account name on a self-hosted Landscape server?</summary>

`standalone`
</details>

<details>
<summary>3. Which install method would you mention to a customer who needs high availability?</summary>

The Juju-managed Landscape Server charms (optionally deployed with Terraform), with multiple Landscape servers behind HAProxy.
</details>

<details>
<summary>4. Why did the browser warn you, and is it a problem in production?</summary>

The certificate is self-signed. In production the customer installs a trusted certificate (their own CA or Let's Encrypt), so there's no warning.
</details>

## 📚 Read more

- Official docs → *How-to guides > Landscape installation and set-up*: Quickstart, Manual, Juju, Terraform, high availability, Google Cloud, Azure
- Official docs → *Explanation > Landscape Server architecture* and *Landscape deployment models*
- Official docs → *How to harden your Landscape deployment*, *How to install Landscape in compliance with the DISA STIG*, *Install on FIPS-compliant machines*
- Official docs → *How to enable OIDC authentication*, *How to authenticate with Active Directory*

---

**Next:** [Lab 04: Enroll your fleet →](04-enroll-your-fleet.md)
