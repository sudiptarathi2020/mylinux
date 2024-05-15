#!/bin/bash
set -eux
ADMIN_USER="student"
ADMIN_PASSWORD=''
# encrypted with $(openssl passwd -1 PLAINTEXTPASSWORD)
echo "Enabling universe repo.."
add-apt-repository -y universe

echo "Enabling multiverse repo.."
add-apt-repository -y multiverse
echo "Creating admin account, $ADMIN_USER..."
useradd --create-home --password $(echo $ADMIN_PASSWORD) --shell /bin/bash $ADMIN_USER
usermod -aG sudo $ADMIN_USER
chmod -R -v 750 /home/*
echo "Installing VS Code ..."
# https://code.visualstudio.com/docs/setup/linux

apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

apt install -y apt-transport-https
apt update -y
apt install -y code
echo "Installing gcc-12, g++-12..."

apt install -y gcc-12 g++-12

update-alternatives \
	--install /usr/bin/gcc gcc /usr/bin/gcc-12 80 \
	--slave /usr/bin/g++ g++ /usr/bin/g++-12 \
	--slave /usr/bin/gcov gcov /usr/bin/gcov-12
echo "\nInstalling Geany ...\n"
apt install -y geany
echo "\nPrinting Geany version ...\n"
geany --version
echo "Installing Codeblocks ..."

add-apt-repository universe -y
apt install -y codeblocks codeblocks-contrib
echo "Installing Google Chrome.."

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
rm -v google-chrome-stable_current_amd64.deb
echo "Installing openssh-server..."

apt install -y openssh-server
echo "Installing Python 3.11..."

apt install -y python3.11-full
echo "\nInstalling Sublime Text 4 ...\n"
apt install -y wget gpg
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor >> /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list
apt update
apt install -y apt-transport-https
apt install -y sublime-text

echo "\nPrinting Sublime Text version ...\n"
subl --version
echo "\nInstalling Vim ...\n"
apt install -y vim-gtk3
echo "\nPrinting Vim version ...\n"

vim --version
apt remove -y --purge \
	aisleriot \
	gnome-mahjongg \
	gnome-mines \
	gnome-sudoku \
	'libreoffice*' \
	rhythmbox \
	shotwell \
	thunderbird \
	zsys

# remove unused packages
apt autoremove -y
