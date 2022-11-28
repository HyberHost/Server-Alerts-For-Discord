#!/bin/bash
# This script is provided with "No License" therefore using, modifying and the distribution of this script is not permitted without authorization from the rights holder(s).
# © 2021-2022 Steven A. Smith (all rights reserved)

# Servers Wan IP:
server_ip="$(dig @resolver4.opendns.com myip.opendns.com +short)"
# Server Name to help identify it
server_name=''

# Is the server protected, if so use values below to set protected ip:
protected=false
protected_ip=''

# Discord WebHook:
webhook_url=''
webhook_avatar=''
webhook_username='$server_name'
webhook_footer='HyberHost Server Alerts'

# This can be ignored - just used to add a prefix to all the commands
cat <<'EOF'
__   __  __   __  _______  _______  ______    __   __  _______  _______  _______ 
|  | |  ||  | |  ||  _    ||       ||    _ |  |  | |  ||       ||       ||       |
|  |_|  ||  |_|  || |_|   ||    ___||   | ||  |  |_|  ||   _   ||  _____||_     _|
|       ||       ||       ||   |___ |   |_||_ |       ||  | |  || |_____   |   |  
|       ||_     _||  _   | |    ___||    __  ||       ||  |_|  ||_____  |  |   |  
|   _   |  |   |  | |_|   ||   |___ |   |  | ||   _   ||       | _____| |  |   |  
|__| |__|  |___|  |_______||_______||___|  |_||__| |__||_______||_______|  |___|  
EOF
