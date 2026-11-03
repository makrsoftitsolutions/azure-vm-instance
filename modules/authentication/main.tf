data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

resource "azuread_application" "github_actions" {
  display_name     = var.application_name
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  application_object_id = azuread_application.github_actions.object_id
  display_name          = "github-actions"
  description           = "GitHub Actions OIDC federation for the configured repository subject."
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = var.github_oidc_subject
}

resource "azurerm_role_assignment" "contributor" {
  name                             = uuidv5("dns", "${var.subscription_id}/${azuread_service_principal.github_actions.object_id}/Contributor")
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.github_actions.object_id
  skip_service_principal_aad_check = true
}