terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.0"
    }
  }
}

# Gcloud credentials
# /home/dan/.config/gcloud/application_default_credentials.json

provider "google" {
  region = var.gcp_region
  zone   = var.gcp_zone
}

# Enable the necessary services on the project for deployments
resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}