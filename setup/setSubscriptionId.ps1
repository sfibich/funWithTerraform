<#
.SYNOPSIS
    Provides an easy way to set the Terraform ARM_SUBSCRIPTION_ID Value via subscription name
.DESCRIPTION
    Sets the Terraform environment variable ARM_SUBSCRIPTION_ID for the current PowerShell session.
	It doe this based on the parameter passed to the script which is the subscription name.  This
	is useful if you have multiple subscriptions.

.EXAMPLE
    .\scripts\setSubscription.ps1 "subscriptionName"

.NOTES
    Assumptions:
    - Azure PowerShell module is installed: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
    - You are already logged into Azure before running this script (eg. Connect-AzAccount)

    Author:  Steve Fibich
    GitHub:  https://github.com/sfibich
#>


[CmdletBinding()]
param (
    # subscription's name that we will look up the id of.
    $subscriptionName = 'Primary_VS_MSDN'
)



$subscription = get-azSubscription -subscriptionName $subscriptionName

$terraformEnvVar = "ARM_SUBSCRIPTION_ID"
Write-Host -Message "Setting [$($terraformEnvVar)]..." -NoNewline
try {
    $setItemParams = @{
        Path        = "env:$terraformEnvVar"
        Value       = $subscription.Id
        ErrorAction = 'Stop'
    }
    Set-Item @setItemParams
} catch {
	$setItemParams | out-string | write-host	
    Write-Error -Message "ERROR: $taskMessage." -ErrorAction 'Continue'
    throw $_
}
$outputInfo = (get-azContext).Name

Write-Host -Message " $outputInfo " -NoNewLine
Write-Host "SUCCESS!" -ForegroundColor 'Green'

set-azContext -subscriptionName $subscriptionName
