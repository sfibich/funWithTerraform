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
# Terraform                #
############################
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

############################
# java                     #
############################
sudo apt-get install default-jdk -y 
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
# Install Python 3.7	   #
############################

sudo apt-get install python3.7 -y
sudo apt-get install python3.7-venv -y
sudo apt-get install python3.7-dev -y
sudo apt-get install python3.7-doc -y


############################
# Work in Progress below   #
############################



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

