# Cloudflare Funnel Starter

Deploy any local folder to [Cloudflare Pages](https://pages.cloudflare.com/) with a single script — no config files, no dashboards, no complexity.

> **New here?** Follow the [Quick Start](#quick-start) below. You'll have a live URL in under 5 minutes.

---

## What This Does

This repo contains **one script: `setup-deployment-funnel.sh`**.

> The other files in this repo (`demo-site/`, etc.) are supporting assets used internally by the script. You do not need to touch them.

Running the script will:

1. Install [Wrangler](https://developers.cloudflare.com/workers/wrangler/) (Cloudflare's CLI) if you don't have it
2. Log you in to your Cloudflare account via browser
3. Ask which Cloudflare Pages project slug you want to use (e.g., `demo-app`)
4. Ask which local folder you want to deploy
5. Create (or reuse) the Pages project and deploy your site

Need to redeploy later? Just rerun the same script from whatever folder you want to publish.

---

## Quick Start

### Step 1 — Requirements

Make sure you have:

- **Node.js + npm** installed ([download here](https://nodejs.org))
  - macOS shortcut: `brew install node`
- A **Cloudflare account** (free) — [sign up here](https://dash.cloudflare.com/sign-up)
- A browser (for the one-time Cloudflare login)

Check Node is installed:

```bash
node -v
npm -v
```

Both commands should print a version number.

---

### Step 2 — Clone This Repo

```bash
git clone https://github.com/gsofficework/cloudflare-funnel-starter.git
cd cloudflare-funnel-starter
```

---

### Step 3 — Run the Setup Script

```bash
chmod +x setup-deployment-funnel.sh
./setup-deployment-funnel.sh
```

You'll be asked **two simple questions** — **press Enter to accept defaults** if you're not sure:

| Prompt | What it means | Tip |
|--------|--------------|-----|
| **Project slug** | Name of the Cloudflare Pages project → becomes `https://<slug>.pages.dev` | Enter an existing slug to reuse it, or type a new slug (default `private-funnel`) |
| **Which folder to deploy?** | Local folder whose files will go live | Press Enter to use the current directory, or paste an absolute path like `/Users/you/sites/my-project` |

If you're not logged in to Cloudflare yet, a **browser window will open** — just click "Allow" to authorize.

---

### Step 4 — Deploy

As soon as the prompts finish, the script deploys the folder you selected and prints the live URL:

```
https://private-funnel.pages.dev
```

That's it — your site is live!

---

## Deploying Updates

Whenever you want to publish changes, simply rerun the script:

```bash
./setup-deployment-funnel.sh
```

Each run re-uploads the folder you select and prints the canonical URL (`https://<slug>.pages.dev`). The previous deployment stays live until the next one finishes.

---

## Changing the Project Name

The project slug defaults to `private-funnel`. To change the default value, open `setup-deployment-funnel.sh` and edit the `DEFAULT_PROJECT_SLUG` variable near the top, then rerun the script.

---

## Troubleshooting

**"node: command not found" or "npm: command not found"**
Install Node.js from [nodejs.org](https://nodejs.org) or run `brew install node` on macOS.

**Wrangler login didn't open a browser**
Run `npx wrangler login` manually, then re-run the setup script.

**"Project already exists" message**
That's fine — the script will reuse the existing project and continue.

**Deployed but can't see the site**
Check your Cloudflare dashboard under Pages. If you need login/password protection, enable [Cloudflare Access](https://www.cloudflare.com/products/zero-trust/access/) on the project.

**Accidentally deployed the wrong folder?**
1. Rerun `./setup-deployment-funnel.sh` from the correct directory to immediately overwrite the bad deploy.  
2. Or delete the whole Pages project:
   - Visit [https://dash.cloudflare.com/login](https://dash.cloudflare.com/login) and sign in.
   - Open [https://dash.cloudflare.com/?to=/:account/pages](https://dash.cloudflare.com/?to=/:account/pages) (Cloudflare jumps you to the Pages list for your account).
   - Click the project named **private-funnel** → go to **Settings** → scroll to **Delete project** → follow the confirmation flow.
   - The `*.pages.dev` domain is removed. Re-run the script whenever you want to recreate it.

---

## File Overview

```
cloudflare-funnel-starter/
├── setup-deployment-funnel.sh   ← THE script — run this once to get started
├── demo-site/                   ← Sample HTML used if you don't pick a folder
└── README.md
```

> All you need is `setup-deployment-funnel.sh`. The rest is here for reference.
