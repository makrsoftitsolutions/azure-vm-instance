data "azurerm_resource_group" "network" {
  name = var.network_resource_group_name
}

data "azurerm_resource_group" "platform" {
  name = var.platform_resource_group_name
}

data "azurerm_resource_group" "security" {
  name = var.security_resource_group_name
}

data "azurerm_resource_group" "monitoring" {
  name = var.monitoring_resource_group_name
}

module "networking" {
  source = "./modules/networking"

  location              = data.azurerm_resource_group.network.location
  name_prefix           = var.name_prefix
  resource_group_name   = data.azurerm_resource_group.network.name
  hub_address_space     = var.hub_address_space
  spoke_address_space   = var.spoke_address_space
  hub_subnet_prefixes   = var.hub_subnet_prefixes
  spoke_subnet_prefixes = var.spoke_subnet_prefixes
  tags                  = var.tags
}

module "core_services" {
  source = "./modules/core_services"

  acr_name_prefix                = var.acr_name_prefix
  acr_sku                        = var.acr_sku
  firewall_sku_tier              = var.firewall_sku_tier
  firewall_subnet_id             = module.networking.hub_subnet_ids["AzureFirewallSubnet"]
  key_vault_name_prefix          = var.key_vault_name_prefix
  key_vault_sku                  = var.key_vault_sku
  firewall_location              = data.azurerm_resource_group.network.location
  acr_location                   = data.azurerm_resource_group.platform.location
  key_vault_location             = data.azurerm_resource_group.security.location
  monitoring_location            = data.azurerm_resource_group.monitoring.location
  network_location               = data.azurerm_resource_group.network.location
  log_analytics_retention_days   = var.log_analytics_retention_days
  name_prefix                    = var.name_prefix
  private_endpoint_subnet_id     = module.networking.spoke_subnet_ids["AksSystemSubnet"]
  network_resource_group_name    = data.azurerm_resource_group.network.name
  platform_resource_group_name   = data.azurerm_resource_group.platform.name
  security_resource_group_name   = data.azurerm_resource_group.security.name
  monitoring_resource_group_name = data.azurerm_resource_group.monitoring.name
  spoke_vnet_id                  = module.networking.spoke_vnet_id
  tags                           = var.tags
}
