# Lab 00: Start here

**Time:** 30 minutes · **You'll need:** your laptop, a web browser, an email address

## 🎓 Learning objectives

By the end of this lab, you will be able to:

| ID | Objective | Supports | Checked by |
|---|---|---|---|
| L00-1 | **Set up** the accounts and tools the labs need: an Ubuntu One account, a free Ubuntu Pro token and Multipass. | [PO3](../reference/learning-objectives.md#po3-build) | Checkpoint, section 3 |
| L00-2 | **Explain** how Landscape relates to Ubuntu Pro and what the free tier includes. | [PO2](../reference/learning-objectives.md#po2-positioning) | Check yourself Q1, Q2 |
| L00-3 | **Explain** what a virtual machine is in one sentence a customer would understand. | [PO1](../reference/learning-objectives.md#po1-linux-fluency) | Check yourself Q3 |
| L00-4 | **Choose** the full or light lab path based on your laptop's resources. | [PO3](../reference/learning-objectives.md#po3-build) | Section 4 |

*Supports* links to the course-level [learning outcomes](../README.md#learning-outcomes). The full mapping is in [`reference/learning-objectives.md`](../reference/learning-objectives.md).

---

## 1. How to read these labs

Each lab uses the same building blocks:

| Block | What it means |
|---|---|
| **🎯 Why this matters on a call** | The customer problem this lab helps you talk about. Read this first. |
| **🖱️ In the web portal** | Steps you click through in the Landscape web portal (most steps). |
| **⌨️ In the terminal** | Steps you type. Each command has a **"What this does"** line. Don't copy it until you've read that line. |
| **🧠 Linux moment** | A short explanation of a Linux idea that just came up. |
| **✅ Checkpoint** | How you know the step worked. Don't continue until it does. If it doesn't, check [Troubleshooting](../reference/troubleshooting.md). |
| **🎤 Say it on the call** | A short talk track you can reuse in demos, in plain language. |
| **📚 Read more** | Where to go deeper in the official docs if a customer asks. You don't need to read it now. |
| **❓ Check yourself** | Quiz questions. Answers are hidden. Click to reveal them. |

> [!TIP]
> In code blocks, text in `<ANGLE_BRACKETS>` is a placeholder. Replace the whole thing, brackets included, with your own value. For example, `<SERVER_IP>` becomes `10.20.30.40`.

---

## 2. Create your accounts (web browser only)

### 2a. Ubuntu One account

Ubuntu One is Canonical's single sign-on. You use it for Ubuntu Pro, Landscape SaaS and more.

1. Go to <https://login.ubuntu.com> and click **I don't have an Ubuntu One account**.
2. Fill in the form and verify your email address.

### 2b. Your free Ubuntu Pro token

Ubuntu Pro is the subscription that **includes Landscape**. Every person gets a free personal subscription that covers **up to 5 machines**. That's exactly enough for this lab's estate.

1. Go to <https://ubuntu.com/pro> and choose the free personal subscription. Sign in with Ubuntu One.
2. Open your dashboard at <https://ubuntu.com/pro/dashboard>.
3. Copy your **token** (a long string of letters and numbers) into a private note. Labs 04 and 05 use it.

> [!CAUTION]
> Your Pro token is like a password: anyone who has it can attach machines to *your* subscription. Never paste it into a customer-facing demo screen, a slide or a public chat.

🎤 **Say it on the call:** *"Landscape comes with Ubuntu Pro. If you already pay for Pro, you already have Landscape. And anyone can try it for free on up to 5 machines."*

---

## 3. Install Multipass

**Multipass** is a free Canonical app that creates Ubuntu **virtual machines (VMs)** on your laptop with one command. A VM is a complete computer simulated inside your computer. If you break it, you delete it and start again. Nothing on your laptop is affected.

1. Go to <https://canonical.com/multipass/install> and download the installer for your OS:
   - **macOS:** the `.pkg` installer
   - **Windows:** the `.exe` installer. On Windows 10/11 Pro, Hyper-V is used. On Windows Home, choose VirtualBox when asked.
   - **Ubuntu:** open the **App Center**, search for "multipass" and click **Install**.
2. Run the installer and accept the defaults.
3. Open a terminal so you can check that it worked:
   - **macOS:** press `Cmd + Space`, type `Terminal` and press Enter.
   - **Windows:** press the Windows key, type `PowerShell` and press Enter.
   - **Ubuntu:** press `Ctrl + Alt + T`.

⌨️ **In the terminal**

```bash
multipass version
```

*What this does:* asks Multipass to print its version number. You're only checking that the install worked.

✅ **Checkpoint:** You see something like `multipass 1.x.x`. If you get "command not found", close the terminal, open a new one and try again.

---

## 4. Choose your path (based on your laptop)

Check your RAM:
- **macOS:** Apple menu > **About This Mac**.
- **Windows:** **Settings > System > About**.
- **Ubuntu:** **Settings > About**.

| Your laptop | Your path |
|---|---|
| **16 GB RAM or more** | **Full path (recommended).** You run your own self-hosted Landscape server plus 3 managed machines. Every lab works. |
| **8 GB RAM** | **Light path.** Use **Landscape SaaS** (Canonical hosts the server) and create only 2 managed machines. Skip Lab 03 and use the "SaaS path" boxes in Lab 04. Labs 09 and 11 cover features that are **self-hosted only**. Read them and watch a colleague's demo, or borrow a bigger machine. |

> [!NOTE]
> **Why self-hosted for the full path?** Some of the most valuable demo features, like USG compliance profiles, script profiles and repository mirroring for airgapped sites, are available on **self-hosted** Landscape. Your own server also lets you show the "Landscape runs entirely inside *your* walls" story, which is the heart of the sovereignty conversation in Lab 11.

---

## 5. Your demo estate (what you'll build)

```
             Your laptop (the "host")
 ┌───────────────────────────────────────────────────────┐
 │  Web browser ──https──►  landscape-server (Ubuntu 24.04)│
 │                             ▲        ▲        ▲          │
 │                     reports │        │        │          │
 │                  ┌──────────┘        │        └────────┐ │
 │              web-01             db-01            legacy-01│
 │           (Ubuntu 24.04)    (Ubuntu 24.04)    (Ubuntu 22.04)│
 └───────────────────────────────────────────────────────┘
```

- **landscape-server**: the Landscape Server you'll install in Lab 03.
- **web-01, db-01**: modern machines that pretend to be a web server and a database server.
- **legacy-01**: an older Ubuntu release. Every real customer has a few of these, and they make the best security demo.

## ❓ Check yourself

Each question is tagged with the learning objective it checks.

<details>
<summary>1. How many machines does a free Ubuntu Pro personal subscription cover? <em>(L00-2)</em></summary>

Up to 5 machines.
</details>

<details>
<summary>2. Is Landscape a separate purchase from Ubuntu Pro? <em>(L00-2)</em></summary>

No. Landscape is included in Ubuntu Pro subscriptions. (Managed Landscape, where Canonical runs a dedicated instance for the customer, is a separate conversation with Sales. See Lab 02.)
</details>

<details>
<summary>3. What's a virtual machine, in one sentence you could say to a customer? <em>(L00-3)</em></summary>

A complete computer simulated in software on another computer. It's isolated, so you can create, break and delete it without affecting the real machine.
</details>

---

**Next:** [Lab 01: Linux survival kit →](01-linux-survival-kit.md)
