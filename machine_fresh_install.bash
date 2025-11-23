#!/usr/bin/env bash

# Script to install all the required programs and configurations for
# a fresh Mac

set -o nounset
set -o errexit

user=$(whoami)

apt_install_if_missing() {
  local package=$1
  if dpkg -s "$package" >/dev/null 2>&1; then
    echo "$package already installed"
    return
  fi

  sudo apt-get install "$package"
}

main() {
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
    sudo mkdir -p "$dirname"
  done

  touch "$HOME/.private_work_aliases"

  sudo chmod 777 -R ~/.vim/undo ~/.vim/swap

  echo "Directories created"
}

prepare_dotfiles() {
  rm -rf ~/buds-dotfiles

  git clone --single-branch git@github.com:budmc29/buds-dotfiles.git ~/buds-dotfiles

  rm -rf ~/buds-dotfiles/.git
  cp -r ~/buds-dotfiles/. ~/ && sudo rm -rf ~/.git

  echo "Dotfiles added"
}

install_programs() {
  apt_install_if_missing tmux
  # install_fonts
  apt_install_if_missing silversearcher-ag
  apt_install_if_missing zsh
  apt_install_if_missing vim
  apt_install_if_missing wget
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
  sudo rm -rf /home/$user/.oh-my-zsh

  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  local zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
  local syntax_dir="$zsh_custom/plugins/zsh-syntax-highlighting"
  sudo rm -rf "$syntax_dir"
  mkdir -p "$zsh_custom/plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_dir"

  echo "Oh My Zsh installed"
}

plugins_setup() {
  # Vundle plugin manager for vim
  local vundle_dir="$HOME/.vim/bundle/Vundle.vim"
  if [ -d "$vundle_dir/.git" ]; then
    sudo git -C "$vundle_dir" pull --ff-only
  else
    sudo git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
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
  sudo vim +PluginInstall +qall
}


main "$@"
