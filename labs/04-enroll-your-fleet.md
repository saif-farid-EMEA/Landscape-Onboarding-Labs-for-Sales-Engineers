# Lab 04: Enroll your fleet

**Time:** 60 minutes · **Prerequisite:** [Lab 03](03-build-your-demo-server.md) (or a SaaS account on the light path)

## 🎯 Why this matters on a call

*"How do we get our 3,000 machines into Landscape?"* is one of the first practical questions you'll get. After this lab you'll be able to explain the options: **manual approval** (more control), **registration keys** (auto-accept, at scale), **`pro enable landscape`**, and baking registration into your provisioning (cloud-init, Ansible, golden images). You'll also have run each of them yourself.

You'll register three machines in two different ways:
- **web-01** the "long way", editing the config file by hand, so you see every setting.
- **db-01** and **legacy-01** the "scalable way", with one command and a registration key.

---

## Part A: Create the three machines

⌨️ **In the terminal** (on your laptop). Run one at a time.

```bash
multipass launch 24.04 --name web-01 --cpus 1 --memory 1G --disk 8G
```

```bash
multipass launch 24.04 --name db-01 --cpus 1 --memory 1G --disk 8G
```

```bash
multipass launch 22.04 --name legacy-01 --cpus 1 --memory 1G --disk 8G
```

*What these do:* create three small VMs. Two run Ubuntu **24.04** (Noble) and one runs the older **22.04** (Jammy), because real customer estates are always mixed.

✅ **Checkpoint:** `multipass list` shows `landscape-server`, `web-01`, `db-01` and `legacy-01`, all **Running**.

> **🌐 Light path (8 GB RAM / SaaS):** create only `web-01` and `legacy-01`, and skip `db-01`.

---

## Part B: Register web-01 the long way

```bash
multipass shell web-01
```

✅ Prompt: `ubuntu@web-01:~$`

### B1. Install Landscape Client from the Landscape PPA

```bash
sudo add-apt-repository -y ppa:landscape/latest-stable
```

```bash
sudo apt update && sudo apt install -y landscape-client
```

*What these do:* add the same PPA you used for the server, then install **Landscape Client**. Ubuntu's own archive also includes `landscape-client`, but that version is frozen at what shipped with the Ubuntu release. The PPA has the newest client features, such as attaching Ubuntu Pro from the web portal, which you'll use in Lab 05.

### B2. Trust your server's certificate

Your server uses a self-signed certificate, so the client must be told to trust it. (In production, with a properly signed certificate, you'd skip this step.)

```bash
echo | openssl s_client -connect <SERVER_IP>:443 | openssl x509 | sudo tee /etc/landscape/server.pem
```

*What this does* (it's a pipeline, read it left to right):
1. `openssl s_client -connect <SERVER_IP>:443` connects to your server's HTTPS port and prints what the server presents, including its certificate. (`echo |` sends an empty line so the connection closes straight away.)
2. `openssl x509` keeps only the certificate part.
3. `sudo tee /etc/landscape/server.pem` saves it to a file (and also shows it on screen).

✅ **Checkpoint:** the output ends with `-----END CERTIFICATE-----`.

### B3. Write the client configuration file

```bash
sudo nano /etc/landscape/client.conf
```

Replace whatever is in the file with the following, putting **your** server IP in both places:

```ini
[client]
log_level = info
url = https://<SERVER_IP>/message-system
ping_url = http://<SERVER_IP>/ping
data_path = /var/lib/landscape/client
ssl_public_key = /etc/landscape/server.pem
account_name = standalone
computer_title = web-01
tags = web,production
include_manager_plugins = ScriptExecution,UsgManager,ProManagement
script_users = root,landscape,ubuntu
```

Save with `Ctrl + O`, `Enter`, then exit with `Ctrl + X`.

**What every line means.** This is worth knowing; customers' admins will read this file.

| Setting | Meaning |
|---|---|
| `url` | Where the client sends its reports and picks up work (HTTPS, encrypted). |
| `ping_url` | A lightweight "anything for me?" check the client makes frequently. |
| `ssl_public_key` | The certificate to trust: the one you saved in B2. |
| `account_name` | Which Landscape account to join (`standalone` on self-hosted). |
| `computer_title` | The friendly name shown in the portal. |
| `tags` | Labels for grouping and targeting (Lab 05). Tags are sent at registration. |
| `include_manager_plugins` | Optional capabilities that are **off by default**. `ScriptExecution` allows remote scripts (Lab 07), `UsgManager` allows compliance audits (Lab 09) and `ProManagement` allows attaching Ubuntu Pro from the web portal (Lab 05). |
| `script_users` | Which Linux users remote scripts may run as. |

🎤 **Say it on the call:** *"Remote script execution is opt-in. It's **off** on the client until an admin who controls that machine turns it on, and you choose exactly which local users scripts may run as. Security teams like hearing that."*

### B4. Send the registration request

```bash
sudo landscape-config --silent
```

*What this does:* `landscape-config` registers the client. `--silent` means "don't ask questions; read everything from `client.conf`".

✅ **Checkpoint:** you see a message saying the registration request was sent successfully. If it says it couldn't connect, see [Troubleshooting → registration fails](../reference/troubleshooting.md#client-registration-fails).

🧠 **Linux moment: the client is a service**

```bash
systemctl status landscape-client --no-pager
```

*What this does:* shows that `landscape-client` is a service, `active (running)`. Its logs are in `/var/log/landscape/`. You'll check them if anything ever goes wrong: `sudo tail /var/log/landscape/broker.log` shows the last lines of the log that covers server communication.

```bash
exit
```

### B5. Accept web-01 in the portal

🖱️ **In the web portal**

1. Open `https://<SERVER_IP>`. On **Overview**, you should see a **Pending** tile or notification. (It can take a minute to appear. Refresh the page.)
2. Click it, or go to **Instances** and open the pending instances.
3. Select **web-01** and click **Accept**.

✅ **Checkpoint:** **Instances** lists **web-01**. Within a few minutes its details fill in: OS version, tags `web` and `production`, and later packages and hardware.

🎤 **Say it on the call:** *"By default, new machines wait in a pending queue for an admin to approve them. Nothing joins your estate without someone saying yes, unless you choose auto-registration, which I'll show next."*

---

## Part C: Register db-01 and legacy-01 the scalable way

### C1. Set a registration key (web portal)

A **registration key** is a shared secret. Any machine that registers with the right key is accepted **automatically**, with no manual approval.

🖱️ **In the web portal**

1. Go to your account settings: **Org. settings** in the web portal (in the legacy portal, it's the **Account** page). Find the **Registration key** field.
2. Enter a key, e.g. `demo-lab-2026`. Trailing spaces, `;` and `#` aren't allowed.
3. Make sure **Auto register new computers** is ticked, then click **Save**.
4. Save the key in your notes as `<REG_KEY>`.

> [!TIP]
> If you can't find the field in the web portal, switch to the legacy portal and use **Account > Registration key**. The setting is the same in both.

### C2. Register db-01 with one command

```bash
multipass shell db-01
```

```bash
sudo add-apt-repository -y ppa:landscape/latest-stable && sudo apt update && sudo apt install -y landscape-client
```

```bash
echo | openssl s_client -connect <SERVER_IP>:443 | openssl x509 | sudo tee /etc/landscape/server.pem
```

*What these do:* the same steps as B1 and B2, combined.

Now register. This single command does the same job as editing `client.conf` by hand in B3. Compare each `--option` to the table above:

```bash
sudo landscape-config --silent \
  --account-name standalone \
  --computer-title db-01 \
  --url https://<SERVER_IP>/message-system \
  --ping-url http://<SERVER_IP>/ping \
  --ssl-public-key /etc/landscape/server.pem \
  --tags database,production \
  --include-manager-plugins ScriptExecution,UsgManager,ProManagement \
  --script-users root,landscape,ubuntu \
  --registration-key <REG_KEY>
```

*What this does:* writes `client.conf` for you and registers with your registration key, so the machine is **auto-accepted**.

```bash
exit
```

### C3. Register legacy-01

Repeat C2 on `legacy-01` (`multipass shell legacy-01`). Change only these two options:

```
  --computer-title legacy-01 \
  --tags legacy,staging \
```

✅ **Checkpoint:** in **Instances** you now see **3 instances**: web-01, db-01 and legacy-01. You didn't have to accept db-01 or legacy-01; they joined automatically.

> [!NOTE]
> If adding the PPA fails on 22.04, install the client from Ubuntu's own archive with `sudo apt update && sudo apt install -y landscape-client` and carry on. The only difference is that in Lab 05 you'll attach Ubuntu Pro to `legacy-01` from its terminal instead of the portal.

---

## 🌐 SaaS path (light path users)

Everything is the same, except:
- Skip B2/`server.pem` and drop the `ssl_public_key` and `--ssl-public-key` settings. Landscape SaaS has a publicly trusted certificate.
- Use `url = https://landscape.canonical.com/message-system` and `ping_url = http://landscape.canonical.com/ping`.
- Use **your SaaS account name** (shown on the SaaS home page) instead of `standalone`.
- **Even simpler:** with Ubuntu Pro attached, `sudo pro enable landscape` installs the client and launches a registration wizard. Answer **No** to "self-hosted?", then enter a computer title and your account name.

---

## Part D: Registration at scale (concepts for the call)

You won't do these now, but you should be able to talk about them:

| Method | When to mention it |
|---|---|
| **Registration key + auto-register** | "We don't want to click Accept 3,000 times." |
| **`pro enable landscape`** | Pro customers: one command registers the machine, and it can run non-interactively in automation. |
| **Bake it into provisioning** | cloud-init, Ansible, Puppet or Chef, or a golden image: the last step runs `landscape-config`. The docs have a section on *Landscape clients with configuration management tools*. |
| **Juju subordinate charm** | Juju-managed estates. |
| **Landscape Client snap** | Ubuntu Core / IoT devices (Lab 12). |
| **Ubuntu Pro for WSL** | Windows laptops running Ubuntu on WSL (Lab 12). |
| **Removal profiles** | Automatically clean up machines that stopped reporting, which frees license seats (Lab 08). |

🎤 **Say it on the call:** *"Onboarding is one command per machine, and it's usually built into whatever you already use to build servers. Once a machine is in, Landscape applies the matching profiles automatically, based on its tags and access group."*

---

## ❓ Check yourself

<details>
<summary>1. What's the difference between manual acceptance and a registration key?</summary>

Without a key (or with auto-register turned off), new machines wait in a pending queue for an admin to accept them. With a registration key and auto-register on, machines that present the key are accepted automatically.
</details>

<details>
<summary>2. Is remote script execution enabled by default on clients?</summary>

No. It's an opt-in plugin (`ScriptExecution`), and `script_users` limits which local users scripts can run as.
</details>

<details>
<summary>3. Where is the client's configuration file, and where are its logs?</summary>

`/etc/landscape/client.conf`; logs are in `/var/log/landscape/`.
</details>

<details>
<summary>4. Why did we install the client from the PPA instead of Ubuntu's archive?</summary>

The archive version is the one that shipped with that Ubuntu release. The PPA has the latest client features, such as attaching Ubuntu Pro from the web portal.
</details>

## 📚 Read more

- Official docs → *How to install Landscape Client* and *How to configure and register Landscape Client* (registration keys, script execution, configuration management tools)
- Official docs → *How to enable Landscape in the Ubuntu Pro Client*
- Official docs → *How to remove duplicate instances*
- Example `client.conf` with every option: <https://github.com/canonical/landscape-client/blob/main/example.conf>

---

**Next:** [Lab 05: Portal tour, see and organize the estate →](05-portal-tour-and-organizing.md)
