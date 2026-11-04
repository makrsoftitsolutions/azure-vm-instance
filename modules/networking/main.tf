resource "azurerm_virtual_network" "hub" {
  name                = "${var.name_prefix}-hub-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_address_space
  tags                = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "${var.name_prefix}-aks-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "hub" {
  for_each = var.hub_subnet_prefixes

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "spoke" {
  for_each = var.spoke_subnet_prefixes

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value]

  private_endpoint_network_policies = each.key == "AksSystemSubnet" ? "Disabled" : "Enabled"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${var.name_prefix}-hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${var.name_prefix}-spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
