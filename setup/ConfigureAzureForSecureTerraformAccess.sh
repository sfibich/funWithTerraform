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

# This is used to assign yourself access to KeyVault
# Modified to use current login user name as the name for Azure 
# this means the AD Account must have the same user name
#adminUserDisplayName = [Environment]::UserName,
SERVICE_PRINCIPLE_NAME='terraform2'
RESOURCE_GROUP_NAME='terraform-mgmt-rg'
LOCATION='eastus2'
STORAGE_ACCOUNT_SKU='Standard_LRS'
CONTAINER_NAME='terraform-state'

#################################################################################
# Prepend Linux epoch + 4-digit random number with the letter : Assssssssss9999	#
#################################################################################
LETTERS=({a..z})
RANDOM_NUMBER=$(($RANDOM % 10000))
RANDOM_PREFIX=${LETTERS[RANDOM % 26]}$(date +%s | rev | cut -c1-10)$RANDOM_NUMBER
KEY_VAULT_NAME="$RANDOM_PREFIX-terraform-kv"
STORAGE_ACCOUNT_NAME=$RANDOM_PREFIX"terraform"

#####################
#Check Azure login	#
#####################
echo "Checking for an active Azure login..."

CURRENT_SUBSCRIPTION_ID=$(az account list --query [?isDefault].id --output tsv)

if [ -z "$CURRENT_SUBSCRIPTION_ID" ]
	then 
		printf '%s\n' "ERROR! Not logged in to Azure. Run az account login" >&2
		exit 1
	else
		echo "SUCCESS!"
fi


#Service Principle
echo "Checking for an active Service Principle: $SERVICE_PRINCIPLE_NAME..." 

# Get current context
#$terraformSP = Get-AzADServicePrincipal -DisplayName $servicePrincipleName
#Write-Host "SUCCESS!" -ForegroundColor 'Green'

#if (-not $terraformSP) {
#    Write-HostPadded -Message "Creating a Terraform Service Principle: [$servicePrincipleName] ..." -NoNewline
#    try {
#        $terraformSP = New-AzADServicePrincipal -DisplayName $servicePrincipleName -Role 'Contributor' -ErrorAction 'Stop'
#        $servicePrinciplePassword = [pscredential]::new($servicePrincipleName, $terraformSP.Secret).GetNetworkCredential().Password
#    } catch {
#        Write-Host "ERROR!" -ForegroundColor 'Red'
#        throw $_
#    }
#    Write-Host "SUCCESS!" -ForegroundColor 'Green'
#
#} else {
#    # Service Principle exists so renew password (as cannot retrieve current one-off password)
#    $newSpCredential = $terraformSP | New-AzADSpCredential
#    $servicePrinciplePassword = [pscredential]::new($servicePrincipleName, $newSpCredential.Secret).GetNetworkCredential().Password
#}
#endregion Service Principle

#New Resource Group
echo "Creating Terraform Management Resource Group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION --output none

#New Storage Account
echo "Creating Terraform backend Storage Account: $STORAGE_ACCOUNT_NAME"
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --sku $STORAGE_ACCOUNT_SKU --output none

#region Select Storage Container
#$taskMessage = "Selecting Default Storage Account"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#try {
#    $azCurrentStorageAccountParams = @{
#        ResourceGroupName = $resourceGroupName
#        AccountName       = $storageAccountName
#        ErrorAction       = 'Stop'
#        Verbose           = $VerbosePreference
#    }
#    Set-AzCurrentStorageAccount @azCurrentStorageAccountParams | Out-String | Write-Verbose
#} catch {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw $_
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion Select Storage Account


#region New Storage Container
#$taskMessage = "Creating Terraform State Storage Container: [$storageContainerName]"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#try {
#    $azStorageContainerParams = @{
#        Name        = $storageContainerName
#        Permission  = 'Off'
#        ErrorAction = 'Stop'
#        Verbose     = $VerbosePreference
#    }
#    New-AzStorageContainer @azStorageContainerParams | Out-String | Write-Verbose
#} catch {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw $_
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion New Storage Container


#region New KeyVault
#$taskMessage = "Creating Terraform KeyVault: [$vaultName]"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#try {

 #   Register-AzResourceProvider -ProviderNamespace "Microsoft.KeyVault"

#    $azKeyVaultParams = @{
#        VaultName         = $vaultName
#        ResourceGroupName = $resourceGroupName
#        Location          = $location
#        ErrorAction       = 'Stop'
#        Verbose           = $VerbosePreference
#    }
#    New-AzKeyVault @azKeyVaultParams | Out-String | Write-Verbose
#} catch {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw $_
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion New KeyVault


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
#
#$taskMessage = "Setting KeyVault Access Policy for Terraform SP: [$servicePrincipleName]"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#try {
#    $azKeyVaultAccessPolicyParams = @{
#        VaultName                 = $vaultName
#        ResourceGroupName         = $resourceGroupName
#        ObjectId                  = $terraformSP.Id
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
#endregion Set KeyVault Access Policy


#region Terraform login variables
# Get Storage Access Key
#$storageAccessKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName
#$storageAccessKey = $storageAccessKeys[0].Value # only need one of the keys

#$terraformLoginVars = @{
#    'ARM-SUBSCRIPTION-ID' = $subscription.Id
#    'ARM-CLIENT-ID'       = $terraformSP.ApplicationId
#    'ARM-CLIENT-SECRET'   = $servicePrinciplePassword
#    'ARM-TENANT-ID'       = $subscription.TenantId
#    'ARM-ACCESS-KEY'      = $storageAccessKey
#}
#Write-Host "`nTerraform login details:"
#$terraformLoginVars | Out-String | Write-Host
#endregion Terraform login variables


#region Create KeyVault Secrets
#$taskMessage = "Creating KeyVault Secrets for Terraform"
#Write-HostPadded -Message "`n$taskMessage..." -NoNewline
#try {
#    foreach ($terraformLoginVar in $terraformLoginVars.GetEnumerator()) {
#        $AzKeyVaultSecretParams = @{
#            VaultName   = $vaultName
#            Name        = $terraformLoginVar.Key
#            SecretValue = (ConvertTo-SecureString -String $terraformLoginVar.Value -AsPlainText -Force)
#            ErrorAction = 'Stop'
#            Verbose     = $VerbosePreference
#        }
#        Set-AzKeyVaultSecret @AzKeyVaultSecretParams | Out-String | Write-Verbose
#    }
#} catch {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw $_
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion Create KeyVault Secrets



# ending output
echo "Terraform resources provisioned:"
echo "SERVICE_PRINCIPLE_NAME:$SERVICE_PRINCIPLE_NAME"
echo "RESOURCE_GROUP_NAME:$RESOURCE_GROUP_NAME"
echo "LOCATION:$LOCATION"
echo "CONTAINER_NAME:$CONTAINER_NAME"
echo "STORAGE_ACCOUNT_NAME:$STORAGE_ACCOUNT_NAME"
echo "KEY_VAULT_NAME:$KEY_VAULT_NAME"
