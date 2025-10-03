#!/bin/zsh

set -e

#Add user to sudoers
CURRENT_USER=$(whoami)
echo "$CURRENT_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/90-$CURRENT_USER-nopasswd > /dev/null
sudo chmod 0440 /etc/sudoers.d/90-$CURRENT_USER-nopasswd
sudo visudo -cf /etc/sudoers.d/90-$CURRENT_USER-nopasswd

#Install brew then ansible
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
NONINTERACTIVE=1 brew install ansible

#Run install playbook
ansible-playbook -vvvv -i ansible/inventory.yml ansible/install.yml

# Create zsh configuration file 
touch ~/.zprofile
chmod +x ~/.zprofile
chmod +x ./terminal/profile.sh 
echo "source ~/Config/terminal/profile.sh" > ~/.zprofile