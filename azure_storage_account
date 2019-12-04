provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

resource "azurerm_storage_account" "example" {
  name                     = var.storageaccountname
  resource_group_name      = var.resourcegroup
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
