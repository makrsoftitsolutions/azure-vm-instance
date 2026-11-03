output "client_id" {
  description = "Client ID of the existing Entra application."
  value       = data.azuread_application.github_actions.client_id
}

output "service_principal_object_id" {
  description = "Object ID of the application's service principal."
  value       = data.azuread_service_principal.github_actions.object_id
}