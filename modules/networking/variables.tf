variable "location" {
  description = "Azure region in which to create the network resources."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the network resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the network resources."
  type        = string
}

variable "ssh_source_address_prefix" {
  description = "Source CIDR allowed to access SSH on the VM."
  type        = string
}