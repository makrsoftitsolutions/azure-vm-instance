variable "location" {
  description = "Azure region in which to deploy the infrastructure."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group for the container host."
  type        = string
  default     = "rg-azure-vm-instance"
}

variable "github_oidc_subject" {
  description = "Exact GitHub Actions OIDC subject allowed to authenticate to Azure."
  type        = string
  default     = "repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:*"
}

variable "name_prefix" {
  description = "Lowercase prefix used to name the deployed resources."
  type        = string
  default     = "azurevm"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,12}$", var.name_prefix))
    error_message = "name_prefix must contain 1-12 lowercase letters, digits, or hyphens."
  }
}

variable "vm_admin_username" {
  description = "Linux administrator account created on the virtual machine."
  type        = string
  default     = "azureuser"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.vm_admin_username))
    error_message = "vm_admin_username must be a valid Linux account name."
  }
}

variable "vm_admin_ssh_public_key" {
  description = "SSH public key installed for the Linux administrator account."
  type        = string
}

variable "vm_size" {
  description = "Azure virtual machine size. Standard_B1s is eligible for some Azure free-account offers."
  type        = string
  default     = "Standard_B1s"
}