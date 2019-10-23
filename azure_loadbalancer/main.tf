provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

resource "azurerm_public_ip" "test" {
  name                = "pub_ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
}

resource "azurerm_lb" "test" {
  name                = var.lb_name
  location            = var.region
  resource_group_name = var.rg

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}
