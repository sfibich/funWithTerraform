#!/bin/bash

#############################################################################################################################
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
#																															#
#EXAMPLE																													#
#    source ./LoadAzureTerraformSecretsToEnvVars.sh																			#
#                                                                             												#	
#    Loads Azure Key Vault secrets into Terraform environment variables for the current bash session						#
#																															#
#NOTES																														#
#    Assumptions:																											#
#    - Az Cli install																										#
#	 - You are inside a bash session																						#
#    - You are already logged into Azure before running this script (eg. az account login)									#
#																															#
#    Author:  SFibich																									#	
#    GitHub:  https://github.com/sfibich																					#
#																															#
#    This script was modeled after Adam Rush's script LoadAzureTerraformSecretsToEnvVars.ps1 https://github.com/adamrushuk.	#
#																															#
#############################################################################################################################

KEY_VAULT_NAME_PATTERN=terraform-kv

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

#####################
#Get Azure Key Vault#
#####################
echo "Searching for Terraform KeyVault..."
KEY_VAULT_NAME=$(az keyvault list --query "[?contains(name,'terraform-kv')].name" --output tsv)

if [ -z "$KEY_VAULT_NAME" ]
	then
		printf '%s\n' "ERROR! No Azure Key Vault with name pattern like $KEY_VAULT_NAME_PATTERN" >&2
		exit 1
	else
		echo "SUCCESS!"
fi

#############################
#Get Azure KeyVault Secrets	#
#############################
echo "Loading ARM_SUBSCRIPTION_ID..."
ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name a4xhqldwe-terraform-kv --name ARM-SUBSCRIPTION-ID --query "value" --output tsv)
if [ -z "$ARM_SUBSCRIPTION_ID" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-SUBSCRIPITON-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_CLIENT_ID..."
ARM_CLIENT_ID=$(az keyvault secret show --vault-name a4xhqldwe-terraform-kv --name ARM-CLIENT-ID --query "value" --output tsv)
if [ -z "$ARM_CLIENT_ID" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-CLIENT-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_CLIENT_SECERT"
ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name a4xhqldwe-terraform-kv --name ARM-CLIENT-SECRET --query "value" --output tsv)
if [ -z "$ARM_CLIENT_SECRET" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-CLIENT-SECRET" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_TENANT_ID..."
ARM_TENANT_ID=$(az keyvault secret show --vault-name a4xhqldwe-terraform-kv --name ARM-TENANT-ID --query "value" --output tsv)
if [ -z "$ARM_TENANT_IDZ" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-TENANT-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_ACCESS_KEY..."
ARM_ACCESS_KEY=$(az keyvault secret show --vault-name a4xhqldwe-terraform-kv --name ARM-ACCESS-KEY --query "value" --output tsv)
if [ -z "$ARM_ACCESS_KEY" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-ACCESS_KEY" >&2
	else
		echo "SUCCESS!"
fi

echo "ARM_SUBSCRIPTION_ID:	$ARM_SUBSCRIPTION_ID"
echo "ARM_CLIENT_ID:		$ARM_CLIENT_ID"
echo "ARM_CLIENT_SECRET:	HIDDEN!"
echo "ARM_TENANT_ID:		$ARM_TENANT_ID"
echo "ARM_ACCESS_KEY:		$ARM_ACCESS_KEY"

echo "FINISHED!"

