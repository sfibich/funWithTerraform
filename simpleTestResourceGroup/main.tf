# Configure the Azure provider
terraform {
  backend "azurerm" {
    container_name       = "terraform-state"
    key                  = "terraform.tfstate.simpleTestResourceGroup"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "simpleTest"
  location = "eastus2"
}




