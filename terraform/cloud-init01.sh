#! /bin/sh
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
sudo apt-get install ubuntu-desktop -y 
#sudo apt-get install xubuntu-desktop -y
#sudo apt-get install ubuntu-gnome-desktop -y 
#echo "complete: ubuntu-gnome-desktop" >> /tmp/cloud-init.log
#sudo apt-get install xfce4 -y 
#echo "complete: xfce4" >> /tmp/cloud-init.log
#sudo apt-get install xfce4-goodies -y 
#echo "complete: xfce4-goodies" >> /tmp/cloud-init.log

############################
# Install VNC              #
############################
sudo apt-get install tigervnc-standalone-server -y 
echo "complete: tigervnc-standalone-server" >> /tmp/cloud-init.log
sudo apt-get install tigervnc-common tigervnc-xorg-extension tigervnc-viewer -y 
echo "complete: tigernvc (the rest)" >> /tmp/cloud-init.log

############################
# Install RDP              #
############################
sudo apt-get install xrdp -y >> /tmp/cloud-init.log
echo "complete: xrdp" >> /tmp/cloud-init.log

############################
# Terraform                #
############################
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

############################
# Visual Studio Code       #
############################
sudo snap install --classic code

############################
# Git Pulls                #
############################
echo "getting config files from git" >> /tmp/cloud-init.log
cd /home/adminuser
mkdir repos 
cd repos 
git clone https://github.com/sfibich/config.git >>/tmp/cloud-init.log
git clone https://github.com/sfibich/funWithTerraform.git >>/tmp/cloud-init.log
ls -la >> /tmp/cloud-init.log
echo "complete: git"

#VNCPASSWORD
echo "installing: setting vncpassword" >> /tmp/cloud-init.log
sudo chmod +x repos/configs/vncpassword.sh
./configs/vncpassword.sh >> /tmp/cloud-init.log

echo "complete:vncpasswd" >> /tmp/cloud-init.log
#VNC Serivce
vncserver >> /tmp/cloud-init.log
vncserver -kill :1 >> /tmp/cloud-init.log
#mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
cp repos/configs/xstartup .vnc/xstartup
sudo chmod +x .vnc/xstartup
echo "complete: vnc as a service" >> /tmp/cloud-init.log

#.vmrc FILE
#.tmux.conf FILE
#tmux-work.sh FILE
cd /home/adminuser/installs
echo "complete: workstation" >> /tmp/cloud-init.log

############################
# java                     #
############################
sudo apt-get install default-jdk -y 
sudo snap install --classic eclipse 
echo "complete: java" >> /tmp/cloud-init.log

############################
# .Net Core                #
############################
sudo apt-get install -y apt-transport-https 
sudo apt-get install -y dotnet-sdk-3.1 
sudo apt-get install -y aspnetcore-runtime-3.1 
echo "complete: .net core" >> /tmp/cloud-init.log
sudo snap install --classic code 
echo "complete: Visual Studio Code" >> /tmp/cloud-init.log

############################
# Install Powershell       #
############################
echo "Download the Microsoft repository GPG keys" >> /tmp/cloud-init.log
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb 
echo "Register the Microsoft repository GPG keys" >> /tmp/cloud-init.log
sudo dpkg -i packages-microsoft-prod.deb >> /tmp/cloud-init.log
echo "Update the list of products" >> /tmp/cloud-init.log
sudo apt-get update -y 
echo "Enable the universe repositories" >> /tmp/cloud-init.log
sudo add-apt-repository universe 
echo "Install PowerShell" >> /tmp/cloud-init.log
sudo apt-get install -y powershell 
echo "complete: powershell" >> /tmp/cloud-init.log



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
# finish cloud init        #
############################
sudo apt-get autoremove -y 

echo "complete: cloud init finish" >> /tmp/cloud-init.log
echo "check /var/log/apt/history.log for apt-get log info" >> /tmp/cloud-init.log

