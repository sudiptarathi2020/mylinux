#!/bin/bash

set -eux

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

#Adding multiverse and universe repo
echo adding multiverse and universe repo
sudo add-apt-repository multiverse -y
sudo add-apt-repository universe -y


echo "Installing Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable -y

echo "installing git and other required softwares"

sudo apt install git build-essential g++ g++-13 g++-13-x86-64-linux-gnu \
g++-x86-64-linux-gnu gcc-14 gcc gcc-x86-64-linux-gnu libstdc++-13-dev \
g++-multilib g++-13-multilib gcc-13-doc gcc-multilib autoconf automake \
libtool flex bison gcc-doc libstdc++-13-doc -y

sudo apt install libncurses-dev -y

sudo apt install openssh-server cmake make python3-dev geany -y

sudo apt install openjdk-17-jdk openjdk-17-jre clangd-18 -y

sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100

cd ~
git clone https://github.com/vim/vim.git
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

make && sudo make install
touch ~/.vimrc
cp ~/mylinux/vimrc ~/.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall

cd ~/.vim/bundle/youcompleteme

python3 install.py --clangd-completer --java-completer
