data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

data "azuread_application" "github_actions" {
  object_id = var.application_object_id
}

data "azuread_service_principal" "github_actions" {
  client_id = data.azuread_application.github_actions.client_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  application_id = "/applications/${var.application_object_id}"
  display_name   = "azure-vm-instance-main-trust"
  description    = "Allows azure-vm-instance repo to deploy via OIDC"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = var.github_oidc_subject
}

resource "azurerm_role_assignment" "contributor" {
  name                             = uuidv5("dns", "${var.subscription_id}/${data.azuread_service_principal.github_actions.object_id}/Contributor")
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azuread_service_principal.github_actions.object_id
  skip_service_principal_aad_check = true
}