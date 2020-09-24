# funWithTerraform
scripts put together to help me learn terraform as well as other Azure technologies

## Before Running Terraform
1. Log into Azure using connect-azAccount
2. Adjust tenant if need be set-azContext -tenantId XXX-XXX
3. Run the LoadAzureTerraformSecretsToEnvVars.ps1 passing it your Key Vault Name
4. Run the setSubscriptionId.ps1 with the subscripton you would like to deploy to (if you have more than one) 



If this is the first time running Terraform
terraform init
terraform new workspace WORKSPACENAME

