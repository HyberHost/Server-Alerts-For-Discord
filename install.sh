if [ -z "$BASH_VERSION" ]; then
  if command -v bash >/dev/null 2>&1; then
    exec bash "$0" "$@"
  else
    echo "This script requires bash. Please install bash and run with bash $0"
    exit 1
  fi
fi
#!/usr/bin/env bash

set -euo pipefail

echo "Installing Discord SSH alert dependencies..."

REQUIRED_CMDS=(curl jq hostname awk)

missing_cmds=()
for cmd in "${REQUIRED_CMDS[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || missing_cmds+=("$cmd")
done


# Only install dependencies if missing, but always continue with the rest of the script
if (( ${#missing_cmds[@]} == 0 )); then
  echo "All dependencies already installed."
else
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

# Download main alert script
curl -fsSL \
  https://raw.githubusercontent.com/HyberHost/Server-Alerts-For-Discord/main/discord-alert.sh \
  -o "$INSTALL_DIR/discord-alert.sh"
chmod +x "$INSTALL_DIR/discord-alert.sh"

# Download discord.sh dependency
curl -fsSL \
  https://raw.githubusercontent.com/fieu/discord.sh/master/discord.sh \
  -o "$INSTALL_DIR/discord.sh"
chmod +x "$INSTALL_DIR/discord.sh"


# Prompt for Discord webhook URL (interactive) or require env var (non-interactive)
if [ -t 0 ]; then
  read -rp "Enter your Discord webhook URL: " DISCORD_WEBHOOK_URL
elif [ -n "${DISCORD_WEBHOOK_URL:-}" ]; then
  echo "Using webhook from DISCORD_WEBHOOK_URL environment variable."
else
  echo "Non-interactive shell detected. Please set DISCORD_WEBHOOK_URL environment variable or manually edit $INSTALL_DIR/webhook_url.conf."
  DISCORD_WEBHOOK_URL=""
fi

if [[ -n "$DISCORD_WEBHOOK_URL" ]]; then
  echo "$DISCORD_WEBHOOK_URL" > "$INSTALL_DIR/webhook_url.conf"
fi

echo "Installation complete."
echo "discord-alert.sh installed to $INSTALL_DIR/discord-alert.sh"

echo "Webhook URL saved to $INSTALL_DIR/webhook_url.conf"

# Send a test alert
if [[ -n "$DISCORD_WEBHOOK_URL" ]]; then
  echo "Sending test alert to Discord webhook..."
  "$INSTALL_DIR/discord-alert.sh" || echo "Test alert failed. Please check your webhook URL and network connectivity."
fi

# Prompt for integration target (interactive only)
if [ -t 0 ]; then
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
else
  echo "Non-interactive shell detected. To integrate, add this line to /etc/ssh/sshrc or ~/.bashrc manually:"
  echo "$INSTALL_DIR/discord-alert.sh"
fi