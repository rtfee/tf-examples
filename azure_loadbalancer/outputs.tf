output "public_ip" {
  description = "Public IP"
  value       = azurerm_public_ip.test.ip_address
}

output "loadbalancer" {
  description = "Loadbalancer Name"
  value       = azurerm_lb.test.name
}
