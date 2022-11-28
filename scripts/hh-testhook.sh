#!/bin/bash
# This script is provided with "No License" therefore using, modifying and the distribution of this script is not permitted without authorization from the rights holder(s).
# © 2021-2022 Steven Smith (all rights reserved)

source /etc/hh-config.sh

client="${SSH_CLIENT%% *}"
  /scripts/hh-discord.sh \
  --webhook-url="$webhook_url" \
  --username "$webhook_username" \
  --avatar "$webhook_avatar" \
  --description "Manual Test Alert!" \
  --title "Manual Test Alert!" \
  --field "Host;$server_name ($server_ip)" \
  --author "HyberHost Server Alerts" \
  --author-url "https://github.com/HyberHost/Server-Alerts-For-Discord" \
  --author-icon "https://avatars.githubusercontent.com/u/118968750" \
  --footer "$webhook_footer"
