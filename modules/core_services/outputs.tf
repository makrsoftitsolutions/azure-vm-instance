output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.main.id
}

output "acr_login_server" {
  description = "Login server hostname of the Azure Container Registry."
  value       = azurerm_container_registry.main.login_server
}

output "key_vault_id" {
  description = "Resource ID of Azure Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "URI of Azure Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.main.id
}

output "acr_private_endpoint_id" {
  description = "Resource ID of the ACR private endpoint."
  value       = azurerm_private_endpoint.acr.id
}

output "key_vault_private_endpoint_id" {
  description = "Resource ID of the Key Vault private endpoint."
  value       = azurerm_private_endpoint.key_vault.id
}
