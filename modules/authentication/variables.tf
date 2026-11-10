variable "application_name" {
  description = "Display name of the GitHub Actions Entra application."
  type        = string
}

variable "github_oidc_subject" {
  description = "Exact GitHub Actions OIDC subject allowed to authenticate."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription receiving the deployment role assignment."
  type        = string
}
