locals {
  roles = [
    "roles/resourcemanager.projectIamAdmin", # GitHub Actions identity
    # "roles/editor",                          # allow to manage all resources
    "roles/secretmanager.secretAccessor", # allow to access Secret Manager  
    "roles/cloudkms.cryptoKeyEncrypter"   # allow to encrypt only KMS keys                             
  ]
  github_repository_name = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}" # e.g. yourname/yourrepo
}

resource "google_service_account" "github_actions" {
  project      = var.GOOGLE_PROJECT
  account_id   = "github-actions"
  display_name = "github actions"
  description  = "link to Workload Identity Pool used by GitHub Actions"
}

# Allow to access all resources
resource "google_project_iam_member" "roles" {
  project = var.GOOGLE_PROJECT
  for_each = {
    for role in local.roles : role => role
  }
  role   = each.value
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.GOOGLE_PROJECT
  workload_identity_pool_id = var.WORKLOAD_IDENTITY_POOL_NAME
  display_name              = var.WORKLOAD_IDENTITY_POOL_NAME
  description               = "for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.GOOGLE_PROJECT
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "github actions provider"
  description                        = "OIDC identity pool provider for execute GitHub Actions"
  # See. https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    "google.subject"       = "assertion.sub",              # Make the Google Subject the GitHub Identity
    "attribute.repository" = "assertion.repository",       # Custom attribute to see what repository is used
    "attribute.owner"      = "assertion.repository_owner", # The name of the organization in which the repository is stored.
    "attribute.refs"       = "assertion.ref",              # The git ref that triggered the workflow run.
    "attribute.actor"      = "assertion.actor",            # Map the Actor (GitHub User) the Google Actor
    "attribute.aud"        = "assertion.aud"               # Map the audience
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_actions" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${local.github_repository_name}"
}
