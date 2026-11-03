variable "admin_username" {
  description = "Linux administrator username for the virtual machine."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the virtual machine."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the compute resources."
  type        = string
}

variable "network_security_group_id" {
  description = "Network security group ID associated with the VM NIC."
  type        = string
}

variable "public_ip_id" {
  description = "Public IP resource ID assigned to the VM NIC."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual machine."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key installed for the administrator account."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM network interface."
  type        = string
}

variable "vm_size" {
  description = "Azure virtual machine size."
  type        = string
}