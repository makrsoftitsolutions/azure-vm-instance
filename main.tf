data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "authentication" {
  source = "./modules/authentication"

  application_name    = "${var.name_prefix}-github-actions"
  github_oidc_subject = var.github_oidc_subject
  subscription_id     = data.azurerm_client_config.current.subscription_id
}

module "networking" {
  source = "./modules/networking"

  location            = var.location
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.main.name
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