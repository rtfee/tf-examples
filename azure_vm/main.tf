# Configure the Azure Provider
provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

resource "azurerm_network_interface" "test" {
  name                = var.net_interface_name
  location            = var.region
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "cs-public"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "web_server" {
  name                  = var.vm_name
  location              = var.region
  resource_group_name   = var.rg_name
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = var.instance_type

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name      = "server"
    admin_username     = "server"
    admin_password     = "Passw0rd1234"

  }

  os_profile_windows_config {
  }

}