# Turnkey setup for Ubuntu or macOS

Usage:
```
git clone https://github.com/budmc29/machine-fresh-install.git && ./machine-fresh-install/machine_fresh_install.bash
```
After set-up is complete:
- Set ZSH as default shell
  - Terminal -> Preference -> New Profile -> Command and use `/usr/bin/zsh`
- Fix Mac Ventura tmux prefix override
  - Settings > Customise modifier keys > Input sources > uncheck anything using `^Space`
- Install Tmux plugins by doing `Prefix (Ctl + Space) + I`
- Install Vim Plugins with `PluginInstall`

Notes:
- On Ubuntu the script uses `apt` to install prerequisites.
- On macOS the script relies on Homebrew (it will be installed automatically if missing).
