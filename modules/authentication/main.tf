resource "azuread_application" "main" {
  display_name = var.application_name
}

resource "azuread_service_principal" "main" {
  client_id = azuread_application.main.client_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  application_id = azuread_application.main.id
  display_name   = "GitHub Actions"
  description    = "Federated identity for GitHub Actions deployments."
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = var.github_oidc_subject
}

resource "azurerm_role_assignment" "contributor" {
  scope                            = "/subscriptions/${var.subscription_id}"
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.main.object_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}
