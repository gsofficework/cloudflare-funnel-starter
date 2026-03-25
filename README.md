# Cloudflare Deployment Funnel Starter

Spin up a "one command" static-site deployment to Cloudflare Pages. This repo contains:

- `setup-deployment-funnel.sh` – interactive setup that installs/configures Wrangler, creates a Pages project, drops a reusable `publishfunnel` helper, and wires an alias into `~/.zshrc`.
- `demo-site/` – a simple HTML scaffold copied into your selected deployment directory if it does not already exist.

## Prerequisites

- macOS/Linux shell with `bash`, `git`, **Node.js (includes npm)** on the PATH  
  - macOS: `brew install node`  
  - Linux: `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs`  
  - Windows / other: use nvm or download from https://nodejs.org
- Cloudflare account with permission to create Pages projects
- Ability to authenticate in a browser (Wrangler uses OAuth login)

## Quick Start

```bash
# 1. Clone and enter the starter
cd ~/Sites/ai-agents-workspace
git clone https://github.com/you/cloudflare-funnel-starter.git
cd cloudflare-funnel-starter

# 2. Run the guided setup
chmod +x setup-deployment-funnel.sh
./setup-deployment-funnel.sh
```

During setup you’ll answer three guided prompts (press Enter to accept the default shown in brackets):

1. **Project slug** – becomes the URL `https://<slug>.pages.dev`. Provide an existing slug to reuse it or type a new slug to auto-create the project.
2. **Absolute directory to deploy** – the local folder that holds your HTML/CSS/JS. If it doesn’t exist, the demo site is copied there.
3. **Helper script path** – where the reusable deployment script lives (you’ll run this file or use the alias later).

During setup it will:

- Install `wrangler` globally via npm if it is missing.
- Log in with `wrangler login` when no session exists.
- Create or reuse the Pages project.
- Generate the helper script and make it executable.
- Append `alias publishfunnel='<helper-path>'` to `~/.zshrc` (only once).

After setup the script prints the full path to your helper (default `./publishfunnel.sh`). Run it directly from any shell:

```bash
./publishfunnel.sh                         # uses the defaults chosen during setup
./publishfunnel.sh my-project /path/to/site   # override project + directory
```

If you use `zsh`, the installer also appends `alias publishfunnel='<helper-path>'` to `~/.zshrc`; sourcing that file lets you keep using the short command, but it’s optional.

Each run zips the target directory, uploads it to Cloudflare Pages, and prints both the preview URL and canonical `https://<project>.pages.dev`. Apply Cloudflare Access rules to that domain whenever you need password/SSO gating.

## Updating the Demo

Edit files inside your configured site directory (the default `demo-site/index.html` is a simple "Hello" page). Whenever you save changes, execute `publishfunnel` again to push a fresh deployment. Pages retains the previous build, so you can delete local files without affecting the last published version.

## Troubleshooting

- **Wrangler install/auth errors** – ensure Node.js + npm are installed (`node -v`, `npm -v` should work), then rerun `npm install -g wrangler` or the setup script.
- **Project already exists** – the script ignores the creation error and continues; just make sure you picked the right project slug.
- **Alias not found** – verify `publishfunnel` appears in `~/.zshrc`, then `source ~/.zshrc` or start a new shell.

Feel free to customize the helper script or README to fit your workflow. EOF
