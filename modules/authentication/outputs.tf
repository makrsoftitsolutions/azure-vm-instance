output "client_id" {
  description = "Client ID of the GitHub Actions Entra application."
  value       = azuread_application.main.client_id
}
