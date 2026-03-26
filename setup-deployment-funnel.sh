#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_SLUG="private-funnel"
DEFAULT_SITE_DIR="$(pwd)"
DEFAULT_HELPER_PATH="$SCRIPT_DIR/publishfunnel.sh"
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
echo "Step 2: Pick where the reusable helper script should live."
echo "  - You will run this script later to deploy in one command."
echo "  - It can live inside this repo or anywhere on disk."
echo "  - Press Enter to keep it here (publishfunnel.sh)."
read -r -p "Helper script path [$DEFAULT_HELPER_PATH]: " HELPER_PATH
HELPER_PATH=${HELPER_PATH:-$DEFAULT_HELPER_PATH}

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

cat <<'SCRIPT' > "$HELPER_PATH"
#!/usr/bin/env bash
set -euo pipefail
project="${1:-PROJECT_PLACEHOLDER}"
site_dir="${2:-SITE_PLACEHOLDER}"
if [ ! -d "$site_dir" ]; then
  echo "Directory $site_dir does not exist" >&2
  exit 1
fi
echo "Deploying directory: $site_dir"
pushd "$site_dir" >/dev/null
wrangler pages deploy . --project-name="$project" --commit-dirty=true
popd >/dev/null
echo "Deployed $site_dir to https://$project.pages.dev (check Cloudflare dashboard for Access policies)"
SCRIPT

python3 <<PY
from pathlib import Path
path = Path(r"$HELPER_PATH")
data = path.read_text()
data = data.replace("PROJECT_PLACEHOLDER", r"$PROJECT_NAME").replace("SITE_PLACEHOLDER", r"$SITE_DIR")
path.write_text(data)
PY
chmod +x "$HELPER_PATH"

echo "Setup complete. You can deploy $SITE_DIR to https://$PROJECT_NAME.pages.dev using $HELPER_PATH."
read -r -p "Run it now? [y/N]: " RUN_NOW
case "$RUN_NOW" in
  [yY][eE][sS]|[yY])
    "$HELPER_PATH"
    ;;
  *)
    echo "Skipping automatic deploy. Run '$HELPER_PATH' later when ready."
    ;;
esac
