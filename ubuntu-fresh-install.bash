#!/bin/bash

# TODO: check if dotfiles exists
# TODO: check all the dependencies
# TODO: select what to install?
# TODO: remember to display messages of confirmation
# TODO: install i3wm.bash
function main()
{

  prepare_repositories

  create_directories

  install_programs

  plugins_setup

  version_control_config

  zsh_setup

  prepare_dotfiles

}

function prepare_repositories()
{
  add-apt-repository ppa:pwr22/tomighty

  apt-get update  # To get the latest package lists
  apt-get upgrade  # To get the latest package lists
}

function create_directories()
{

  DIR_LIST=(
    "~/.vim/undo"
    "~/.vim/swap"
    "~/personal"
    "~/work"
    "~/projects"
  )

  for dirname in "${DIR_LIST[@]}"; do
    mkdir -m 777 dirname
  done

}

function install_rvm()
{
# install RVM
# key to verify the installed version
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable --ruby
}

function prepare_dotfiles()
{
  # copy dotfiles
  git clone https://github.com/budmc29/ubuntu-dotfiles ~/ubuntu-dotfiles
  # replace this with dotter command
  cp -rT ~/ubuntu-dotfiles/ ~/

  source ~/.zshrc

}

function install_tmux()
{

  # tmux 2.2
  VERSION=2.2
  if [[ $1 = local ]]; then
    echo 'Build "libevent-dev" and "libncurses-dev".' >&2
  else
    apt-get -y install libevent-dev libncurses-dev
    apt-get -y remove tmux
  fi
  wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
  tar xzf tmux-${VERSION}.tar.gz
  rm -f tmux-${VERSION}.tar.gz
  cd tmux-${VERSION}
  if [[ $1 = local ]]; then
  ./configure --prefix=$HOME/local
  make
  make install
  mkdir -p $HOME/local/src
  cd -
  rm -rf $HOME/local/src/tmux-*
  mv tmux-${VERSION} $HOME/local/src
  else
  ./configure
  make
  make install
  cd -
  rm -rf /usr/local/src/tmux-*
  mv tmux-${VERSION} /usr/local/src
  fi
}

function install_programs()
{
  apt-get install xclip -y
  apt-get install vlc -y
  apt-get install chromium-browser -y
  apt-get install imagemagick -y
  apt-get install filezilla -y
  apt-get install mysql-client-5.5 -y
  apt-get install mysql-client -y
  apt-get install mysql-server-5.5 -y
  apt-get install mysql-workbench -y
  apt-get install nodejs -y
  apt-get install apache2 -y
  apt-get install nginx -y
  apt-get install vim-gtk -y
  apt-get install silversearcher-ag -y
  apt-get install rxvt-unicode -y
  apt-get install tomighty -y

  `apt-get install clamav -y
  freshclam`

  dpkg -i ./skype-ubuntu-precise_4.3.0.37-1_i386.deb

  install_tmux

  install_i3

  install_firefox

  install_fonts
  install_rvm
}

function zsh_setup()
{

  apt-get install zsh
  (sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && chsh -s $(which zsh))
}

function install_i3()
{
  git clone https://github.com/budmc29/i3-setup.git
  i3-setup/i3-setup.bash
}

function install_firefox()
{
  git clone https://github.com/budmc29/firefox38.git
  cd firefox38 && ./firefox38.bash
  cd ..
}

function version_control_config()
{
  git config --global user.email "chirica.mugurel@gmail.com"
  git config --global user.name "budmc29"

  apt-get install mercurial -y
  hg clone http://bitbucket.org/sjl/hg-prompt/ /usr/local/hg-plugins/prompt
  chmod 777 -R /usr/local/hg-plugins
}

function plugins_setup()
{
  # install plugin manager for vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # install tmux plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  chmod -R 777 ~/.tmux

  # Vim plugin manager
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # install vim plugins
  vim +PluginInstall +qall
}

function install_fonts()
{
  # install console fonts
  curl https://gist.githubusercontent.com/lucasdavila/3875946/raw/1c100cae16a06bef154af0f290d665405b554b3b/install_source_code_pro.sh | sh
}

main
