variable "location" {
  description = "Azure region for the core services."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the core services."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the core services."
  type        = string
}

variable "firewall_subnet_id" {
  description = "Resource ID of the hub AzureFirewallSubnet."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Resource ID of the spoke subnet hosting private endpoints."
  type        = string
}

variable "spoke_vnet_id" {
  description = "Resource ID of the AKS spoke virtual network for private DNS links."
  type        = string
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
}

variable "acr_name_prefix" {
  description = "Lowercase alphanumeric prefix for the globally unique registry name."
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU tier."
  type        = string
}

variable "key_vault_name_prefix" {
  description = "Prefix for the globally unique Key Vault name."
  type        = string
}

variable "key_vault_sku" {
  description = "Azure Key Vault SKU tier."
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Log Analytics data retention period in days."
  type        = number
}

variable "tags" {
  description = "Tags applied to the core services."
  type        = map(string)
}
