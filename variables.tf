variable "subscription_id" {
  description = "Azure subscription ID. Supply through ARM_SUBSCRIPTION_ID or TF_VAR_subscription_id."
  type        = string
}

variable "location" {
  description = "Azure region for the baseline resources."
  type        = string
  default     = "centralindia"
}

variable "network_resource_group_name" {
  description = "Existing resource group for VNets, Firewall, private endpoints, and private DNS."
  type        = string
  default     = "rg-network"
}

variable "platform_resource_group_name" {
  description = "Existing resource group for platform services such as Azure Container Registry."
  type        = string
  default     = "rg-platform"
}

variable "security_resource_group_name" {
  description = "Existing resource group for Azure Key Vault."
  type        = string
  default     = "rg-security"
}

variable "monitoring_resource_group_name" {
  description = "Existing resource group for Log Analytics."
  type        = string
  default     = "rg-monitoring"
}

variable "name_prefix" {
  description = "Short lowercase prefix for resource names."
  type        = string
  default     = "app-dev"

  validation {
    condition     = can(regex("^[a-z0-9-]{2,20}$", var.name_prefix))
    error_message = "name_prefix must contain 2-20 lowercase letters, digits, or hyphens."
  }
}

variable "hub_address_space" {
  description = "IPv4 address space assigned to the hub virtual network."
  type        = list(string)
}

variable "spoke_address_space" {
  description = "IPv4 address space assigned to the AKS production spoke."
  type        = list(string)
}

variable "hub_subnet_prefixes" {
  description = "Subnet name to IPv4 CIDR mapping for the hub virtual network."
  type        = map(string)
}

variable "spoke_subnet_prefixes" {
  description = "Subnet name to IPv4 CIDR mapping for the AKS production spoke."
  type        = map(string)
}

variable "acr_name_prefix" {
  description = "Globally unique lowercase alphanumeric prefix for the container registry."
  type        = string
  default     = "acrappdev"

  validation {
    condition     = can(regex("^[a-z0-9]{3,40}$", var.acr_name_prefix))
    error_message = "acr_name_prefix must contain 3-40 lowercase letters or digits."
  }
}

variable "acr_sku" {
  description = "SKU tier for Azure Container Registry."
  type        = string
  default     = "Premium"

  validation {
    condition     = var.acr_sku == "Premium"
    error_message = "Private Link for this baseline requires the Premium ACR SKU."
  }
}

variable "key_vault_name_prefix" {
  description = "Prefix for the globally unique Key Vault name."
  type        = string
  default     = "kv-app-dev"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,18}$", var.key_vault_name_prefix))
    error_message = "key_vault_name_prefix must contain 3-18 letters, digits, or hyphens."
  }
}

variable "key_vault_sku" {
  description = "SKU tier for Azure Key Vault."
  type        = string
  default     = "standard"

  validation {
    condition     = var.key_vault_sku == "standard"
    error_message = "This baseline provisions a standard Key Vault."
  }
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = var.firewall_sku_tier == "Standard"
    error_message = "This baseline provisions Azure Firewall Standard."
  }
}

variable "log_analytics_retention_days" {
  description = "Workspace data retention period in days."
  type        = number
  default     = 30

  validation {
    condition     = var.log_analytics_retention_days >= 30 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention must be between 30 and 730 days."
  }
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default     = {}
}
