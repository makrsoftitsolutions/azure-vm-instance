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