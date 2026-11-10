terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {}
}

provider "azuread" {}

provider "azurerm" {
  resource_provider_registrations = "core"

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
