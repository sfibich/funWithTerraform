#! /bin/sh
############################
# Target:Ubuntu 18.04      #
############################
sudo apt-get update -y 
sudo apt-get upgrade -y 

############################
# PowerShell               #
############################
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb 
sudo dpkg -i packages-microsoft-prod.deb 
sudo apt-get update -y 
sudo add-apt-repository universe 
sudo apt-get install -y powershell 

############################
# PowerShell AZ            #
############################
pwsh -command "Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force"

############################
# Terraform                #
############################
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform