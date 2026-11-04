variable "location" {
  description = "Azure region for the virtual networks."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the virtual networks and peerings."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the network resources."
  type        = string
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

variable "tags" {
  description = "Tags applied to the virtual networks."
  type        = map(string)
}
