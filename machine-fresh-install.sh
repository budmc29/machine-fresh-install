#!/usr/bin/env bash

# Script to install all the required programs and configurations for
# a fresh Mac

set -o nounset
set -o errexit

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

user=$(whoami)
user_group=$(id -gn "$user")
os_type=""

detect_os() {
  case "$(uname -s)" in
    Linux*)
      os_type="ubuntu"
      ;;
    Darwin*)
      os_type="macos"
      ;;
    *)
      echo "Unsupported operating system. This script works on Ubuntu or macOS only."
      exit 1
      ;;
  esac
}

apt_install_if_missing() {
  local package=$1
  if dpkg -s "$package" >/dev/null 2>&1; then
    echo "$package already installed"
    return
  fi

  sudo apt-get install "$package"
}

ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo "Homebrew installation failed."
    exit 1
  fi
}

brew_install_if_missing() {
  local package=$1
  ensure_brew
  if brew list --versions "$package" >/dev/null 2>&1; then
    echo "$package already installed"
    return
  fi

  brew install "$package"
}

ensure_default_editor() {
  local vim_path
  vim_path=$(command -v vim || true)

  if [ -z "$vim_path" ]; then
    echo "vim not found on PATH; skipping default editor configuration"
    return
  fi

  touch "$HOME/.profile"

  if ! grep -qs "export EDITOR=$vim_path" "$HOME/.profile"; then
    echo "export EDITOR=$vim_path" >> "$HOME/.profile"
  fi

  if ! grep -qs "export VISUAL=$vim_path" "$HOME/.profile"; then
    echo "export VISUAL=$vim_path" >> "$HOME/.profile"
  fi
}

main() {
  detect_os
  create_resources
  install_programs
  plugins_setup
  zsh_setup
  prepare_dotfiles

  echo "---------------------------------------------------------------"
  echo "---------------------------------------------------------------"
  echo "Follow the instructions in Readme to complete the setup"
  echo "---------------------------------------------------------------"
  echo "---------------------------------------------------------------"

  exit 0
}

create_resources() {
  DIRS=(
    "$HOME/.vim/undo"
    "$HOME/.vim/bundle"
    "$HOME/.vim/swap"
    "$HOME/personal"
    "$HOME/work"
    "$HOME/projects"
  )

  for dirname in "${DIRS[@]}"; do
    mkdir -p "$dirname"
  done

  touch "$HOME/.private_work_aliases"

  chmod -R u+rwX ~/.vim/undo ~/.vim/swap

  echo "Directories created"
}

prepare_dotfiles() {
  local dotfiles_dir="$script_dir/dotfiles"

  if [ ! -d "$dotfiles_dir" ]; then
    echo "Dotfiles directory missing at $dotfiles_dir"
    exit 1
  fi

  # Copy standard dotfiles to home
  for item in "$dotfiles_dir"/.*; do
    [ -e "$item" ] || continue
    basename=$(basename "$item")
    [ "$basename" = "." ] || [ "$basename" = ".." ] && continue
    cp -r "$item" "$HOME/"
  done

  # Copy iTerm2 dynamic profiles on macOS
  if [ "$os_type" = "macos" ] && [ -d "$dotfiles_dir/iterm2/DynamicProfiles" ]; then
    local iterm_profiles_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$iterm_profiles_dir"
    cp -r "$dotfiles_dir/iterm2/DynamicProfiles/"* "$iterm_profiles_dir/"
    echo "iTerm2 profile installed"
  fi

  echo "Dotfiles added"
}

install_programs() {
  if [ "$os_type" = "ubuntu" ]; then
    install_programs_ubuntu
  else
    install_programs_macos
  fi

  ensure_default_editor
}

install_programs_ubuntu() {
  apt_install_if_missing tmux
  # install_fonts
  apt_install_if_missing silversearcher-ag
  apt_install_if_missing xclip
  apt_install_if_missing rbenv
  apt_install_if_missing zsh
  apt_install_if_missing vim
  apt_install_if_missing wget
}

brew_cask_install_if_missing() {
  local cask=$1
  ensure_brew
  if brew list --cask --versions "$cask" >/dev/null 2>&1; then
    echo "$cask already installed"
    return
  fi

  brew install --cask "$cask"
}

install_programs_macos() {
  brew_install_if_missing tmux
  brew_install_if_missing the_silver_searcher
  brew_install_if_missing xclip
  brew_install_if_missing rbenv
  brew_install_if_missing zsh
  brew_install_if_missing vim
  brew_install_if_missing wget
  brew_install_if_missing maccy
  brew_cask_install_if_missing iterm2
}

install_fonts() {
  wget https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/OTF-source-code-pro-2.042R-u_1.062R-i.zip

  unzip OTF-source-code-pro-2.042R-u_1.062R-i.zip
  mkdir -p ~/.fonts

  sudo cp OTF/*.otf /usr/local/share/fonts/

  rm -rf OTF*

  # Install San Francisco font system wide
  wget https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
  unzip master.zip
  rm master.zip*

  # Move to system fonts
  sudo mv Yo*/*.ttf /usr/local/share/fonts/
  rm -rf Yo*

  echo "Fonts installed"
}

zsh_setup() {
  local omz_dir="$HOME/.oh-my-zsh"
  if [ -d "$omz_dir" ]; then
    echo "Oh My Zsh already installed"
  else
    CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local zsh_custom=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
  local syntax_dir="$zsh_custom/plugins/zsh-syntax-highlighting"
  mkdir -p "$zsh_custom/plugins"
  if [ -d "$syntax_dir/.git" ]; then
    git -C "$syntax_dir" pull --ff-only
  else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_dir"
  fi

  local fast_dir="$zsh_custom/plugins/fast-syntax-highlighting"
  if [ -d "$fast_dir/.git" ]; then
    git -C "$fast_dir" pull --ff-only
  else
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$fast_dir"
  fi

  echo "Oh My Zsh installed"
}

plugins_setup() {
  # Vundle plugin manager for vim
  local vundle_dir="$HOME/.vim/bundle/Vundle.vim"
  if [ -d "$vundle_dir/.git" ]; then
    git -C "$vundle_dir" pull --ff-only
  else
    git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
  fi

  # Tmux plugins
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir/.git" ]; then
    git -C "$tpm_dir" pull --ff-only
  else
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
  chmod -R 777 ~/.tmux

  # Vim plugins
  vim +PluginInstall +qall
}


main "$@"
