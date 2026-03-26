#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_SLUG="private-funnel"
DEFAULT_SITE_DIR="$(pwd)"
TEMPLATE_SITE_DIR="$SCRIPT_DIR/demo-site"

echo "Cloudflare Deployment Funnel Setup"
echo "----------------------------------"
echo "Project slug is fixed to '$PROJECT_SLUG' (edit this script if you need another)."
echo "You will choose a local folder to deploy and where to store the helper script."
echo "If you are not already logged in with Wrangler, this script will open a browser window later to authenticate."

PROJECT_NAME=$PROJECT_SLUG

echo
echo "Step 1: Tell me which local folder to deploy."
echo "  - Provide an absolute path (e.g., /Users/you/sites/demo)."
echo "  - If the folder is missing, a copy of demo-site/ will be created there."
echo "  - Press Enter to use your current directory ($(pwd))."
read -r -p "Absolute path to deploy [$DEFAULT_SITE_DIR]: " SITE_DIR
SITE_DIR=${SITE_DIR:-$DEFAULT_SITE_DIR}
echo "Selected directory: $SITE_DIR"

echo
if [ ! -d "$SITE_DIR" ]; then
  echo "Creating site directory at $SITE_DIR"
  mkdir -p "$SITE_DIR"
  cp -R "$TEMPLATE_SITE_DIR/." "$SITE_DIR" 2>/dev/null || true
fi

if ! command -v node >/dev/null 2>&1; then
  cat >&2 <<'MSG'
[setup] Node.js is required to install Wrangler.
- macOS (Homebrew):    brew install node
- Linux (Debian/Ubuntu): curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs
- Windows / other shells: install from https://nodejs.org or use nvm (https://github.com/nvm-sh/nvm)
After Node.js + npm are available, re-run this script.
MSG
  exit 1
fi

if ! command -v wrangler >/dev/null 2>&1; then
  if ! command -v npm >/dev/null 2>&1; then
    echo "[setup] npm was not found on PATH; install Node.js + npm before continuing." >&2
    exit 1
  fi
  echo "Installing Cloudflare Wrangler CLI via npm..."
  npm install -g wrangler
fi

if ! wrangler whoami >/dev/null 2>&1; then
  echo "Logging into Cloudflare via wrangler..."
  wrangler login
fi

wrangler pages project create "$PROJECT_NAME" --production-branch main >/dev/null 2>&1 ||   echo "Project $PROJECT_NAME may already exist. Continuing."

echo "Deploying directory: $SITE_DIR"
pushd "$SITE_DIR" >/dev/null
wrangler pages deploy . --project-name="$PROJECT_NAME" --commit-dirty=true
popd >/dev/null
echo "Deployed $SITE_DIR to https://$PROJECT_NAME.pages.dev (check Cloudflare dashboard for Access policies)"

echo
echo "To deploy changes in the future, rerun ./setup-deployment-funnel.sh from this folder (or copy it elsewhere and run it there)."
