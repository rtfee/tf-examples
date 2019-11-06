provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

resource "azurerm_virtual_machine" "web_server" {
  name                  = var.vm_name
  location              = var.region
  resource_group_name   = var.rg_name
  network_interface_ids = []
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
