# Talk tracks and objection handling

Use these as a starting point, then make them your own. **Never claim more than the docs support.** When unsure, say *"let me confirm and come back to you"*, and do.

## Elevator pitches

**10 seconds**
> "Landscape is Canonical's management tool for Ubuntu. It lets you see, patch, secure and audit every Ubuntu machine you own from one place, and it's included in Ubuntu Pro."

**60 seconds**
> "Most organizations run more Ubuntu than they realize: servers, cloud instances, developer laptops, WSL on Windows, edge devices, and now AI systems like NVIDIA DGX Spark. Keeping all of that patched and compliant usually means scripts, SSH keys and spreadsheets. Landscape replaces that with one console and API. It knows which updates are security fixes because it uses Canonical's own security notices. It applies kernel fixes without reboots through Livepatch, audits machines against CIS and DISA-STIG, and lets you delegate work through role-based access instead of handing out root. You can use it as SaaS, have Canonical run a dedicated instance for you, or self-host it, even fully airgapped. And it comes with Ubuntu Pro."

## Value themes and proof points

| Theme | Proof point in the demo |
|---|---|
| **Reduce exposure window** (time from CVE to fix) | Security upgrades count → USN → one-click fix → activity record (Lab 06) |
| **Fewer reboots, less downtime** | Kernel tab: Livepatch status and coverage (Lab 06) |
| **Continuous compliance** | USG profile → audit CSV with history (Lab 09) |
| **Least privilege / Zero Trust** | Roles on access groups; no SSH or root needed (Lab 10) |
| **Operational efficiency** | Profiles + tags: new machines inherit policy (Lab 08) |
| **Sovereignty / airgap / Sovereign AI** | Self-hosted, offline install, mirrors and snapshots, BYO SSO (Lab 11) |
| **One tool for every Ubuntu** | Servers, desktops, WSL, Core, DGX Spark (Lab 12) |
| **Get value from Pro you already own** | Landscape is part of Ubuntu Pro (Lab 02) |

## Objections

**"We already use Ansible (or Puppet, Chef, Salt)."**
> "Keep it. Ansible is great at defining and enforcing configuration from code. Landscape covers what it doesn't do: a continuous, historical view of your Ubuntu estate's security and compliance, tied directly to Ubuntu Security Notices, Livepatch and Pro, with RBAC so people can act without SSH. A common pattern is to provision with Ansible, where the last task registers the Landscape client, and run day-2 operations in Landscape."

**"We have a Windows-centric tool (SCCM/Intune-type) for everything."**
> "Those tools are built around Windows. Landscape is built by the people who make Ubuntu. It understands USNs, ESM, Livepatch, snaps, USG and Ubuntu releases natively. And for WSL on Windows, Ubuntu Pro for WSL plus Landscape closes the gap your Windows tooling can't see."

**"We can't use SaaS."**
> "No problem. Landscape is also available self-hosted, on-premises or in your own cloud account, even fully airgapped. If you'd rather not operate it, Managed Landscape gives you a dedicated, single-tenant instance that Canonical runs under an SLA."

**"We're airgapped. How do updates get in?"**
> "Self-hosted Landscape installs offline, and its repository mirroring brings Ubuntu updates inside, including ESM. Snapshots and filtered mirrors control exactly what enters. For fully disconnected sites, updates are moved on physical media; our professional services team helps design that." *(Be honest: there's no diff transfer today, so full repository content moves each time. Filtered mirrors help.)*

**"Agents are a security risk."**
> "The client connects outbound over HTTPS. There's no inbound port to open. Remote script execution is **off by default** and limited to the local users you allow. Every action is an audited activity, governed by RBAC. Compare that with shared SSH keys or root on every box."

**"Is it expensive?"**
> "Landscape is included in Ubuntu Pro. If you're paying for Pro, you already have it. If not, Pro also brings 10-year security maintenance including universe, Livepatch, FIPS and USG, so the comparison is against several tools, not one." *(Leave pricing specifics to the account executive.)*

**"How many machines can it handle?"**
> "It scales from a handful to large enterprise estates. For big or critical deployments we recommend the Juju-based high-availability architecture with multiple servers behind HAProxy. Let's size it together for your numbers." *(Don't quote numbers you can't source; involve the product or field engineering team.)*

**"Does it support our identity provider and MFA?"**
> "Self-hosted and Managed Landscape support OIDC, Active Directory and PAM. Your IdP handles authentication, including MFA, and Landscape handles authorization through roles. Landscape SaaS uses Ubuntu One and doesn't support a custom IdP."

**"We run RHEL / other distros too."**
> "Landscape is purpose-built for Ubuntu. That's where its depth comes from: USNs, Livepatch, ESM, USG. For a mixed estate, it sits alongside your other tools for the Ubuntu part, where it gives you more than a generic tool can."

**"What about our AI/GPU systems?"**
> "NVIDIA describes Landscape as its primary recommended management platform for DGX Spark. DGX OS is Ubuntu-based, so those systems get the same inventory, patching, RBAC and audit trail, and NVIDIA's Landscape reference scripts run through Landscape's script execution."

## Words to use and avoid

| ✅ Say | ❌ Avoid |
|---|---|
| "Included in Ubuntu Pro" | "Free" (only up to 5 machines on the personal tier) |
| "Applies high and critical kernel fixes without a reboot" | "Never reboot again" |
| "Audits against CIS and DISA-STIG benchmarks with USG" | "Makes you compliant" / "certified" |
| "Can be deployed fully airgapped" | "Works offline out of the box with no effort" |
| "Let me confirm and come back to you" | Guessing |
