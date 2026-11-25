# Lab 14: Reset and teardown

**Time:** 15 minutes

## 🎯 Goal

Keep your demo estate healthy between calls, save your laptop's battery when you're not demoing, and tear everything down cleanly (freeing your Ubuntu Pro seats) when you're done.

---

## Daily use: pause and resume the estate

⌨️ **In the terminal** (on your laptop)

```bash
multipass stop --all
```

*What this does:* shuts down all your VMs. They keep their state, but stop using RAM and CPU.

```bash
multipass start --all
```

*What this does:* starts them all again. Give Landscape **5 to 10 minutes** after starting: the server's services start up, then each client checks in and the "offline" status clears.

---

## Pre-demo checklist (run before every call)

Start this **at least 30 minutes before** the call.

- [ ] `multipass start --all` and wait 10 minutes
- [ ] Log in at `https://<SERVER_IP>`. Overview loads, and **all instances are online**.
- [ ] **Create a vulnerability**: downgrade `less` on web-01 ([Lab 06, Part B](06-security-patching-and-cves.md#part-b-create-a-vulnerability-on-purpose-demo-prep)), and wait until web-01 shows under **Security upgrades**
- [ ] Check that your saved search, profiles and scripts still exist
- [ ] Have a **USG audit CSV** downloaded and ready (Lab 09)
- [ ] Open the browser tabs you'll need: the portal, the USN page and any slides. **Close everything else** (email, chat, private tabs).
- [ ] Your SaaS account is logged in in a separate window, **as plan B**
- [ ] Laptop on power, notifications off, screen sharing tested

---

## Undo a mistake: restore a snapshot

If you broke the server (or db-01 after the Lab 09 fix exercise), roll back:

```bash
multipass stop landscape-server
```

```bash
multipass restore landscape-server.fresh-install
```

```bash
multipass start landscape-server
```

*What these do:* stop the VM, put it back exactly as it was when you took the `fresh-install` snapshot in Lab 03 (you'll be asked to confirm), and start it again.

> [!WARNING]
> Restoring the server's `fresh-install` snapshot wipes everything you did since then: registered machines, profiles, scripts, users. Your clients will still think they're registered. The cleanest way to recover from that is to delete and recreate the client VMs (Lab 04).

`multipass list --snapshots` shows every snapshot you have.

---

## Remove a machine from Landscape (web portal)

🖱️ **Instances → click the machine → More actions → Remove from Landscape** (several at once: select them → **Operations → Remove from Landscape**).

This only removes the machine from Landscape's management. **It doesn't touch the machine itself.** Mention that on calls; customers sometimes worry.

---

## Full teardown

### 1. Free your Ubuntu Pro seats

Your free subscription covers 5 machines. Detach them before deleting the VMs, or the seats stay in use. In the web portal, select the instances and use the **Detach token** action, **or** from the terminal:

```bash
multipass exec web-01 -- sudo pro detach --assume-yes
```

*What this does:* detaches web-01 from Ubuntu Pro. `--assume-yes` skips the confirmation prompt. Repeat for `db-01`, `legacy-01` (and `landscape-server` if you attached it in Lab 03).

### 2. Delete the VMs

```bash
multipass delete web-01 db-01 legacy-01 landscape-server --purge
```

*What this does:* deletes the four VMs and (`--purge`) frees their disk space immediately.

✅ **Checkpoint:** `multipass list` shows no instances, and your Pro dashboard (<https://ubuntu.com/pro/dashboard>) shows the seats are no longer in use.

### 3. (Optional) Close your SaaS account

If you created a Landscape SaaS account just for training, you can leave it (it's free) or ask Canonical to remove it.

---

## 🎉 You've finished the labs

Go back to the [demo-readiness checklist in Lab 13](13-your-first-demo.md#-youre-demo-ready-when-you-can). Then book a mock demo with your manager.

Found something wrong or out of date? The UI changes over time. Please open a pull request to fix the lab for the next new joiner. See [CONTRIBUTING.md](../CONTRIBUTING.md).
