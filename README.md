# funWithTerraform
Scripts I've put together to help me learn terraform as well as other Azure technologies

##First time runninng Terraform
1. run the in the /setup directory (follow instructions there)
2. terraform init
3. terraform new workspace WORKSPACENAME

## Before Running Terraform
1. Log into Azure using connect-azAccount
2. Adjust tenant if need be set-azContext -tenantId XXX-XXX
3. Run the LoadAzureTerraformSecretsToEnvVars.ps1 passing it your Key Vault Name
4. Run the setSubscriptionId.ps1 with the subscripton you would like to deploy to (if you have more than one) 
5. Update the UserName variable in the variables.tf
6. Update the password variable in the variables.tf file
7. Update the VNC password in the cloud-init.sh with your password
6. Update the User path /home/adminuser with your /home/USERNAME in the cloud-init.sh file

