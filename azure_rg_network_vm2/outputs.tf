description = "Instance ID"
value       = azurerm_virtual_machine.test.id
}

output "public_ip" {
description = "Public IP"
value       = azurerm_network_interface.test.private_ip_address
}

output "private_ip" {
description = "Private IP"
value       = azurerm_public_ip.test.ip_address
}
