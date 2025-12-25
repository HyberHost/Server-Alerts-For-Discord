#!/usr/bin/env bash

set -euo pipefail

# =====================
# Configuration
# =====================
DISCORD_WEBHOOK_URL=""   # REQUIRED

# Try to read webhook URL from config if not set
WEBHOOK_CONF="/opt/discord-alert/webhook_url.conf"
if [[ -z "$DISCORD_WEBHOOK_URL" && -f "$WEBHOOK_CONF" ]]; then
  DISCORD_WEBHOOK_URL="$(<"$WEBHOOK_CONF")"
fi
DISCORD_WEBHOOK_USERNAME="Server Alert Bot"

DISCORD_SH="/opt/discord-alert/discord.sh"

# =====================
# Validation
# =====================
if [[ -z "$DISCORD_WEBHOOK_URL" ]]; then
  exit 0
fi

if [[ ! -x "$DISCORD_SH" ]]; then
  exit 0
fi

# =====================
# Server details
# =====================
SERVER_HOSTNAME="$(hostname)"
SERVER_LAN="$(hostname -I 2>/dev/null | awk '{print $1}' || echo "Unknown")"
SERVER_WAN="$(curl -fsS https://api.ipify.org || echo "Unknown")"

SSH_CLIENT_IP="${SSH_CLIENT%% *}"
[[ -z "$SSH_CLIENT_IP" ]] && SSH_CLIENT_IP="N/A"

# =====================
# Send Discord alert
# =====================
"$DISCORD_SH" \
  --webhook-url "$DISCORD_WEBHOOK_URL" \
  --username "$DISCORD_WEBHOOK_USERNAME" \
  --title "New SSH Login Alert" \
  --description "SSH login detected" \
  --field "Hostname;$SERVER_HOSTNAME;false" \
  --field "WAN IP;$SERVER_WAN;false" \
  --field "LAN IP;$SERVER_LAN;false" \
  --field "User;$(whoami) - IP: $SSH_CLIENT_IP;false" \
  --author "Server Alert Bot" \
  >/dev/null 2>&1 || true
