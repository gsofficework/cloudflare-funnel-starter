# Cloudflare Deployment Funnel Starter

Launch static experiments on Cloudflare Pages with a single command. This starter gives you:

- `setup-deployment-funnel.sh` – guided installer that sets up Wrangler, authenticates, creates (or reuses) a Pages project, and generates a reusable helper script.
- `demo-site/` – minimal HTML you can deploy immediately or replace with your own files.

---

## 1. Requirements

- macOS/Linux shell with `bash`, `git`, **Node.js (npm)** on PATH  
  - macOS: `brew install node`  
  - Linux: `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs`  
  - Windows / other: install via nvm or https://nodejs.org
- Cloudflare account with Pages permissions + a browser for Wrangler OAuth.

---

## 2. Install & Configure

Clone the repo wherever you keep projects, then run the guided setup:

```bash
git clone https://github.com/you/cloudflare-funnel-starter.git
cd cloudflare-funnel-starter

chmod +x setup-deployment-funnel.sh
./setup-deployment-funnel.sh
```

You’ll answer three prompts (press Enter to accept the suggested default):

| Prompt | What to type | Default |
| --- | --- | --- |
| Project slug | Name of the Pages project → `https://<slug>.pages.dev` | `private-funnel` |
| Directory to deploy | Absolute path to the folder you want uploaded; missing paths get seeded with `demo-site/` | `./demo-site` |
| Helper script path | Full path to the helper script the installer will create (you run this file—e.g., `/path/to/publishfunnel.sh`) | `./publishfunnel.sh` |

If Wrangler isn’t logged in, it opens a browser window after the prompts so you can authorize the CLI.

During setup it will:

- Install `wrangler` globally via npm when absent.
- Log in with `wrangler login` when no session exists.
- Create or reuse the Pages project.
- Generate the helper script and make it executable.
- Print the helper location (default `./publishfunnel.sh`) so you can deploy in one command later.

---

## 3. Deploy

After setup you’re prompted to run the helper immediately (type `y` to deploy on the spot, or Enter to skip). You can also run it later:

```bash
./publishfunnel.sh                         # uses the defaults chosen during setup
./publishfunnel.sh my-project /path/to/site   # override project + directory
```

Each run zips the target directory, uploads it, and prints both the preview URL and canonical `https://<project>.pages.dev`. Use Cloudflare Access if you need password/SSO gating.

---

## 4. Update Content

Edit files inside your configured site directory (the default `demo-site/index.html` is a simple "Hello" page). Whenever you save changes, execute `publishfunnel` again to push a fresh deployment. Pages retains the previous build, so you can delete local files without affecting the last published version.

---

## 5. Troubleshooting

- **Wrangler install/auth errors** – ensure Node.js + npm work (`node -v`, `npm -v`), then rerun `npm install -g wrangler` or the setup script.
- **Project already exists** – the script ignores the creation error and continues; just make sure you picked the right project slug.
Feel free to customize the helper script or README to fit your workflow.

---

## 6. Example Flow

1. `git clone https://github.com/you/cloudflare-funnel-starter.git && cd cloudflare-funnel-starter`
2. `./setup-deployment-funnel.sh`  
   - Respond `demo-app` for the slug, `/Users/you/sites/demo-app` for the directory, `/Users/you/bin/publishfunnel.sh` for the helper path.
3. Edit `/Users/you/sites/demo-app/index.html`.
4. Run `/Users/you/bin/publishfunnel.sh` to deploy. Cloudflare prints preview + canonical URLs in a few seconds.
