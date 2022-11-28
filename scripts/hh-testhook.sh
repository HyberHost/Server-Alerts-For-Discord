#!/bin/bash
# This script is provided with "No License" therefore using, modifying and the distribution of this script is not permitted without authorization from the rights holder(s).
# © 2021-2022 Steven Smith (all rights reserved)

source /etc/hh-config.sh

client="${SSH_CLIENT%% *}"
  /etc/stevescripts/discord.sh \
  --webhook-url="$webhook_url" \
  --username "$webhook_username" \
  --avatar "$webhook_avatar" \
  --description "Manual Test Alert!" \
  --title "Manual Test Alert!" \
  --field "Host;$server_name ($ip)" \
  --author "@Steven#7194's Server Alerts" \
  --author-url "https://github.com/IGSteven" \
  --author-icon "https://avatars.githubusercontent.com/u/22038054" \
  --footer "$webhook_footer"
