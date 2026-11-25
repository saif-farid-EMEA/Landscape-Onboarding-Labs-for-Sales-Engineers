# Troubleshooting

The problems new joiners hit most often, and how to fix them. If yours isn't here, check the official guide *How to troubleshoot Landscape Client issues*, then ask in your team channel.

## Multipass

**`multipass: command not found`**
Close and reopen your terminal. On Windows, restart your computer after installing.

**`launch failed` or timeouts when creating VMs**
- Check free disk space and RAM. Each VM reserves what you asked for.
- On Windows, make sure virtualization is enabled (Hyper-V or VirtualBox).
- Try again with `multipass launch … --timeout 900`.

**My laptop is very slow**
Stop the VMs you're not using (`multipass stop db-01`), or stop them all with `multipass stop --all`.

**The server's IP changed after a reboot**
Run `multipass list` to get the new IP. Clients registered with the old IP will lose contact. Edit `url` and `ping_url` in `/etc/landscape/client.conf` on each client, then run `sudo systemctl restart landscape-client`. To avoid this, keep the VMs running or pause them with `multipass stop`/`start` rather than restarting your host's virtualization service.

## Server install (Lab 03)

**`add-apt-repository: command not found`**
Install it first: `sudo apt update && sudo apt install -y software-properties-common`.

**Quickstart fails on Ubuntu 26.04**
Quickstart is only supported on Ubuntu 24.04 and 22.04. Recreate the server VM with `24.04`.

**`landscape-task-handler` services aren't active**
- Check the logs: `sudo snap logs landscape-task-handler -n 50`.
- The most common cause is a wrong `<DB_PASSWORD>`. Check whether it started with `b64:` and needed decoding (Lab 03, Step 6c), then run the `snap set` command again with the right value.

**The browser can't reach `https://<SERVER_IP>`**
- Check the VM is running and the IP is right: `multipass list`.
- Check services on the server: `multipass exec landscape-server -- sudo lsctl status`. Restart them with `sudo lsctl restart`.

## Client registration fails

**"Unable to connect" or SSL errors**
1. Did you save the server certificate? `multipass exec web-01 -- cat /etc/landscape/server.pem` should show `BEGIN CERTIFICATE`.
2. Is the IP in `url` and `ping_url` correct? `multipass exec web-01 -- cat /etc/landscape/client.conf`
3. Is `url` **https** and `ping_url` **http**? (That's intentional.)
4. Look at the log: `multipass exec web-01 -- sudo tail -n 30 /var/log/landscape/broker.log`

**The machine never appears as pending**
- Wait 2 to 3 minutes and refresh.
- Check `account_name = standalone` (self-hosted) or your SaaS account name.
- If you used a registration key, the machine is auto-accepted, so look in the **Instances** list, not the pending list.

**Adding the PPA fails on 22.04**
Install the client from Ubuntu's archive instead (`sudo apt install -y landscape-client`). Some newest-client features, like attaching Pro from the portal, may then be unavailable. Use `sudo pro attach` in the terminal instead.

**Duplicate instances**
If you re-registered a machine, it may appear twice. Remove the stale one (**Instances → machine → More actions → Remove from Landscape**). See the docs: *How to remove duplicate instances*.

## Activities stay "Queued"

- Activities run when the client next checks in, which normally takes seconds to a few minutes.
- Is the machine **online** in **Instances**? If not, start the VM (`multipass start NAME`).
- Is the client service running? `multipass exec NAME -- systemctl status landscape-client --no-pager`
- Restart it: `multipass exec NAME -- sudo systemctl restart landscape-client`

## Scripts fail

| Symptom | Fix |
|---|---|
| Fails immediately with a user/permission error | The **Run as** user must be in `script_users` in `client.conf` (Lab 04: `root,landscape,ubuntu`). |
| Every script fails | Is `ScriptExecution` in `include_manager_plugins`? After changing it, restart the client. |
| Times out | Increase the **time limit** (e.g. 600 s for installs). |
| `pro: command not found` or `pro fix` errors | The machine needs Ubuntu Pro attached. Check with `multipass exec NAME -- pro status`. |

## USG (Lab 09)

- Machine not audited → check `UsgManager` is in `include_manager_plugins`, then `sudo systemctl restart landscape-client`.
- `pro enable usg` fails → Pro isn't attached on that machine.
- Audit "missing" → scheduled runs can start later than the selected time, and the time is **UTC**.

## Security upgrades don't show up

- The client reports package state periodically. Wait a few minutes after any change.
- The **server** needs to reach `usn.ubuntu.com` to classify security updates. If your laptop is behind a restrictive proxy or VPN, that may be blocked.
- Use Lab 06, Part B to create a known vulnerability.

## Alerts or invitation emails never arrive

Self-hosted Landscape needs Postfix (or another mail setup) configured to send email. See the docs: *How to configure Postfix for emails*. For demos, alerts in the portal are enough.

## When all else fails

Roll back the server to the `fresh-install` snapshot ([Lab 14](../labs/14-reset-and-teardown.md#undo-a-mistake-restore-a-snapshot)), or delete everything and rebuild from Lab 03. That's also good practice.
