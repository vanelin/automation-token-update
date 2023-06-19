variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project name"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1-c"
  description = "GCP region to use"
}

variable "GITHUB_OWNER" {
  type        = string
  description = "GitHub owner repository to use"
}

variable "GITHUB_TOKEN" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

# Specify the name of the infrastructure repository already created for the Flux-CD
variable "FLUX_GITHUB_REPO" {
  type        = string
  default     = "gke-flux-gitops"
  description = "Flux GitOps repository"
}

variable "SECRET_DATA" {
  type        = string
  description = "Secret token for TELE_TOKEN"
  sensitive   = true
}

variable "SECRET_NAME" {
  type        = string
  default     = "TELE_TOKEN"
  description = "Secret name"
}

variable "WORKLOAD_IDENTITY_POOL_NAME" {
  type        = string
  default     = "github-action"
  description = "Workload Identity Pool name"
}
