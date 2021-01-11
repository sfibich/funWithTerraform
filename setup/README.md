 These scripts are design to help with Azure setup and Terraform execution.  In general this is a very robust personal setup for development work with terraform.
 This setup with additional refinement could be used as part of an overall enterprise solution for Terraform.  (Good amount of work to get you there, could 
 be okay for a smaller organization)
 
 ## ConfigureAzureForSecureTerraformAccess.sh

 The script creates a resource group, a key vault, a storage account and an SPN.   It loads the client id, client secret, tenant id, subscription id, 
 and storage account acccess key in to the key vault.  The script grants the current user ownership over the key vault.
 
 ## LoadAzureTerraformSecretsToEnvVars.sh 
 This script loads the information in the Azure Key Vault to session variables so that Terraform can use them to execute scripts without 
 having to provide the information manually.  It also sets up the access key to a storage account so it can be used to manage terraform state.
 
