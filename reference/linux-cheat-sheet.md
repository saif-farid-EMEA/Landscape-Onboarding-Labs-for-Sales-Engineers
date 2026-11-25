# Linux cheat sheet (for Sales Engineers)

Everything from [Lab 01](../labs/01-linux-survival-kit.md) on one page.

## Multipass (on your laptop)

| Command | What it does |
|---|---|
| `multipass launch 24.04 --name NAME` | Create an Ubuntu 24.04 VM |
| `multipass list` | List VMs, their state and their IPs |
| `multipass info NAME` | Details of one VM (IP address etc.) |
| `multipass shell NAME` | Open a shell inside the VM (`exit` to leave) |
| `multipass exec NAME -- COMMAND` | Run one command inside the VM |
| `multipass stop --all` / `multipass start --all` | Pause / resume all VMs |
| `multipass snapshot NAME --name SNAP` | Save a restore point (VM must be stopped) |
| `multipass restore NAME.SNAP` | Roll back to a restore point (VM must be stopped) |
| `multipass delete NAME --purge` | Delete a VM permanently |

## Moving around

| Command | What it does |
|---|---|
| `pwd` | Where am I? |
| `ls -l` | List files (long format) |
| `cd /path` / `cd ~` | Go to a folder / go home |
| `cat FILE` | Print a file |
| `less FILE` | Scroll through a file (`q` to quit, `/word` to search) |
| `nano FILE` | Edit a file (`Ctrl+O` save, `Ctrl+X` exit) |
| `grep TEXT FILE` | Find lines containing TEXT |
| `clear` | Clear the screen |

## Admin and software

| Command | What it does |
|---|---|
| `sudo COMMAND` | Run a command as root (admin) |
| `sudo apt update` | Refresh the list of available packages (installs nothing) |
| `apt list --upgradable` | Show packages with newer versions available |
| `sudo apt upgrade` | Install all available updates |
| `sudo apt install -y PKG` | Install a package |
| `apt-cache policy PKG` | Show installed and available versions of a package |
| `snap list` | List installed snaps |
| `sudo pro attach TOKEN` | Attach a machine to Ubuntu Pro |
| `pro status` | Show which Ubuntu Pro services are enabled |
| `sudo pro fix CVE-XXXX-YYYY` | Fix a specific CVE |

## System information

| Command | What it does |
|---|---|
| `cat /etc/os-release` | Which Ubuntu version is this? |
| `uname -r` | Running kernel version |
| `hostname` / `hostname -I` | Machine name / IP address(es) |
| `uptime -p` | How long since the last boot |
| `df -h` | Disk usage |
| `free -h` | Memory usage |
| `systemctl status SERVICE` | Is a service running? |
| `sudo canonical-livepatch status` | Livepatch status |

## Landscape-specific

| Where / command | What it is |
|---|---|
| `/etc/landscape/client.conf` | Client configuration |
| `/var/log/landscape/` | Client logs (`broker.log` covers server communication) |
| `/var/lib/landscape/client/annotations.d/` | Annotation files (file name = key, contents = value) |
| `sudo landscape-config --silent` | Register using the settings in `client.conf` |
| `sudo systemctl restart landscape-client` | Restart the client after config changes |
| `/etc/landscape/service.conf` | Server configuration (self-hosted) |
| `sudo lsctl status` / `sudo lsctl restart` | Server: check or restart Landscape services |

## Reading the prompt

```
ubuntu@web-01:~$      user "ubuntu", on machine "web-01", in the home folder, normal user ($)
root@web-01:/etc#     user "root", in /etc, root shell (#): be careful!
```
