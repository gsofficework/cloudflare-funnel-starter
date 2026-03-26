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
3. Ask which local folder you want to deploy
4. Create a Cloudflare Pages project for you
5. Generate a reusable `publishfunnel.sh` helper script
6. Deploy your site and give you a live URL

After setup, you just run `publishfunnel.sh` every time you want to push an update.

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

You'll be asked two simple questions — **just press Enter to accept the defaults** if you're not sure:

| Prompt | What it means | Tip |
|--------|--------------|-----|
| **Which folder to deploy?** | The local folder whose files will go live | Press Enter to use the current directory, or paste an absolute path like `/Users/you/sites/my-project` |
| **Where to save the helper script?** | Where to create the reusable `publishfunnel.sh` file | Press Enter to save it here in this repo folder |

If you're not logged in to Cloudflare yet, a **browser window will open** — just click "Allow" to authorize.

---

### Step 4 — Deploy

At the end of setup, you'll be asked:

```
Run it now? [y/N]:
```

Type `y` and press Enter. Your site will be uploaded and you'll see a live URL like:

```
https://private-funnel.pages.dev
```

That's it — your site is live!

---

## Deploying Updates

Whenever you make changes to your files, just run the helper script:

```bash
./publishfunnel.sh
```

It re-uploads your folder and gives you a new preview URL. The previous deployment stays live until the new one is ready.

---

## Changing the Project Name

The project slug is set to `private-funnel` by default. To use a different name, open `setup-deployment-funnel.sh` and edit this line near the top:

```bash
PROJECT_SLUG="private-funnel"
```

Change it to whatever you like, then run the setup script again.

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

---

## File Overview

```
cloudflare-funnel-starter/
├── setup-deployment-funnel.sh   ← THE script — run this once to get started
├── demo-site/                   ← Sample HTML used if you don't pick a folder
└── README.md
```

> All you need is `setup-deployment-funnel.sh`. The rest is here for reference.
