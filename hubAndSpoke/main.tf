# Configure the Azure provider
terraform {
  backend "azurerm" {
    container_name       = "terraform-state"
    key                  = "terraform.tfstate.hubAndSpoke"
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


resource "azurerm_resource_group" "nhrg" {
  name     = "network-hub"
  location = "eastus2"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub"
  location            = azurerm_resource_group.nhrg.location
  resource_group_name = azurerm_resource_group.nhrg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["168.63.129.16", "23.253.163.53", "198.101.242.72"]

}
resource "azurerm_subnet" "gatewaySubnet" {
  name                 = "GatewaySubnet"
  address_prefix       = "10.0.255.0/27"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.nhrg.name
}

resource "azurerm_subnet" "managementSubnet" {
  name                 = "Management"
  address_prefix       = "10.0.255.32/27"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.nhrg.name
}

resource "azurerm_subnet" "azureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  address_prefix       = "10.0.254.0/24"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.nhrg.name
}
