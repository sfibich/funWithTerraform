# funWithTerraform
Scripts I've put together to help me learn terraform as well as other Azure technologies
Currently this script buils a "Workstation" VM configured with:
- Ubuntu 18.04 LTS
- XFCE Desktop
- VNC
- RDP
- Eclipse
- Java (Default)
- Visual Studio Code
- .NET Core
- PowerShell
- AZ Cli
- SSH
- NSGs to support VNC,RDP,SSH
- VM Auto Shutoff
- VM DNS Name for the public IP
- .vimrc, .tmux.conf configuration(my personal settings)

### First time runninng Terraform
1. run the in the /setup directory (follow instructions there)
2. terraform init
3. terraform new workspace WORKSPACENAME

### Before Running Terraform
1. Log into Azure using connect-azAccount
2. Adjust tenant if need be set-azContext -tenantId XXX-XXX
3. Run the LoadAzureTerraformSecretsToEnvVars.ps1 passing it your Key Vault Name
4. Run the setSubscriptionId.ps1 with the subscripton you would like to deploy to (if you have more than one) 
5. Update the UserName variable in the variables.tf
6. Update the password variable in the variables.tf file
7. Update the VNC password in the cloud-init.sh with your password
6. Update the User path /home/adminuser with your /home/USERNAME in the cloud-init.sh file

### Example Command
./terraform apply -var="prefix=work-01" -var="password=NewP@ssw0rd1234"

#### Notes
1. Changing the user name variable will require manual changes to the cloud-init.sh
