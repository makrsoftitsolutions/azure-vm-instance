variable "location" {
  description = "Azure region in which to deploy the infrastructure."
  type        = string
  default     = "eastus"
}

variable "subscription_id" {
  description = "Azure subscription ID in which to deploy resources and assign the GitHub Actions role."
  type        = string
  default     = "aa61b080-74f9-41ed-a75f-8e60a60ccae4"

  validation {
    condition     = lower(var.subscription_id) == "aa61b080-74f9-41ed-a75f-8e60a60ccae4"
    error_message = "subscription_id must be aa61b080-74f9-41ed-a75f-8e60a60ccae4."
  }
}

variable "resource_group_name" {
  description = "Name of the Azure resource group for the container host."
  type        = string
  default     = "rg-azure-vm-instance"
}

variable "name_prefix" {
  description = "Lowercase prefix used to name the deployed resources."
  type        = string
  default     = "azurevm"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,20}$", var.name_prefix))
    error_message = "name_prefix must contain 1-20 lowercase letters, digits, or hyphens."
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