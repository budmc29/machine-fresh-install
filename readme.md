# Turnkey setup for Ubuntu or macOS

Usage:
```
./machine-fresh-install.sh
```

## After Setup

### Both Platforms
- Install Tmux plugins: `Prefix (Ctrl + Space) + I`
- Install Vim plugins: `:PluginInstall`

### Ubuntu
- Set ZSH as default shell:
  - Terminal → Preferences → New Profile → Command → use `/usr/bin/zsh`

### macOS
- **Use iTerm2** (installed by the script):
  - Open iTerm2 and go to **iTerm2 → Settings → Profiles**
  - Select "**JetBrains Darcula**" from the list (automatically installed)
  - Click **Other Actions... → Set as Default**
- **Fix Ctrl+Space conflict with tmux prefix:**
  - macOS uses Ctrl+Space for input source switching (you'll see an "A" icon toggling)
  - Go to **System Settings → Keyboard → Keyboard Shortcuts... → Input Sources**
  - Uncheck "Select the previous input source" and "Select next source in input menu"
  - This allows Ctrl+Space to pass through to tmux
- **Grant clipboard access to iTerm2:**
  - Go to **System Settings → Privacy & Security → Accessibility**
  - Add and enable iTerm2
  - This allows tmux-yank and other tools to access the system clipboard

## Notes
- On Ubuntu the script uses `apt` to install prerequisites.
- On macOS the script relies on Homebrew (it will be installed automatically if missing).
