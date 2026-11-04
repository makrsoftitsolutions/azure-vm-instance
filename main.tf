module "networking" {
  source = "./modules/networking"

  location              = var.location
  name_prefix           = var.name_prefix
  resource_group_name   = var.network_resource_group_name
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
  key_vault_name_prefix          = var.key_vault_name_prefix
  key_vault_sku                  = var.key_vault_sku
  location                       = var.location
  log_analytics_retention_days   = var.log_analytics_retention_days
  name_prefix                    = var.name_prefix
  private_endpoint_subnet_id     = module.networking.spoke_subnet_ids["AksSystemSubnet"]
  network_resource_group_name    = var.network_resource_group_name
  platform_resource_group_name   = var.platform_resource_group_name
  security_resource_group_name   = var.security_resource_group_name
  monitoring_resource_group_name = var.monitoring_resource_group_name
  spoke_vnet_id                  = module.networking.spoke_vnet_id
  tags                           = var.tags
}
