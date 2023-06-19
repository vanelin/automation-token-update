output "service_account_github_actions_email" {
  description = "Service Account used by GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "google_iam_workload_identity_pool_provider_github_name" {
  description = "Workload Identity Pool Provider ID"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "secret_names" {
  value       = module.secret-manager.secret_names
  description = "List of secret names"
}

output "secret_versions" {
  value       = module.secret-manager.secret_versions
  description = "List of secret versions"
}

output "google_pubsub_topic_name" {
  value       = google_pubsub_topic.secret.name
  description = "Pub/Sub topic name"
}
