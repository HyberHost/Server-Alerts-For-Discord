#!/bin/bash
# This script is provided with "No License" therefore using, modifying and the distribution of this script is not permitted without authorization from the rights holder(s).
# © 2021-2022 Steven Smith (all rights reserved)

source /etc/hh-config.sh

cat <<EOF

SpeedTest Running - Please wait for results!
EOF

# Run the test
results=$(speedtest -f json > /var/log/latest-speedtest.json)

# Parse generated json file
Download="$(expr $(jq '.download.bytes' /var/log/latest-speedtest.json) / 1000000) MB/s"
Upload="$(expr $(jq '.upload.bytes' /var/log/latest-speedtest.json) / 1000000) MB/s"
Latency="$(jq '.ping.latency' /var/log/latest-speedtest.json) ms"
Full="$(jq --raw-output '.result.url' /var/log/latest-speedtest.json)"
Sponsor="$(jq '.server.name' /var/log/latest-speedtest.json)"

# Send Webhook
if [ speedtest_alerts ]; then
client="${SSH_CLIENT%% *}"
  /etc/stevescripts/discord.sh \
  --webhook-url="$webhook_url" \
  --username "$webhook_username" \
  --avatar "$webhook_avatar" \
  --description "Speedtest Alert!" \
  --title "New Speedtest Result on $server_name ($ip)" \
  --field "Download;$Download" \
  --field "Upload;$Upload" \
  --field "Latency;$Latency" \
  --field "Full Speedtest Result;$Full;false" \
  --field "Sponsor;$Sponsor;false" \
  --author "@Steven#7194's Server Alerts" \
  --author-url "https://github.com/IGSteven" \
  --author-icon "https://avatars.githubusercontent.com/u/22038054" \
  --footer "$webhook_footer"
fi

#print to console
cat <<EOF
Download Speed: $Download
Upload Speed: $Upload
Latency: $Latency ms
Full Result: $Full
Speedtest Sponsor: $Sponsor
EOF
