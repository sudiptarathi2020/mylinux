#!/bin/bash

set -eux

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Adding multiverse and universe repositories
echo "Adding multiverse and universe repositories"

# Installing Google Chrome
echo "Installing Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable

# Installing git and other required software
echo "Installing git and other required software"
apt-get install -y git build-essential g++ \
 gcc \
autoconf automake \
libtool flex bison  libncurses-dev \
openssh-server cmake make python3-dev geany \
openjdk-jdk openjdk-jre clangd


cp ~/mylinux/vimrc ~/.vimrc

# Setting up Vundle and YouCompleteMe
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall


echo "Development environment setup complete."
