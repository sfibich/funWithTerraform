#! /bin/sh
############################
# Target:Ubuntu 18.04      #
############################
sudo timedatectl set-timezone America/New_York
############################
# start cloud init         #
############################
sudo touch /tmp/cloud-init.log
sudo chmod a+w /tmp/cloud-init.log
echo "cloud init start" >> /tmp/cloud-init.log
cd /home/adminuser
mkdir installs
pwd >> /tmp/cloud-init.log
ls -la >> /tmp/cloud-init.log
echo "complete:home setup" >> /tmp/cloud-init.log
sudo apt-get update -y 
sudo apt-get upgrade -y 
echo "complete: update & upgrade" >> /tmp/cloud-init.log

############################
# Make it a workstation    #
############################
echo "installing Desktop and serveres for remote access" >> /tmp/cloud-init.log
#sudo apt-get install ubuntu-desktop -y 
#sudo apt-get install xubuntu-desktop -y
#sudo apt-get install ubuntu-gnome-desktop -y
#sudo apt install gnome-shell-extensions  -y
#echo "complete: ubuntu-gnome-desktop" >> /tmp/cloud-init.log
#sudo apt-get install xfce4 -y 
sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y
sudo apt install firefox -y
echo "complete: xfce4" >> /tmp/cloud-init.log
sudo apt-get install -y gnome-keyring
sudo apt-get install -y tree

############################
# Install VNC              #
############################
#sudo apt-get install tigervnc-standalone-server -y 
#echo "complete: tigervnc-standalone-server" >> /tmp/cloud-init.log
#sudo apt-get install tigervnc-common tigervnc-xorg-extension tigervnc-viewer -y 
#echo "complete: tigernvc (the rest)" >> /tmp/cloud-init.log

############################
# Install RDP              #
############################
sudo apt-get install xrdp -y >> /tmp/cloud-init.log
sudo systemctl enable xrdp
sudo systemctl status xrdp >> /tmp/cloud-init.log
echo "complete: xrdp" >> /tmp/cloud-init.log

############################
# Terraform                #
############################
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

############################
# Azure Storage Explorer   #
############################
sudo snap install storage-explorer
sudo snap connect storage-explorer:password-manager-service :password-manager-service
echo "complete: azure storage explorer" >> /tmp/cloud-init.log

############################
# Visual Studio Code       #
############################
sudo snap install --classic code

############################
# java                     #
############################
sudo apt-get install default-jdk -y 
sudo snap install --classic eclipse 
echo "complete: java" >> /tmp/cloud-init.log

############################
# .Net 5.0                 #
############################
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update -y
sudo apt-get install -y apt-transport-https 
sudo apt-get update -y
sudo apt-get install -y dotnet-sdk-5.0
echo "complete: .net 5.0" >> /tmp/cloud-init.log

############################
# Install Powershell       #
############################
echo "Download the Microsoft repository GPG keys" >> /tmp/cloud-init.log
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb 
echo "Register the Microsoft repository GPG keys" >> /tmp/cloud-init.log
sudo dpkg -i packages-microsoft-prod.deb 
echo "Update the list of products" >> /tmp/cloud-init.log
sudo apt-get update -y 
echo "Enable the universe repositories" >> /tmp/cloud-init.log
sudo add-apt-repository universe 
echo "Install PowerShell" >> /tmp/cloud-init.log
sudo apt-get install -y powershell 
echo "complete: powershell" >> /tmp/cloud-init.log

############################
# PowerShell AZ            #
############################
pwsh -command "Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force"

############################
# Install AZ Cli           #
############################
sudo apt-get update -y  
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg  -y 
echo "Download and install the Microsoft signing key" >> /tmp/cloud-init.log
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "Add the Azure CLI software repository" >> /tmp/cloud-init.log
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list 
echo "Update repository information and install the azure-cli package" >> /tmp/cloud-init.log
sudo apt-get update -y 
sudo apt-get install azure-cli -y 
echo "complete:az cli" >> /tmp/cloud-init.log


############################
# Install AZ Func         #
############################
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install azure-functions-core-tools-3 -y


############################
# Install core dev utils   #
############################
sudo apt-get install python3.6-dev -y
sudo apt-get install python3.8 python3.8-dev python3.8-distutils python3.8-venv -y
sudo apt-get install cmake


############################
# Work in Progress below   #
############################


############################
# Sound                    #
############################
sudo apt install xrdp-pulseaudio-installer
sudo xrdp-build-pulse-modules #fails
cd /tmp
# Need to inline source /etc/apt/source.list file....
sudo apt source pulseaudio
cd /tmp/pulseaudio-11.1
sudo ./configure
cd /usr/src/xrdp-pulseaudio-installer
sudo make PULSE_DIR="/tmp/pulseaudio-11.1"
sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so
echo "complete: sound" >> /tmp/cloud-init.log


############################
# Git Pulls                #
############################
echo "getting config files from git" >> /tmp/cloud-init.log
cd ~/
mkdir repos 
cd repos 
git clone https://github.com/adminuser/config.git >>/tmp/cloud-init.log
git clone https://github.com/adminuser/funWithTerraform.git >>/tmp/cloud-init.log
ls -la >> /tmp/cloud-init.log
echo "complete: git"

#VNCPASSWORD
#echo "installing: setting vncpassword" >> /tmp/cloud-init.log
#sudo chmod +x repos/configs/vncpassword.sh
#./configs/vncpassword.sh >> /tmp/cloud-init.log

#echo "complete:vncpasswd" >> /tmp/cloud-init.log
#VNC Serivce
#vncserver >> /tmp/cloud-init.log
#vncserver -kill :1 >> /tmp/cloud-init.log
#mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
#cp repos/configs/xstartup .vnc/xstartup
#sudo chmod +x .vnc/xstartup
#echo "complete: vnc as a service" >> /tmp/cloud-init.log

#.vmrc FILE
#.tmux.conf FILE
#tmux-work.sh FILE
#cd /home/adminuser/installs
#echo "complete: workstation" >> /tmp/cloud-init.log

############################
# finish cloud init        #
############################
sudo apt-get autoremove -y 

echo "complete: cloud init finish" >> /tmp/cloud-init.log
echo "check /var/log/apt/history.log for apt-get log info" >> /tmp/cloud-init.log

