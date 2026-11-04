location                       = "centralindia"
network_resource_group_name    = "rg-network"
platform_resource_group_name   = "rg-platform"
security_resource_group_name   = "rg-security"
monitoring_resource_group_name = "rg-monitoring"
name_prefix                    = "app-dev"

hub_address_space   = ["10.100.0.0/16"]
spoke_address_space = ["10.200.0.0/16"]

hub_subnet_prefixes = {
  GatewaySubnet = "10.100.2.0/24"
  HubMgmtSubnet = "10.100.3.0/24"
}

spoke_subnet_prefixes = {
  AksSystemSubnet  = "10.200.1.0/24"
  AksUserSubnet    = "10.200.2.0/23"
  AppGatewaySubnet = "10.200.4.0/24"
}

acr_name_prefix       = "acrappdev"
acr_sku               = "Premium"
key_vault_name_prefix = "kv-app-dev"
key_vault_sku         = "standard"

log_analytics_retention_days = 30

tags = {
  environment = "dev"
  managed_by  = "terraform"
  workload    = "aks-baseline"
}
