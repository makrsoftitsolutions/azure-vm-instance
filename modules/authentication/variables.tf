variable "application_name" {
  description = "Display name for the Entra application used by GitHub Actions."
  type        = string
}

variable "github_oidc_subject" {
  description = "Exact GitHub Actions OIDC subject permitted to federate to this application."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID where the Contributor role is assigned."
  type        = string
}