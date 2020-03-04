# Configure the Azure Provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.region

  tags = {
  environment = "customer-success"
}
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "test" {
  name                = var.network_name
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["10.0.0.0/24"]
}
