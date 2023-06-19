resource "random_id" "random_topic_id_suffix" {
  byte_length = 2
}

resource "google_pubsub_topic" "secret" {
  project = var.GOOGLE_PROJECT
  name    = "webhook-topic-${random_id.random_topic_id_suffix.hex}"
  depends_on = [
    google_project_service.service["pubsub.googleapis.com"],
  ]
}

resource "google_project_service_identity" "secretmanager_identity" {
  provider = google-beta
  project  = var.GOOGLE_PROJECT
  service  = "secretmanager.googleapis.com"
}

resource "google_pubsub_topic_iam_member" "sm_sa_publisher" {
  project = var.GOOGLE_PROJECT
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_project_service_identity.secretmanager_identity.email}"
  topic   = google_pubsub_topic.secret.name
}

module "secret-manager" {
  source     = "GoogleCloudPlatform/secret-manager/google"
  project_id = var.GOOGLE_PROJECT
  secrets = [
    {
      name                  = var.SECRET_NAME
      automatic_replication = true
      secret_data           = var.SECRET_DATA
    },
  ]
  topics = {
    "${var.SECRET_NAME}" = [
      {
        name = google_pubsub_topic.secret.id
      }
    ]
  }
  labels = {
    "${var.SECRET_NAME}" = {
      key1 : "telegram",
      managed_by : "terraform",
    }
  }
  depends_on = [
    google_pubsub_topic_iam_member.sm_sa_publisher,
    google_project_service.service["secretmanager.googleapis.com"]
  ]
}
