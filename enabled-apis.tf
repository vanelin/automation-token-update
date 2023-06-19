locals {
  services = toset([
    # MUST-HAVE for GitHub Actions setup
    "iam.googleapis.com",                  # Identity and Access Management (IAM) API
    "iamcredentials.googleapis.com",       # IAM Service Account Credentials API
    "cloudresourcemanager.googleapis.com", # Cloud Resource Manager API
    "sts.googleapis.com",                  # Security Token Service API

    # MUST-HAVE for Secret Manager setup
    "secretmanager.googleapis.com", # Secret Manager API
    "pubsub.googleapis.com",        # Cloud Pub/Sub API
    # You can add more apis to enable in the project
  ])
}

resource "google_project_service" "service" {
  for_each                   = local.services
  project                    = var.GOOGLE_PROJECT
  service                    = each.value
  disable_dependent_services = false
}
