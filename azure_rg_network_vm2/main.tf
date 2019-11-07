# refer to a resource group

provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

data "azurerm_resource_group" "test" {
  name = var.rg_name
}

#refer to a subnet
data "azurerm_subnet" "test" {
  name                 = var.subnet_name
#  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}

# Create public IPs
resource "azurerm_public_ip" "test" {
    name                         = var.vm_name
    location                     = "${data.azurerm_resource_group.test.location}"
    resource_group_name          = "${data.azurerm_resource_group.test.name}"
    public_ip_address_allocation = "dynamic"

}

# create a network interface
resource "azurerm_network_interface" "test" {
  name                = var.vm_name
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = "${data.azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "test" {
    name                  = var.vm_name
    location              = "${azurerm_network_interface.test.location}"
    resource_group_name   = "${data.azurerm_resource_group.test.name}"
    network_interface_ids = ["${azurerm_network_interface.test.id}"]
    vm_size               = "Standard_DS1_v2"

# Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination = true

# Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
   storage_os_disk {
    name              = var.vm_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
   os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
   os_profile_linux_config {
    disable_password_authentication = false
  }

}
