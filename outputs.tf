output "resource_group_name" {
  description = "Name of the resource group containing the baseline."
  value       = azurerm_resource_group.main.name
}

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.networking.hub_vnet_id
}

output "hub_subnet_ids" {
  description = "Subnet resource IDs in the hub virtual network."
  value       = module.networking.hub_subnet_ids
}

output "spoke_vnet_id" {
  description = "Resource ID of the AKS production spoke virtual network."
  value       = module.networking.spoke_vnet_id
}

output "spoke_subnet_ids" {
  description = "Subnet resource IDs in the AKS production spoke."
  value       = module.networking.spoke_subnet_ids
}

output "firewall_id" {
  description = "Resource ID of the Azure Firewall."
  value       = module.core_services.firewall_id
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall."
  value       = module.core_services.firewall_private_ip
}

output "firewall_public_ip" {
  description = "Public IP address assigned to the Azure Firewall."
  value       = module.core_services.firewall_public_ip
}

output "acr_id" {
  description = "Resource ID of the private Azure Container Registry."
  value       = module.core_services.acr_id
}

output "acr_login_server" {
  description = "Login server hostname of the private Azure Container Registry."
  value       = module.core_services.acr_login_server
}

output "key_vault_id" {
  description = "Resource ID of the RBAC-enabled Key Vault."
  value       = module.core_services.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the RBAC-enabled Key Vault."
  value       = module.core_services.key_vault_uri
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the centralized Log Analytics workspace."
  value       = module.core_services.log_analytics_workspace_id
}
