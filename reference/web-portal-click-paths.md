# Web portal click paths

Quick lookup for live demos. Paths are for the **modern web portal** (default from Landscape 26.10). Labels can shift slightly between versions.

| I want to… | Click path |
|---|---|
| See estate health | **Overview** |
| See machines with security updates | **Overview → Upgrades → Security**, or **Instances → Status → Security upgrades**, or search `alert:security-upgrades` |
| Accept a pending machine | **Overview → Pending** tile, or **Instances → pending instances → Accept** |
| Search machines | **Instances** → search bar (`tag:`, `distribution:`, `alert:`, `needs:reboot`, `access-group:`, `annotation:`, `OR`, `NOT`) |
| Save a search | **Instances** → type query → **Save search** |
| Machine details | **Instances → machine** → tabs: Info, Hardware, Packages, Snaps, Kernel, Security issues, Activities, Users |
| Fix security issues on one machine | **Instances → machine → Security issues** → select → **Upgrade** |
| Upgrade several machines | **Instances** → select → **Upgrade** (all packages) or **Deb management → Upgrade** (chosen packages, 26.10+) |
| Install/remove packages on many machines | **Instances** → select (≤100) → **Deb management** (26.10+) |
| Manage snaps on many machines | **Instances** → select → snap management actions |
| Hold / unhold a package | **Instances → machine → Packages** → select → **Hold** |
| Livepatch / kernel | **Instances → machine → Kernel** |
| Restart machines | **Instances → machine → Restart instance**, or select several → restart action |
| Attach Ubuntu Pro | **Instances** → select → **Attach token** (needs client 25.10+ with `ProManagement`) |
| Add tags | **Instances** → select → **Grouping → Assign tags**, or **machine → Edit** |
| Change access group | **Instances** → select → **Grouping → Assign access group**, or **machine → Edit** |
| Run a script | **Instances** → select → **Operations → Run script** |
| Add / archive / redact scripts | **Scripts → Add script**, or **⋮ (Actions) → Archive / Redact** |
| See all activities | **Activities** (sidebar), or **machine → Activities** |
| Profiles | **Profiles →** Package / Upgrade / Reboot / Removal / Script / USG / Repository / WSL |
| Download a USG audit | **Profiles → USG profiles → ⋮ → Download audit** |
| Repository mirrors | **Repositories →** Mirrors / Local repositories / Publication targets / Publications / Repository profiles (needs Debarchive, 26.04+) |
| Create / sync / publish a mirror | **Repositories → Mirrors → Add mirror**; select → **Update** (sync); select → **Publish** |
| Point machines at a mirror | **Repositories → Repository profiles → Add repository profile** (deb line + public GPG key + tag) |
| Access groups | **Org. settings → Access groups** |
| Roles | **Org. settings → Roles** |
| Invite an admin | **Org. settings → Administrators → Invite administrator** |
| Licenses | **Org. settings → Licenses** |
| Alert subscriptions | **Account settings → Alerts** |
| Local users on a machine | **Instances → machine → Users** |
| Annotations | **Instances → machine → Info**; search `annotation:key:value` |
| Sanitize (⚠️ irreversible) | **Instances → machine → Info → Sanitize** |
| Remove a machine from Landscape | **Instances → machine → More actions → Remove from Landscape** |
