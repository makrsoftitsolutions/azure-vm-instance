resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "./modules/networking"

  location              = azurerm_resource_group.main.location
  name_prefix           = var.name_prefix
  resource_group_name   = azurerm_resource_group.main.name
  hub_address_space     = var.hub_address_space
  spoke_address_space   = var.spoke_address_space
  hub_subnet_prefixes   = var.hub_subnet_prefixes
  spoke_subnet_prefixes = var.spoke_subnet_prefixes
  tags                  = var.tags
}

module "core_services" {
  source = "./modules/core_services"

  acr_name_prefix              = var.acr_name_prefix
  acr_sku                      = var.acr_sku
  firewall_sku_tier            = var.firewall_sku_tier
  firewall_subnet_id           = module.networking.hub_subnet_ids["AzureFirewallSubnet"]
  key_vault_name_prefix        = var.key_vault_name_prefix
  key_vault_sku                = var.key_vault_sku
  location                     = azurerm_resource_group.main.location
  log_analytics_retention_days = var.log_analytics_retention_days
  name_prefix                  = var.name_prefix
  private_endpoint_subnet_id   = module.networking.spoke_subnet_ids["AksSystemSubnet"]
  resource_group_name          = azurerm_resource_group.main.name
  spoke_vnet_id                = module.networking.spoke_vnet_id
  tags                         = var.tags
}
