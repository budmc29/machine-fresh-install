#!/bin/bash
apt-get update  # To get the latest package lists
apt-get upgrade  # To get the latest package lists

#TODO: check if dotfiles exists
#TODO: check all the dependencies
#TODO: select what to install?
#TODO: remember to display messages of confirmation
#TODO: make zsh the defaul shell


# config git
git config --global user.email "chirica.mugurel@gmail.com"
git config --global user.name "budmc29"

# install mercurial
apt-get install mercurial -y

hg clone http://bitbucket.org/sjl/hg-prompt/ /usr/local/hg-plugins/prompt

# install console fonts
curl https://gist.githubusercontent.com/lucasdavila/3875946/raw/1c100cae16a06bef154af0f290d665405b554b3b/install_source_code_pro.sh | sh
echo "console font installed"

# install gvim
apt-get install vim-gtk
echo "gvim installed"
vundle # install plugin manager for vim

mkdir ~/.vim/undo
mkdir ~/.vim/swap

# install silver search for vim plugin
apt-get install silversearcher-ag

# install tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install antivirus
`apt-get install clamav -y
freshclam`
echo 'clam antivirus installed'

# install RVM
# key to verify the installed version
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable --ruby

apt-get install xclip -y
apt-get install vlc -y
apt-get install chromium-browser -y
apt-get install imagemagick -y
apt-get install filezilla -y
apt-get install mysql-client -y
apt-get install mysql-workbench
apt-get install nodejs -y
apt-get install apache2 -y

# TODO
# install firefox38.bash
# install i3wm.bash

# copy dotfiles
git clone https://github.com/budmc29/ubuntu-dotfiles ~/ubuntu-dotfiles
cp ~/ubuntu-dotfiles/.zshrc ~/.zshrc

source ~/.zshrc

`dotupdate` # copy all dotfiles from directory to ~/

# Vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install vim plugins
vim +PluginInstall +qall

# tmux 2.2
VERSION=2.2
if [[ $1 = local ]]; then
echo 'Build "libevent-dev" and "libncurses-dev".' >&2
else
sudo apt-get -y install libevent-dev libncurses-dev
sudo apt-get -y remove tmux
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
sudo make install
cd -
sudo rm -rf /usr/local/src/tmux-*
sudo mv tmux-${VERSION} /usr/local/src
fi

git clone https://github.com/budmc29/i3-setup.git
i3-setup/i3-setup.bash

# install zsh and oh-my-zsh
apt-get install zsh 
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "zsh and oh-my-zsh installed"
