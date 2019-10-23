# Configure the Azure Provider
provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.region
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "test" {
  name                = var.network_name
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = var.cidr
}
