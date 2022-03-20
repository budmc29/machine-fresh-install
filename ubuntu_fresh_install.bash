#!/usr/bin/env bash

# Script to install all the required programs and configurations for
# a fresh Mac

set -o nounset
set -o errexit

user=$(whoami)

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

  echo "Directories created"
}

prepare_dotfiles() {
  rm -rf ~/buds-dotfiles

  git clone --single-branch --branch mac git@github.com:budmc29/buds-dotfiles.git ~/buds-dotfiles

  rm -rf ~/buds-dotfiles/.git
  cp -r ~/buds-dotfiles/ ~/

  echo "Dotfiles added"
}

install_tmux() {
  brew install tmux
}

install_programs() {
  install_tmux
  install_fonts

  brew install ag
  brew install wget
}

install_fonts() {
  version=1.010

  rm -f SourceCodePro_FontsOnly-$version.zip
  rm -rf SourceCodePro_FontsOnly-$version

  wget https://github.com/downloads/adobe/source-code-pro/SourceCodePro_FontsOnly-$version.zip

  unzip SourceCodePro_FontsOnly-$version.zip
  mkdir -p ~/.fonts

  sudo cp SourceCodePro_FontsOnly-$version/OTF/*.otf ~/.fonts/

  rm -rf SourceCodePro_FontsOnly*

  # Install San Francisco font system wide
  wget https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
  unzip master.zip
  rm master.zip*

  # Move to system fonts
  mv Yo*/*.ttf ~/.fonts
  rm -rf Yo*

  echo "Fonts installed"
}

zsh_setup() {
  rm -rf /home/$user/.oh-my-zsh

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  # sudo chsh -s "$(which zsh)"

  sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo "Oh My Zsh installed"
}

plugins_setup() {
  # Vundle plugin manager for vim
  # sudo git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # Tmux plugins
  # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # chmod -R 777 ~/.tmux

  # Vim plugins
  vim +PluginInstall +qall
}


main "$@"
