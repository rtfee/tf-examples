# Configure the Azure Provider
provider "azurerm" {
    subscription_id = var.scalr_azurerm_subscription_id
    client_id = var.scalr_azurerm_client_id
    client_secret = var.scalr_azurerm_client_secret
    tenant_id = var.scalr_azurerm_tenant_id
}

# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = var.rg_name
  location = var.region

  tags = {
  environment = "customer-success"
}
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "test" {
  name                = var.network_name
  resource_group_name = var.rg_name
  location            = "${azurerm_resource_group.test.location}"
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "test" {
  name                 = "test"
  resource_group_name  = var.rg_name
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_interface" "test" {
  name                = var.net_interface_name
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "test" {
  name                  = var.vm_name
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = var.rg_name
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = var.instance_type

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
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
  tags = {
    environment = "staging"
  }
}
