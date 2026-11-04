output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.hub.name
}

output "hub_subnet_ids" {
  description = "Subnet resource IDs in the hub virtual network."
  value       = { for name, subnet in azurerm_subnet.hub : name => subnet.id }
}

output "spoke_vnet_id" {
  description = "Resource ID of the AKS production spoke virtual network."
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  description = "Name of the AKS production spoke virtual network."
  value       = azurerm_virtual_network.spoke.name
}

output "spoke_subnet_ids" {
  description = "Subnet resource IDs in the AKS production spoke."
  value       = { for name, subnet in azurerm_subnet.spoke : name => subnet.id }
}
