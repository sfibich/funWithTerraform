<#
.SYNOPSIS
	Deploys a Python based function to Azure using local build option

.DESCRIPTION
	Assumes you have logged in using az login
	Assumes you have activated the python venv

	Basic Build Link:
	https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function-azure-cli?tabs=bash%2Cbrowser

	func local build Link:
	https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python#publishing-to-azure

.PARAMETER
	None

.OUTPUTS
	Add description of any output

.EXAMPLE
	Add an example

#>


<#------------------------------------------- Initialization -----------------#>
$ErrorActionPrefernce = "Stop"
set-strictMode -Version 1

<#------------------------------------------- Global Variables ---------------#>
$distinct = get-date -format "yyyyMMddhhss"
$global:appName = "funcdemo$distinct"
$global:logName = "funcdemo$distinct.log"
$global:location = "westeurope"
$global:rgName = "demoazfunction$distinct"
$global:stAcctName = "demoazfunc$distinct"
$global:group = $null
$global:vnetName = "demoazfunction$distinct"
$global:address = "10.0.0.0/8"
$global:subnetName = "demosubnet$distinct"
$global:subnetPreFix = "10.0.0.0/24"
$global:subnetName2 = "storagesubnet$distinct"
$global:subnetPreFix2 = "10.0.1.0/24"
$global:queueName = "taskqueue"
$global:sleepseconds = 2

<#------------------------------------------- ouput-line function ------------#>
Function output-line(){

		param([string]$message)

		$symbol="*"
		$lineLength = 50
		$halfLength = [Int](($lineLength-2-$message.Length)/2)
        $halfLine = $symbol*$halfLength
		$line = "$halfLine $message $halfLine"
        write-host $line
}


<#------------------------------------------- Show Azure Env  ----------------#>
Function get-basicInfo() {
	output-line "Accounts"
	$a = az account list
	$ajson = ($a | convertFrom-Json)
	$ajson | ? {$_.isDefault -eq $true}

	output-line "Azure Resource Groups"
	$g = az group list
	$global:group = ($g | convertFrom-Json)
	$group.name | sort-object
}

<#------------------------------------------- IaC ----------------------------#>
Function create-rg () {
	<# create resource group #>
	output-line "Create Resource Group"
	$result = az group create --name $rgName --location westeurope
	$result >> $logName
	($result | convertFrom-Json).properties.provisioningState | sort-object
	start-sleep -s $sleepseconds
}

Function create-vnet() {
	<# create vnet  #>
	output-line "Create Vnet"
	$result = az network vnet create --resource-group $rgName --name $vnetName --address-prefix $address  --subnet-name $subnetName --subnet-prefix $subnetPreFix
	$result >> $logName
	($result | convertFrom-Json).properties.provisioningState | sort-object
	start-sleep -s $sleepseconds
	create-subnet 
}

Function create-subnet() {
	<# create 2nd subnet  #>
	output-line "Create Vnet-Subnet"
	$result = az network vnet subnet create --resource-group $rgName --vnet-name $vnetName --name $subnetName2 --address-prefix $subnetPreFix2 --service-endpoints 'Microsoft.Storage'
	$result >> $logName
	($result | convertFrom-Json).properties.provisioningState | sort-object
	start-sleep -s $sleepseconds
}

Function create-storage() {
	<#create storage account #>
	output-line "Create Storage Account"
	$result = az storage account create --name $stAcctName --location $location --resource-group $rgName --sku Standard_LRS --only-show-errors
	$result >> $logName
	($result| convertFrom-Json).provisioningState
	start-sleep -s $sleepseconds
	create-queue
}

Function create-queue() {
	<#create storage account #>
	output-line "Create Storage Account-Queue"
	$result = az storage queue create --name $queueName --account-name $stAcctName --auth-mode login
	$result >> $logName
	($result| convertFrom-Json).provisioningState
	start-sleep -s $sleepseconds
}

Function create-functionapp() {
	<#create function app #>
	output-line "Create Function App"
	$result = az functionapp create --consumption-plan-location $location --name $appName --os-type Linux --resource-group $rgName --runtime python --runtime-version '3.6'  --storage-account $stAcctName --functions-version 2 --only-show-errors
	$result >> $logName
	($result| convertFrom-Json).provisioningState
	start-sleep -s $sleepseconds
}

Function create-azObjects() {
	<# checks for resource group and removes it if exist: Not necessary in non demo #>
	if ($rgName -in $group.name) {
		output-line "deleting resource group"
		az group delete --name $rgName --yes
		start-sleep -s 20
		$g = az group list
		$group = ($g | convertFrom-Json)
		$group.name 
	}

	create-rg
	create-vnet 
	create-storage
	create-functionapp
}




<#------------------------------------------- "Build" ----------------------------#>

<#------------------------------------------- Tests ----------------------------#>
Function simple-test() {
	<# get the make a curl call w/url & code value: Need to split to Ptester file #>
	$result = func azure functionapp list-functions $funcAppName --show-keys
	$search = $result | select-string "Invoke"
	$split = $search.ToString().split(" ")
	$url = ($split[$split.Length - 1]).ToString()
	$url = $url + "&name=Testing"
	curl -G $url

}

<#------------------------------------------- Main ----------------------------#>

get-basicInfo
create-azObjects
#build-function
#simple-test

#output-line "sleep...."
#start-sleep -s 60
output-line "clean up"
az group delete --name $rgName --yes

