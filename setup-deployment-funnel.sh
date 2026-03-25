#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PROJECT="private-funnel"
DEFAULT_SITE_DIR="$SCRIPT_DIR/demo-site"
DEFAULT_HELPER_PATH="$SCRIPT_DIR/publishfunnel.sh"

read -r -p "Cloudflare Pages project name [$DEFAULT_PROJECT]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT}

read -r -p "Directory to deploy (absolute path) [$DEFAULT_SITE_DIR]: " SITE_DIR
SITE_DIR=${SITE_DIR:-$DEFAULT_SITE_DIR}

read -r -p "Where should the helper script live? [$DEFAULT_HELPER_PATH]: " HELPER_PATH
HELPER_PATH=${HELPER_PATH:-$DEFAULT_HELPER_PATH}

if [ ! -d "$SITE_DIR" ]; then
  echo "Creating site directory at $SITE_DIR"
  mkdir -p "$SITE_DIR"
  cp -R "$DEFAULT_SITE_DIR/." "$SITE_DIR" 2>/dev/null || true
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
pushd "$site_dir" >/dev/null
wrangler pages deploy . --project-name="$project" --commit-dirty=true
popd >/dev/null
echo "Deployed to https://$project.pages.dev (check Cloudflare dashboard for Access policies)"
SCRIPT

python3 <<PY
from pathlib import Path
path = Path(r"$HELPER_PATH")
data = path.read_text()
data = data.replace("PROJECT_PLACEHOLDER", r"$PROJECT_NAME").replace("SITE_PLACEHOLDER", r"$SITE_DIR")
path.write_text(data)
PY
chmod +x "$HELPER_PATH"

ALIAS_LINE="alias publishfunnel='$HELPER_PATH'"
if ! grep -Fq "$ALIAS_LINE" "$HOME/.zshrc"; then
  echo "$ALIAS_LINE" >> "$HOME/.zshrc"
  echo "Added publishfunnel alias to ~/.zshrc (optional shortcut for zsh users)"
else
  echo "publishfunnel alias already present in ~/.zshrc"
fi

echo "Setup complete. Run '$HELPER_PATH' (or use the publishfunnel alias) to deploy $SITE_DIR to https://$PROJECT_NAME.pages.dev."
