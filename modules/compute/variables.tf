variable "admin_username" {
  description = "Linux administrator account created on the virtual machine."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual machine."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the virtual machine and network interface."
  type        = string
}

variable "network_security_group_id" {
  description = "Network security group attached to the virtual machine network interface."
  type        = string
}

variable "public_ip_id" {
  description = "Public IP resource ID assigned to the virtual machine network interface."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual machine."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key installed for the Linux administrator account."
  type        = string
}

variable "subnet_id" {
  description = "Subnet resource ID for the virtual machine network interface."
  type        = string
}

variable "vm_size" {
  description = "Azure virtual machine size."
  type        = string
}
