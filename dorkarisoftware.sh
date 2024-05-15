#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install Google Chrome
echo "Installing Google Chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable -y

# Install g++
echo "Installing g++..."
sudo apt install g++ -y

# Install Code::Blocks
echo "Installing Code::Blocks..."
sudo apt install codeblocks -y

# Install VS Code
echo "Installing Visual Studio Code..."
sudo apt update
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code -y

# Install OpenSSH server
echo "Installing OpenSSH server..."
sudo apt install openssh-server -y

# Install Python 3
echo "Installing Python 3..."
sudo apt install python3 -y

# Install Vim
echo "Installing Vim..."
sudo apt install vim -y

# Install Geany
echo "Installing Geany..."
sudo apt install geany -y

# Install Sublime Text
echo "Installing Sublime Text..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text -y

# Create user 'student' with sudo privileges and password 'student'
echo "Creating user 'student'..."
sudo useradd -m student
echo "student:student" | sudo chpasswd
echo "student ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/student

echo "Installation complete!"
