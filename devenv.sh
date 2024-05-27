#!/bin/bash

set -eux

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Adding multiverse and universe repositories
echo "Adding multiverse and universe repositories"
add-apt-repository multiverse -y
add-apt-repository universe -y

# Installing Google Chrome
echo "Installing Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable

# Installing git and other required software
echo "Installing git and other required software"
apt-get install -y git build-essential g++ g++-13 g++-13-x86-64-linux-gnu \
g++-x86-64-linux-gnu gcc-14 gcc gcc-x86-64-linux-gnu libstdc++-13-dev \
g++-multilib g++-13-multilib gcc-13-doc gcc-multilib autoconf automake \
libtool flex bison gcc-doc libstdc++-13-doc libncurses-dev \
openssh-server cmake make python3-dev geany \
openjdk-17-jdk openjdk-17-jre clangd-18

update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100

# Cloning and building Vim
cd ~
if [ ! -d "vim" ]; then
    git clone https://github.com/vim/vim.git
fi
cd vim/src
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local

make && make install
touch ~/.vimrc
cp ~/mylinux/vimrc ~/.vimrc

# Setting up Vundle and YouCompleteMe
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall

cd ~/.vim/bundle/youcompleteme
python3 install.py --clangd-completer --java-completer

echo "Development environment setup complete."
