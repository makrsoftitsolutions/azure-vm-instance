variable "application_object_id" {
  description = "Object ID of the existing Entra application."
  type        = string
}

variable "github_oidc_subject" {
  description = "Exact GitHub Actions OIDC subject trusted by the existing application."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID where the Contributor role is assigned."
  type        = string
}