#!/bin/bash

#############################################################################################################################
#SYNOPSIS																													#
#  	Loads Azure Key Vault secrets into Terraform environment variables for the current bash session.						#
#																															#
#DESCRIPTION																												#
#	Loads Azure Key Vault secrets into Terraform environment variables for the current bash session.						#
#																															#
#    The following steps are automated:																						#
#    - Identifies the Azure Key Vault matching a search string (default: 'terraform-kv').									#
#    - Retrieves the Terraform secrets from Azure Key Vault.																#
#    - Loads the Terraform secrets into these environment variables for the current bash session:							#
#        - ARM_SUBSCRIPTION_ID																								#
#        - ARM_CLIENT_ID																									#
#        - ARM_CLIENT_SECRET																								#
#        - ARM_TENANT_ID																									#
#        - ARM_ACCESS_KEY																									#
#EXAMPLE																													#
#    source ./LoadAzureTerraformSecretsToEnvVars.sh																			#
#                                                                             												#	
#    Loads Azure Key Vault secrets into Terraform environment variables for the current bash session						#
#NOTES																														#
#    Assumptions:																											#
#    - Az Cli install																										#
#	 - You are inside a bash session																						#
#    - You are already logged into Azure before running this script (eg. az account login)									#
#																															#
#    This script was modeled after Adam Rush's script LoadAzureTerraformSecretsToEnvVars.ps1 https://github.com/adamrushuk.	#
#																															#
#############################################################################################################################

KEY_VAULT_NAME=terraform-kv
ARM_SUBSCRIPTION_ID=TBD
ARM_CLIENT_ID=TBD
ARM_CLIENT_SECRET=TBD
ARM_TENANT_ID=TBD
ARM_ACCESS_KEY=TBD

echo "ARM_SUBSCRIPTION_ID:	$ARM_SUBSCRIPTION_ID"
echo "ARM_CLIENT_ID:		$ARM_CLIENT_ID"
echo "ARM_CLIENT_SECRET:	$ARM_CLIENT_SECRET"
echo "ARM_TENANT_ID:		$ARM_TENANT_ID"
echo "ARM_ACCESS_KEY:		$ARM_ACCESS_KEY"



#Check Azure login
echo "Checking for an active Azure login..."

ARM_SUBSCRIPTION_ID=$(az account list --query [?isDefault].id --output tsv)

if [ -z "$ARM_SUBSCRIPTION_I" ]
	then 
		printf '%s\n' "ERROR! Not logged in to Azure. Run az account login" >&2
		exit 1
	else
		echo "SUCCESS!"
fi

#region Identify Azure Key Vault
#$loadMessage = "loading Terraform environment variables just for this PowerShell session"
#Write-Host "`nSTARTED: $loadMessage" -ForegroundColor 'Green'

# Get Azure objects before Key Vault lookup
#Write-HostPadded -Message "Searching for Terraform KeyVault..." -NoNewline
#$tfKeyVault = Get-AzKeyVault | Where-Object VaultName -match $keyVaultSearchString
#if (-not $tfKeyVault) {
#    Write-Host "ERROR!" -ForegroundColor 'Red'
#    throw "Could not find Azure Key Vault with name including search string: [$keyVaultSearchString]"
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion Identify Azure Key Vault


#region Get Azure KeyVault Secrets
#Write-HostPadded -Message "Retrieving Terraform secrets from Azure Key Vault..." -NoNewline
#$secretNames = @(
#    'ARM_SUBSCRIPTION_ID'
#    'ARM_CLIENT_ID'
#    'ARM_CLIENT_SECRET'
#    'ARM_TENANT_ID'
#    'ARM_ACCESS_KEY'
#)
#$terraformEnvVars = @{}

# Compile Get Azure KeyVault Secrets
#foreach ($secretName in $secretNames) {
#    try {
#        # Retrieve secret
#        $azKeyVaultSecretParams = @{
#            Name        = $secretName -replace '_', '-'
#            VaultName   = $tfKeyVault.VaultName
#            ErrorAction = 'Stop'
#        }
#        $tfSecret = Get-AzKeyVaultSecret @azKeyVaultSecretParams
#
#        # Add secret to hashtable
#        $terraformEnvVars.$secretName = $tfSecret.SecretValueText
#    } catch {
#        Write-Error -Message "ERROR: $taskMessage." -ErrorAction 'Continue'
#        throw $_
#    }
#}
#Write-Host "SUCCESS!" -ForegroundColor 'Green'
##endregion Get Azure KeyVault Secrets


#region Load Terraform environment variables
#$sessionMessage = "Setting session environment variables for Azure / Terraform"
#Write-Host "`nSTARTED: $sessionMessage" -ForegroundColor 'Green'
#foreach ($terraformEnvVar in $terraformEnvVars.GetEnumerator()) {
#    Write-HostPadded -Message "Setting [$($terraformEnvVar.Key)]..." -NoNewline
#    try {
#        $setItemParams = @{
#            Path        = "env:$($terraformEnvVar.Key)"
#            Value       = $terraformEnvVar.Value
#            ErrorAction = 'Stop'
#        }
#        Set-Item @setItemParams
#    } catch {
#        Write-Host "ERROR!" -ForegroundColor 'Red'
#        throw $_
#    }
#    Write-Host "SUCCESS!" -ForegroundColor 'Green'
#}
#Write-Host "FINISHED: $sessionMessage" -ForegroundColor 'Green'
#
#Write-Host "`nFINISHED: $loadMessage" -ForegroundColor 'Green'
##endregion Load Terraform environment variables



echo "ARM_SUBSCRIPTION_ID:	$ARM_SUBSCRIPTION_ID"
echo "ARM_CLIENT_ID:		$ARM_CLIENT_ID"
echo "ARM_CLIENT_SECRET:	$ARM_CLIENT_SECRET"
echo "ARM_TENANT_ID:		$ARM_TENANT_ID"
echo "ARM_ACCESS_KEY:		$ARM_ACCESS_KEY"

