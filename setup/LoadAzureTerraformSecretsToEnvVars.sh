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
#    Author:  SFibich																										#	
#    GitHub:  https://github.com/sfibich																					#
#																															#
#    This script was modeled after Adam Rush's script LoadAzureTerraformSecretsToEnvVars.ps1 https://github.com/adamrushuk.	#
#																															#
#############################################################################################################################
if [ -z "$1" ]
	then
		KEY_VAULT_NAME_PATTERN=terraform-kv
		echo "Using Default KEY_VAULT_NAME_PATTERN:$KEY_VAULT_NAME_PATTERN"
	else
		KEY_VAULT_NAME_PATTERN=$1
		echo "Using input KEY_VAULT_NAME_PATTERN:$1"
fi

if [ -z "$2" ]
	then
		TERRAFORM_RESOURCE_GROUP=terraform-mgmt-rg
		echo "Using Default TERRAFORM_RESORUCE_GROUP:$TERRAFORM_RESOURCE_GROUP"
	else
		TERRAFORM_RESOURCE_GROUP=$2
		echo "Using input TERRAFORM_RESOURCE_GROUP:$2"
fi

#####################
#Check Azure login	#
#####################
echo "Checking for an active Azure login..."

CURRENT_SUBSCRIPTION_ID=$(az account list --query [?isDefault].id --output tsv)

if [ -z "$CURRENT_SUBSCRIPTION_ID" ]
	then 
		printf '%s\n' "ERROR! Not logged in to Azure. Run az account login" >&2
#		exit 1
	else
		echo "SUCCESS!"
fi

#####################
#Get Azure Key Vault#
#####################
echo "Searching for Terraform KeyVault..."
KEY_VAULT_NAME=$(az keyvault list --resource-group $TERRAFORM_RESOURCE_GROUP --query "[?contains(name,'$KEY_VAULT_NAME_PATTERN')].name" --output tsv)

if [ -z "$KEY_VAULT_NAME" ]
	then
		printf '%s\n' "ERROR! No Azure Key Vault with name pattern like $KEY_VAULT_NAME_PATTERN" >&2
#		exit 1
	else
		echo "SUCCESS!"
fi

#############################
#Get Azure KeyVault Secrets	#
#############################
echo "Loading ARM_SUBSCRIPTION_ID..."
ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name ARM-SUBSCRIPTION-ID --query "value" --output tsv)
if [ -z "$ARM_SUBSCRIPTION_ID" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-SUBSCRIPITON-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_CLIENT_ID..."
ARM_CLIENT_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name ARM-CLIENT-ID --query "value" --output tsv)
if [ -z "$ARM_CLIENT_ID" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-CLIENT-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_CLIENT_SECERT"
ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name ARM-CLIENT-SECRET --query "value" --output tsv)
if [ -z "$ARM_CLIENT_SECRET" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-CLIENT-SECRET" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_TENANT_ID..."
ARM_TENANT_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name ARM-TENANT-ID --query "value" --output tsv)
if [ -z "$ARM_TENANT_ID" ]
	then 
		printf '%s\n' "FAILURE! Azure Key Vault missing secret ARM-TENANT-ID" >&2
	else
		echo "SUCCESS!"
fi

echo "Loading ARM_ACCESS_KEY..."
ARM_ACCESS_KEY=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name ARM-ACCESS-KEY --query "value" --output tsv)
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

if [ -z "$3" ]
	then
		echo "KEY VAULT SUBSCRIPTION used for Terraform Target Subscription:$ARM_SUBSCRIPTION_ID"
	else
		ARM_SUBSCRIPTION_ID=$3
		echo "USER OVERIDE SUBSCRIPITON used for Terraform Target Subscription:$ARM_SUBSCRIPTION_ID"
fi

echo "FINISHED!"

