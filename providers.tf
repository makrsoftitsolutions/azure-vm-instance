terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.subscription_id

  # Core provider registration requires subscription-level provider registration permissions.
  resource_provider_registrations = "core"

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
