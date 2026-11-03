output "azure_client_id" {
  description = "Client ID of the existing GitHub Actions Entra application."
  value       = module.authentication.client_id
}

output "azure_tenant_id" {
  description = "Entra tenant ID used by the active Azure provider."
  value       = data.azurerm_client_config.current.tenant_id
}

output "azure_subscription_id" {
  description = "Azure subscription ID used by this deployment."
  value       = data.azurerm_client_config.current.subscription_id
}

output "instance_public_ip" {
  description = "Public IPv4 address assigned to the container host."
  value       = module.networking.public_ip_address
}