terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {}
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

removed {
  from = module.authentication.azuread_application.github_actions

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.authentication.azuread_service_principal.github_actions

  lifecycle {
    destroy = false
  }
}

import {
  to = module.authentication.azuread_application_federated_identity_credential.github_actions
  id = "53fbfbcf-26a1-4235-995e-9ed994f758c1/federatedIdentityCredential/786b8838-ce12-4394-a1b7-7f56016f4d57"
}

module "authentication" {
  source = "./modules/authentication"

  application_object_id = var.application_object_id
  github_oidc_subject   = var.github_oidc_subject
  subscription_id       = var.subscription_id
}

module "networking" {
  source = "./modules/networking"

  location                  = var.location
  name_prefix               = var.name_prefix
  resource_group_name       = azurerm_resource_group.main.name
  ssh_source_address_prefix = var.ssh_source_address_prefix
}

module "compute" {
  source = "./modules/compute"

  admin_username            = var.vm_admin_username
  location                  = var.location
  name_prefix               = var.name_prefix
  network_security_group_id = module.networking.network_security_group_id
  public_ip_id              = module.networking.public_ip_id
  resource_group_name       = azurerm_resource_group.main.name
  ssh_public_key            = var.vm_admin_ssh_public_key
  subnet_id                 = module.networking.subnet_id
  vm_size                   = var.vm_size
}