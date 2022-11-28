## How to Setup

### Install Speedtest
```
sudo apt-get install curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
```
We then need to run `speedtest` as we have to manually accept the TOS once in order for this to work.


### Login Alerts
We need to make a Symolic Link for this to work correctly
```
ln /scripts/hh-login.sh /etc/profile.d/hh-login.sh
```

### Setup CronJobs
Create a cronjob **AS ROOT**
```
20 16 * * 2,5 sh /scripts/hh-speedtest.sh
```

### Permissions
We need to set the following so all user can run the files
```
chmod 771 /etc/hh-config.sh
chmod 771 /scripts/hh-login.sh
chmod 771 /scripts/hh-discord.sh
```


---
**Ubuntu Bug!**
Ubuntu replaces /bin/bash with /bin/bash, we need to disable this 

Run this command and select "NO"
```
sudo dpkg-reconfigure -plow dash
```
