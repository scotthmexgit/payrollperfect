#!/usr/bin/env bash
# segui-deploy.sh — build + deploy to /var/www/payrollperfect/ (LAN dev preview)
# Requires: Node 22+ via nvm, sudo access to /var/www/
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
sudo rm -rf /var/www/payrollperfect/*
sudo cp -r dist/. /var/www/payrollperfect/
sudo chown -R www-data:www-data /var/www/payrollperfect/  # adjust user:group if different
sudo find /var/www/payrollperfect/ -type d -exec chmod 755 {} \;
sudo find /var/www/payrollperfect/ -type f -exec chmod 644 {} \;

echo "→ Verifying..."
STATUS=$(curl -sI http://192.168.68.238/payrollperfect/ | head -1)
echo "  LAN: $STATUS"

echo "✓ Deployed. Preview at http://192.168.68.238/payrollperfect/"
