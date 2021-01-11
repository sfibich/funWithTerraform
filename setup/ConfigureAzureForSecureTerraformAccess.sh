#!/bin/bash

#############################################################################################################################
#DESCRIPTION
#    Configures Azure for secure Terraform access using Azure Key Vault.
#
#    The following steps are automated:
#    - Creates an Azure Service Principle for Terraform.
#    - Creates a new Resource Group.
#    - Creates a new Storage Account.
#    - Creates a new Storage Container.
#    - Creates a new Key Vault.
#    - Configures Key Vault Access Policies.
#    - Creates Key Vault Secrets for these sensitive Terraform login details:
#        - ARM_SUBSCRIPTION_ID
#        - ARM_CLIENT_ID
#        - ARM_CLIENT_SECRET
#        - ARM_TENANT_ID
#        - ARM_ACCESS_KEY
#EXAMPLE
#    az account login
#    ./scripts/ConfigureAzureForSecureTerraformAccess.sh
#
#NOTES
#    Assumptions:
#    - az cli is installed
#    - You are already logged into Azure before running this script (eg.az account login)
#
#    Author:  sfibich
#    GitHub:  https://github.com/sfibich
#
#    This script was based on Adam Rush's script ConfigureAzureForSecureTerraformAccess.ps1 https://github.com/adamrushuk.	#
#############################################################################################################################

#Exit on error
set -e

# This is used to assign yourself access to KeyVault
# Modified to use current login user name as the name for Azure 
# this means the AD Account must have the same user name
#adminUserDisplayName = [Environment]::UserName,
SERVICE_PRINCIPLE_NAME='terraform2'
RESOURCE_GROUP_NAME='terraform-mgmt-rg2'
LOCATION='eastus2'
STORAGE_ACCOUNT_SKU='Standard_LRS'
STORAGE_CONTAINER_NAME='terraform-state'

#################################################################################
# Prepend Linux epoch + 4-digit random number with the letter : Assssssssss9999	#
#################################################################################
LETTERS=({a..z})
RANDOM_NUMBER=$(($RANDOM % 10000))
RANDOM_PREFIX=${LETTERS[RANDOM % 26]}$(date +%s | rev | cut -c1-10)$RANDOM_NUMBER
KEY_VAULT_NAME=${LETTERS[RANDOM % 26]}$(date +%s | rev | cut -c1-6)$RANDOM_NUMBER"-terraform-kv"
STORAGE_ACCOUNT_NAME=$RANDOM_PREFIX"terraform"

#####################
#Check Azure login	#
#####################
echo "Checking for an active Azure login..."

CURRENT_SUBSCRIPTION_ID=$(az account list --query [?isDefault].id --output tsv)
TENANT_ID=$(az account list --query [?isDefault].homeTenantId --output tsv)

if [ -z "$CURRENT_SUBSCRIPTION_ID" ]
	then 
		printf '%s\n' "ERROR! Not logged in to Azure. Run az account login" >&2
		exit 1
	else
		echo "SUCCESS!"
fi


#Service Principle
echo "Checking for an active Service Principle: $SERVICE_PRINCIPLE_NAME..." 

APP_ID=$(az ad app list --query "[?displayName=='$SERVICE_PRINCIPLE_NAME']".appId --output tsv)
echo $APP_ID

if [ -z "$APP_ID" ]
	then 
		echo "Creating a Terraform Service Principle: [$servicePrincipleName] ..."
		az ad app create --display-name $SERVICE_PRINCIPLE_NAME --output none
		APP_ID=$(az ad app list --query "[?displayName=='$SERVICE_PRINCIPLE_NAME']".appId --output tsv)
		az ad sp create --id $APP_ID --output none
		az role assignment create --assignee $APP_ID --role Contributor --scope /subscriptions/$CURRENT_SUBSCRIPTION_ID --output none 
	else
	   	echo "Service Principle exists so renew password (as cannot retrieve current one-off password)"
fi
az ad app credential reset --id $APP_ID

#New Resource Group
echo "Creating Terraform Management Resource Group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION --output none

#New Storage Account
echo "Creating Terraform backend Storage Account: $STORAGE_ACCOUNT_NAME"
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --sku $STORAGE_ACCOUNT_SKU --output none

#New Storage Container
AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME
echo "Creating Terraform State Storage Container: $STORAGE_CONTAINER_NAME"
az storage container create --name $STORAGE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --auth-mode login --output none

#New KeyVault
echo "Creating Terraform KeyVault: $KEY_VAULT_NAME"
az keyvault create --location $LOCATION --name $KEY_VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --output none

#region Set KeyVault Access Policy
#$taskMessage = "Setting KeyVault Access Policy for Admin User: [$adminUserDisplayName]"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#$adminADUser = Get-AzADUser -DisplayName $adminUserDisplayName
#try {
#    $azKeyVaultAccessPolicyParams = @{
#        VaultName                 = $vaultName
#        ResourceGroupName         = $resourceGroupName
#        ObjectId                  = $adminADUser.Id
#        PermissionsToKeys         = @('Get', 'List')
#        PermissionsToSecrets      = @('Get', 'List', 'Set')
#        PermissionsToCertificates = @('Get', 'List')
#        ErrorAction               = 'Stop'
#        Verbose                   = $VerbosePreference
#    }
#    Set-AzKeyVaultAccessPolicy @azKeyVaultAccessPolicyParams | Out-String | Write-Verbose
#} catch {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw $_
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'

#Create KeyVault Secrets
echo "Creating KeyVault Secrets for Terraform"
az keyvault secret set --name ARM-SUBSCRIPTION-ID --value $CURRENT_SUBSCRIPTION_ID --vault-name $KEY_VAULT_NAME --output none
#az keyvault secret set --name ARM-CLIENT-ID --value $APP_ID --vault-name $KEY_VAULT_NAME --output none
az keyvault secret set --name ARM-CLIENT-SECRET --value $CURRENT_SUBSCRIPTION_ID --vault-name $KEY_VAULT_NAME --output none
az keyvault secret set --name ARM-TENANT-ID --value $TENANT_ID --vault-name $KEY_VAULT_NAME --output none
#az keyvault secret set --name ARM-ACCESS-KEY --value $CURRENT_SUBSCRIPTION_ID --vault-name $KEY_VAULT_NAME --output none

# ending output
echo "Terraform resources provisioned:"
#echo "SERVICE_PRINCIPLE_NAME:$SERVICE_PRINCIPLE_NAME"
echo "RESOURCE_GROUP_NAME:$RESOURCE_GROUP_NAME"
echo "LOCATION:$LOCATION"
echo "CONTAINER_NAME:$CONTAINER_NAME"
echo "STORAGE_ACCOUNT_NAME:$STORAGE_ACCOUNT_NAME"
echo "KEY_VAULT_NAME:$KEY_VAULT_NAME"
