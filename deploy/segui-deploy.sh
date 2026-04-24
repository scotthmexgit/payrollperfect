#!/usr/bin/env bash
# segui-deploy.sh — build + deploy to /var/www/payrollperfect/ (LAN dev preview)
# Requires: Node 22+ via nvm
# Requires: /var/www/payrollperfect/ owned by seadmin (set once via sudo)
set -euo pipefail

cd "$(dirname "$0")/.."

# Ensure Node is active (nvm)
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  \. "$NVM_DIR/nvm.sh"
  nvm use --silent || nvm install
fi

echo "→ Building..."
npm run build

echo "→ Deploying to /var/www/payrollperfect/..."
# No sudo needed — seadmin owns the directory.
rm -rf /var/www/payrollperfect/*
rm -rf /var/www/payrollperfect/.[!.]* 2>/dev/null || true  # dotfiles, if any
cp -r dist/. /var/www/payrollperfect/
find /var/www/payrollperfect/ -type d -exec chmod 755 {} \;
find /var/www/payrollperfect/ -type f -exec chmod 644 {} \;

echo "→ Verifying..."
STATUS=$(curl -sI http://192.168.68.238/payrollperfect/ | head -1)
echo "  LAN: $STATUS"

echo "✓ Deployed. Preview at http://192.168.68.238/payrollperfect/"
