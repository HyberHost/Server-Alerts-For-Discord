#!/usr/bin/env bash

set -euo pipefail

echo "Installing Discord SSH alert dependencies..."

REQUIRED_CMDS=(curl jq hostname awk)

missing_cmds=()
for cmd in "${REQUIRED_CMDS[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || missing_cmds+=("$cmd")
done

if (( ${#missing_cmds[@]} == 0 )); then
  echo "All dependencies already installed."
  exit 0
fi

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This installer must be run as root."
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  echo "Using apt"
  apt-get update
  apt-get install -y curl jq coreutils
elif command -v dnf >/dev/null 2>&1; then
  echo "Using dnf"
  dnf install -y curl jq coreutils gawk
else
  echo "ERROR: Unsupported package manager (apt or dnf required)"
  exit 1
fi

echo "Downloading Server-Alerts-For-Discord script from GitHub..."

INSTALL_DIR="/opt/discord-alert"
mkdir -p "$INSTALL_DIR"

curl -fsSL \
  https://raw.githubusercontent.com/HyberHost/Server-Alerts-For-Discord/main/discord-alert.sh \
  -o "$INSTALL_DIR/discord-alert.sh"

chmod +x "$INSTALL_DIR/discord-alert.sh"

# Prompt for Discord webhook URL
read -rp "Enter your Discord webhook URL: " DISCORD_WEBHOOK_URL
echo "$DISCORD_WEBHOOK_URL" > "$INSTALL_DIR/webhook_url.conf"

echo "Installation complete."
echo "discord-alert.sh installed to $INSTALL_DIR/discord-alert.sh"
echo "Webhook URL saved to $INSTALL_DIR/webhook_url.conf"

# Prompt for integration target
echo "Where do you want to trigger the alert script?"
echo "1) On SSH login for all users (/etc/ssh/sshrc)"
echo "2) On shell start for current user (~/.bashrc)"
read -rp "Enter 1 or 2: " INTEGRATION_CHOICE

if [[ $INTEGRATION_CHOICE == "1" ]]; then
  echo "$INSTALL_DIR/discord-alert.sh" >> /etc/ssh/sshrc
  echo "Added to /etc/ssh/sshrc (requires root, triggers on SSH login for all users)."
elif [[ $INTEGRATION_CHOICE == "2" ]]; then
  echo "$INSTALL_DIR/discord-alert.sh" >> "$HOME/.bashrc"
  echo "Added to ~/.bashrc (triggers on shell start for current user)."
else
  echo "No integration performed."
fi