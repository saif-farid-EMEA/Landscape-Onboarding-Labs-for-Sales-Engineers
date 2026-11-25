# Lab 10: RBAC and access control

**Time:** 30 minutes · **Web portal** 🖱️

## 🎯 Why this matters on a call

Large organizations have many teams: the database team, the web team, a security team that should **see everything but change nothing**, an outsourced partner that should only touch one site. Without central management, the usual answer is shared SSH keys and too many people with `sudo`. That's a **Zero Trust** and audit nightmare.

Landscape uses **role-based access control (RBAC)**:
- **Access groups** decide **which machines** someone can manage.
- **Roles** decide **what they can do** to them.
- **Administrators** are given roles.

🎤 *"Least privilege, without handing out root."*

---

## Part A: Build an access-group hierarchy

An access group is a **container for machines** (and also for profiles and scripts). Every machine is in **exactly one** access group. Groups form a tree under **global**, and rights on a parent group **include** its children.

You'll build this:

```
global
├── servers
│   ├── web
│   └── database
└── legacy
```

1. **Org. settings → Access groups → Add access group**.
2. Create `servers` with parent **global**.
3. Create `web` with parent **servers**, then `database` with parent **servers**.
4. Create `legacy` with parent **global**.

> [!NOTE]
> Access group names can only use letters, numbers, `.` and `-`. Other special characters are removed. In the docs, Canonical recommends agreeing on a naming convention (by site, department or environment) **before** rolling out.

✅ **Checkpoint:** you see the five groups, with the hierarchy above.

## Part B: Put machines in their groups

1. **Instances** → open **web-01** → **Edit** → **Access group:** `web` → **Save changes**.
2. Do the same for **db-01** → `database` and **legacy-01** → `legacy`.
   (For many machines at once: select them → **Grouping → Assign access group**.)

✅ **Checkpoint:** searching `access-group:database` returns only db-01.

> [!IMPORTANT]
> Moving a machine to another access group can change which profiles apply to it, because profiles belong to an access group. Also: once a profile is created, **its access group can't be changed**. Plan groups first, then profiles.

---

## Part C: Create roles

1. **Org. settings → Roles**. Notice the built-in **GlobalAdmin** role. It's read-only, so you can't modify it.
2. **Add role** → **Name:** `DB-Operators`.
   - **Access groups:** `database`
   - **Permissions:** viewing machines, managing packages/upgrades and running scripts, but **not** managing administrators or roles. (Read the permission list carefully: each one maps to a capability you saw in earlier labs.)
3. **Add role** → **Name:** `Security-Auditors`.
   - **Access groups:** `global` (so they see every machine, because children are included)
   - **Permissions:** **view-only** permissions (viewing machines, activities and reports), nothing that changes anything.

✅ **Checkpoint:** both roles are listed with their access groups.

## Part D: Invite an administrator (optional)

1. **Org. settings → Administrators → Invite administrator**.
2. Enter a name and an email address and pick the **DB-Operators** role → **Send invite**.

> [!NOTE]
> On your lab server, the invitation email won't actually be delivered unless Postfix is configured (see Lab 05, Part F). That's fine: the point is to know the flow. Two facts worth knowing for real deployments:
> - **Whoever clicks the invitation link first** becomes the administrator, so keep track of pending invites.
> - Landscape SaaS accounts have a default limit of **5 administrators** (pending invites count). Customers can contact Canonical Support to raise it.

🎤 **Say it on the call:** *"Your DBAs can patch and script the database servers, and only those, from a browser, with every action logged. Your security team sees everything and changes nothing. Nobody needs a shared root password or SSH key."*

---

## Part E: Single sign-on and identity (talking points)

Self-hosted and Managed Landscape can use **external authentication** instead of local passwords:

| Method | Typical customer |
|---|---|
| **OIDC** (e.g. Okta, Microsoft Entra ID, Keycloak, Google) | Most modern enterprises |
| **Active Directory** | Windows-centric enterprises |
| **PAM** | Linux-native or LDAP environments |

Facts to get right:
- Landscape uses the identity provider **for authentication only**. **Roles stay in Landscape**; it doesn't import groups from the IdP.
- Users still need an **invitation**; they aren't auto-provisioned.
- Local (password) users **don't get MFA** in Landscape, which is a good reason to recommend SSO: the customer's IdP enforces MFA.
- Landscape SaaS doesn't support bringing a custom identity provider. That's a **Managed** or **self-hosted** feature.
- Since **26.04 LTS**, Landscape records **security events**: successful and failed logins, password resets, token events, role and permission changes, and authorization failures. These are useful for the customer's SIEM.

🎤 *"Hook it to your Okta or Entra ID. Your IdP enforces MFA and offboarding, Landscape enforces who can touch which machines, and both sides are logged."*

---

## ❓ Check yourself

<details>
<summary>1. An admin has a role on the <code>servers</code> access group. Can they manage db-01?</summary>

Yes. db-01 is in `database`, a child of `servers`, and rights on a parent include its children.
</details>

<details>
<summary>2. If you delete the <code>web</code> access group, what happens to web-01?</summary>

The group's resources (machines etc.) move to its parent access group, `servers`.
</details>

<details>
<summary>3. Does Landscape take roles from the customer's identity provider groups?</summary>

No. The IdP (OIDC, AD or PAM) is used for authentication only. Roles and permissions are defined in Landscape.
</details>

<details>
<summary>4. How would you give a security team visibility without the ability to change anything?</summary>

Create a role with only view permissions, associate it with the `global` access group, and assign it to the security team's administrators.
</details>

## 📚 Read more

- Official docs → *Web portal > Manage administrators and roles* and *Manage access groups*
- Official docs → *Explanation > Authentication and authorization in Landscape*
- Official docs → *How to enable OIDC authentication*, *How to authenticate with Active Directory*, *How to enable PAM authentication*
- Official docs → *Reference > Logs* (security event logging)

---

**Next:** [Lab 11: Sovereign, airgapped and repository mirroring →](11-sovereign-airgapped-and-repos.md)
