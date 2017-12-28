#!/bin/bash
#
# Script to install all the required programs and configurations for
# a GNU/Linux enjoyable developing experience
# This of course highly subjective

# TODO: check if dotfiles exists
# TODO: check all the dependencies
# TODO: select what to install?
# TODO: remember to display messages of confirmation
# TODO: install i3wm.bash
# TODO: setup AV chrons (clamscan and chkrootkit)
main() {
  # prepare_repositories
  # create_resources
  install_programs
  # plugins_setup
  # version_control_config
  # zsh_setup
  # prepare_dotfiles
}

prepare_repositories() {
  sudo add-apt-repository ppa:nilarimogard/webupd8 # Audio packages
  sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe' # Mysql 5.6

  sudo apt-get update  # To get the latest package lists
  sudo apt-get upgrade  # To get the latest package list

  sudo add-apt-repository ppa:no1wantdthisname/ppa # I3 package requirement
  sudo add-apt-repository ppa:noobslab/themes # Gtk theme
}

create_resources() {
  user=`whoami`

  DIRS=(
    "/home/$user/.vim/undo"
    "/home/$user/.vim/swap"
    "/home/$user/personal"
    "/home/$user/work"
    "/home/$user/projects"
  )

  for dirname in "${DIRS[@]}"; do
    mkdir -p $dirname
  done

  echo "Directories created"
}

install_rvm() {
# install RVM
# key to verify the installed version
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable
}

prepare_dotfiles() {
  # copy dotfiles
  git clone https://github.com/budmc29/ubuntu-dotfiles ~/ubuntu-dotfiles
  # replace this with dotter command
  cp -rT ~/ubuntu-dotfiles/ ~/
  rm -rf ~/.git

  source ~/.zshrc
}

install_tmux() {
  VERSION=2.6

  sudo apt-get -y remove tmux
  sudo apt-get -y install libevent-dev libncurses-dev automake pkg-config

  wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz

  tar xzf tmux-${VERSION}.tar.gz
  sudo rm -f tmux-${VERSION}.tar.gz
  cd tmux-${VERSION}

  ./configure
  make
  make install
  cd -
  sudo rm -rf /usr/local/src/tmux-*
  sudo mv tmux-${VERSION} /usr/local/src
}

install_programs() {
  # Programs by groups listed
  #
  # Personal
  # Work
  # Gems

  # alsa-utils: i3wm sound card scripts
  # acip: i3wm battery status
  # gufw: firewall manager
  PROGRAMS=(
    "pulseaudio-equalizer"
    "xclip"
    "vlc"
    "chromium-browser"
    "filezilla"
    "mysql-client-5.6"
    "mysql-server-5.6"
    "vim-gtk"
    "silversearcher-ag"
    "rxvt-unicode"
    "clamav"
    "clamav-daemon"
    "gufw"
    "kdiff3"
    "exuberant-ctags"
    "sysstat"
    "alsa-utils"
    "acpi"
    "chkrootkit"
    "p7zip-full"
    "gimp"
    "mysql-workbench"
    "skype"

    "nodejs"
    "apache2"
    "nginx"
    "imagemagick"
    "redis-server"

    "libxslt-dev"
    "libxml2-dev"
    "libmysqlclient-dev"
    "libqtwebkit-dev"
    "libqt4-dev"
    "libqt4-dev"
    "libmysqlclient-dev"
    "libmysqlclient-dev"

    "i3"
    "arandr"
    "ranger"
    "fontconfig-infinality"
    "polar-night-gtk"
    "compton"
    "ruby-ronn"
    "lxappearance"
  )

  for program in "${PROGRAMS[@]}"; do
    sudo apt-get install $program -y
  done

  # install_tmux
  # install_fonts
  # install_rvm
  # install_elasticsearch

  # sudo dpkg -i ./skype-ubuntu-precise_4.3.0.37-1_i386.deb

  setup_i3
  # `sudo freshclam` # Update Clam AV
}

zsh_setup() {
  sudo apt-get install zsh
  (sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && sudo chsh -s $(which zsh))
}

setup_i3() {
  mkdir -p i3_setup
  cd i3_setup

  wget https://github.com/acrisci/playerctl/releases/download/v0.4.2/playerctl-0.4.2_amd64.deb

  dpkg -i playerctl*

  # Install San Francisco font system wide
  wget https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
  unzip master.zip

  # Move to system fonts
  mv Yo*/*.ttf ~/.fonts

  # Set osx display style
  bash /etc/fonts/infinality/infctl.sh setstyle osx

  # Install rofi app launcher
  wget https://launchpad.net/ubuntu/+source/rofi/0.15.11-1/+build/8289001/+files/rofi_0.15.11-1_amd64.deb
  dpkg -i rofi*.deb

  # install i3blocks
  git clone git://github.com/vivien/i3blocks
  cd i3blocks

  sudo make clean all
  sudo make install

  cd ..

  rm i3_setup -rf 

  echo "I3 installed successfully"
  echo "Remeber to open, lxappearance and set SFNS Display font for gtk"
  echo "Press enter to continue"
}

version_control_config() {
  git config --global user.email "chirica.mugurel@gmail.com"
  git config --global user.name "Mugur (Bud) Chirica"

  sudo apt-get install mercurial -y
  hg clone http://bitbucket.org/sjl/hg-prompt/ /usr/local/hg-plugins/prompt
  chmod 777 -R /usr/local/hg-plugins
}

plugins_setup() {
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

install_fonts() {
  version=1.010

  echo "\n* Downloading version $version of source code pro font"
  rm -f SourceCodePro_FontsOnly-$version.zip
  rm -rf SourceCodePro_FontsOnly-$version
  wget https://github.com/downloads/adobe/source-code-pro/SourceCodePro_FontsOnly-$version.zip

  echo "\n* Unziping package"
  unzip SourceCodePro_FontsOnly-$version.zip
  mkdir -p ~/.fonts

  echo "\n* Copying fonts to ~/fonts"
  cp SourceCodePro_FontsOnly-$version/OTF/*.otf ~/.fonts/

  echo "\n* Updating font cache"
  sudo fc-cache -f -v

  echo "\n* Looking for 'Source Code Pro' in installed fonts"
  fc-list | grep "Source Code Pro"

  echo "\n* Now, you can use the 'Source Code Pro' fonts, ** for sublime text ** just add the lines bellow to 'Preferences > Settings':"
  echo '\n  "font_face": "Source Code Pro",'
  echo '  "font_size": 10'

  echo "\n* Finished :)\n"
}

install_elasticsearch() {
  wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.2.deb
  sudo dpkg -i elasticsearch-1.5.2.deb
  sudo update-rc.d elasticsearch defaults 95 10
  sudo /etc/init.d/elasticsearch start
}

main "$@"
