#!/bin/bash
# This script is provided with "No License" therefore using, modifying and the distribution of this script is not permitted without authorization from the rights holder(s).
# © 2021-2022 Steven Smith (all rights reserved)

source /etc/hh-config.sh

if [ login_alerts ]; then
client="${SSH_CLIENT%% *}"
  /etc/stevescripts/discord.sh \
  --webhook-url="$webhook_url" \
  --username "$webhook_username" \
  --avatar "$webhook_avatar" \
  --description "SSH Login Alert!" \
  --title "New Login Alert!" \
  --field "Host;$server_name ($ip)" \
  --field "User;$(whoami)" \
  --field "Client IP;$client" \
  --author "@Steven#7194's Shell Script" \
  --author-url "https://github.com/IGSteven" \
  --author-icon "https://avatars.githubusercontent.com/u/22038054" \
  --footer "$webhook_footer"
fi
