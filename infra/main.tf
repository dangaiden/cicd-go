# Gcloud credentials
# /home/dan/.config/gcloud/application_default_credentials.json
# Read Google Cloud Compoute(GCP) billing account id which is needed
data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
}
provider "google" {
  region = var.gcp_region
  zone   = var.gcp_zone
}

resource "random_id" "id" {
	  byte_length = 6
}

resource "google_project" "project" {
  name       = "${var.project_name}-${random_id.id.dec}"
  project_id = "${var.project_id}-${random_id.id.dec}"
  billing_account = data.google_billing_account.account.id
}

#Enable the necessary services on the project for deployments
resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])

  service = each.key

  project            = var.project_name
  disable_on_destroy = false
}