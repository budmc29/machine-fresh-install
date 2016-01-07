#!/bin/bash
apt-get update  # To get the latest package lists
apt-get upgrade  # To get the latest package lists

# install console fonts
curl https://gist.githubusercontent.com/lucasdavila/3875946/raw/1c100cae16a06bef154af0f290d665405b554b3b/install_source_code_pro.sh | sh 
echo "console font installed"

# install zsh and oh-my-zsh
apt-get install zsh 
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "zsh and oh-my-zsh installed"

# copy dotfiles
cp ~/ubuntu-dotfiles/.zshrc ~/.zshrc
dotupdate # copy all dotfiles from directory to ~/

# install gvim
apt-get install vim-gtk
echo "gvim installed"
vundle # install plugin manager for vim

mkdir ~/.vim/undo
mkdir ~/.vim/swap

# install silver search for vim plugin
apt-get install silversearcher-ag

# TODO: install python and compile for autocomplete

# tmux 2.0
apt-get install -y python-software-properties software-properties-common
add-apt-repository -y ppa:pi-rho/dev
apt-get update
sudo apt-get install -y tmux=2.0-1~ppa1~t
echo 'tmux 2.0 installed'

# install tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux source ~/.tmux.conf

# install irc chat for tmux
apt-get install irssi
echo 'issi installed'

# TODO: install skype, filezilla, imagemagick, chrome, mysqlworkbench, mercurial
#   vlc media player, wine, nodejs

# install antivirus
apt-get install clamav
freshclam
clamscan
echo 'clam antivirus installed'
