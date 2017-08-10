# Install needed programs on a ubuntu 14.04 machine

Usage:
```
sudo apt-get install git -y && cd ~ && git clone https://github.com/budmc29/ubuntu-fresh-install.git && ./ubuntu-fresh-install/ubuntu-fresh-install.bash
```

Notes:
Fetch all the ssh keys needed
- Fetch .private_work_aliases
- Clone all the /personal and /work repos

open tmux and:
```
<prefix>I
```

Set up multiple screens by adding the set-up the xrandr command in `~/.i3/hostname.config` then running `./i3_config_merge.bash` in the same folder.
