# Turnkey setup for Ubuntu 16.04 machine

Usage:
```
sudo apt-get install git -y && cd ~ && git clone https://github.com/budmc29/ubuntu-fresh-install.git && ./ubuntu-fresh-install/ubuntu_fresh_install.bash
```

Notes:
Fetch all the ssh keys needed
- Fetch .private_work_aliases
- Clone all the /personal and /work repos
- Edit the specific computer's config file ".hostname_pc.config"
- Open lxappearance and set SFNS Display as the default font"

Set up multiple screens by adding the set-up the xrandr command in `~/.i3/hostname.config` then running `./i3_config_merge.bash` in the same folder.
