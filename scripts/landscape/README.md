# Scripts to paste into the Landscape web portal

These scripts are **not** meant to be run on your laptop. During the labs, you **copy each one into the Landscape web portal** (**Scripts > Add script**) and run it on your managed machines from there. That is the "remote script execution" feature you're learning to demo.

Every line is commented. **Read the script before you paste it.** If you can't explain what a line does, re-read its comment or ask a colleague. You will be asked about it on a call.

| Script | Used in | Run as | Changes the machine? |
|---|---|---|---|
| [`01-hello-world.sh`](01-hello-world.sh) | Lab 07, Part A | `ubuntu` | Creates one small text file |
| [`02-fleet-health-report.sh`](02-fleet-health-report.sh) | Lab 07, Part B | `ubuntu` | **No** (read-only, safe for live demos) |
| [`03-set-annotations.sh`](03-set-annotations.sh) | Lab 07, Part C | `root` | Writes two annotation files |
| [`04-pro-fix-cve.sh`](04-pro-fix-cve.sh) | Lab 07, Part D | `root` | Upgrades only the packages needed to fix one CVE |
| [`05-prepare-usg.sh`](05-prepare-usg.sh) | Lab 09, Part A | `root` | Enables USG and installs the `usg` package |

## Tips

- Keep the first line (`#!/bin/bash`). Landscape uses it to decide which interpreter runs the script.
- A script can run only as a user listed in `script_users` in the client's `/etc/landscape/client.conf` (we set `root,landscape,ubuntu` in Lab 04).
- Whatever the script prints appears in the activity's output in the web portal.
- Scripts can be written in any language the machine has an interpreter for (Bash, Python and so on).
- Canonical maintains a public collection of Landscape scripts: <https://github.com/canonical/landscape-scripts>
