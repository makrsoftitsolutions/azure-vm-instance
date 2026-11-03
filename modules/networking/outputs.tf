output "subnet_id" {
  description = "ID of the VM subnet."
  value       = azurerm_subnet.main.id
}

output "public_ip_id" {
  description = "ID of the VM public IP resource."
  value       = azurerm_public_ip.main.id
}

output "public_ip_address" {
  description = "Assigned public IPv4 address."
  value       = azurerm_public_ip.main.ip_address
}

output "network_security_group_id" {
  description = "ID of the network security group attached to the VM NIC."
  value       = azurerm_network_security_group.main.id
}