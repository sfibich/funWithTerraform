#! /bin/bash
############################
# start cloud init         #
############################
echo "cloud init start" >> /tmp/cloud-init.log
sudo apt-get update -y >> /tmp/cloud-init.log
sudo apt-get upgrade -y >> /tmp/cloud-init.log

############################
# Make it a workstation    #
############################
#sudo apt-get install ubuntu-desktop -y >> /tmp/cloud-init.log
#sudo apt-get install xubuntu-desktop -y >> /tmp/cloud-init.log
sudo apt-get install ubuntu-gnome-desktop -y >> /tmp/cloud-init.log
sudo apt-get install xfce4 -y >> /tmp/cloud-init.log
sudo apt-get install tigervnc-standalone-server >> /tmp/cloud-init.log
sudo apt-get install tigervnc-common tigervnc-xorg-extension tigervnc-viewer >> /tmp/cloud-init.log
#VNCPASSWORD
#VNC AUTOSTART
mkdir ~/repos
#GIT PULL
#.vmrc FILE
#.tmux.conf FILE
#tmux-work.sh FILE


############################
# java                     #
############################
sudo apt install default-jdk -y >> /tmp/cloud-init.log
sudo snap install --classic eclipse >> /tmp/cloud-init.log

############################
# Install Powershell       #
############################
echo "Download the Microsoft repository GPG keys" >> /tmp/cloud-init.log
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb 
echo "Register the Microsoft repository GPG keys" >> /tmp/cloud-init.log
sudo dpkg -i packages-microsoft-prod.deb >> /tmp/cloud-init.log
echo "Update the list of products" >> /tmp/cloud-init.log
sudo apt-get update >> /tmp/cloud-init.log
echo "Enable the universe repositories" >> /tmp/cloud-init.log
sudo add-apt-repository universe >> /tmp/cloud-init.log
echo "Install PowerShell" >> /tmp/cloud-init.log
sudo apt-get install -y powershell >> /tmp/cloud-init.log



############################
# Install AZ Cli           #
############################
sudo apt-get update -y  >> /tmp/cloud-init.log
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg  -y >> /tmp/cloud-init.log
echo "Download and install the Microsoft signing key" >> /tmp/cloud-init.log
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "Add the Azure CLI software repository" >> /tmp/cloud-init.log
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list 
echo "Update repository information and install the azure-cli package" >> /tmp/cloud-init.log
sudo apt-get update -y >> /tmp/cloud-init.log
sudo apt-get install azure-cli -y >> /tmp/cloud-init.log


############################
# finish cloud init        #
############################
sudo apt-get autoremove -y >> /tmp/cloud-init.log

echo "cloud init finish" >> /tmp/cloud-init.log
