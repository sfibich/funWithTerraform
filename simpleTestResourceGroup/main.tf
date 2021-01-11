# Configure the Azure provider

terraform {
	backend "azurerm" {
		storage_account_name = "a4xhqldweterraform"
		container_name = "terraform-state"
		key = "terraform.tfstate.sfibich.simpleTest"
	}
}

provider "azurerm" {
	features {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "simpleTest"
  location = "eastus2"
}




