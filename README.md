
# Server Alerts for Discord

This project is licensed under the [GNU General Public License v3.0](LICENSE). You are free to fork, modify, and contribute under the terms of this open-source license.


> **⚠️ WARNING: This script is unmaintained!**
>
> This repository is unmaintained. It was updated once after 3 years to remove our branding and simplify usage. No further updates or support will be provided.
>
> **Interested in maintaining this project?**
> If you would like to take over maintenance (on a volunteer basis, as we no longer use this), please contact us!

---


## Quick Install

Run this one-liner to install and configure:

```sh
curl -fsSL https://raw.githubusercontent.com/HyberHost/Server-Alerts-For-Discord/main/install.sh | bash
# or
wget -qO- https://raw.githubusercontent.com/HyberHost/Server-Alerts-For-Discord/main/install.sh | bash
```

## How to Use `discord-alert.sh`

1. **Set your Discord Webhook URL**
	- Edit `discord-alert.sh` and set the `DISCORD_WEBHOOK_URL` variable to your Discord webhook.

2. **Make the script executable**
	- `chmod +x discord-alert.sh`

3. **(Optional) Download `discord.sh` dependency**
	- The script will attempt to download `discord.sh` automatically if not present.
	- Or, manually download from: https://github.com/fieu/discord.sh

4. **Run the script**
	- `./discord-alert.sh`

5. **Setup Symolic Link to automatically trigger the script on login**
    - `ln /scripts/discord-alert.sh /etc/profile.d/discord-alert.sh`