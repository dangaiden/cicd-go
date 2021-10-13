variable "gcp_region" {
    type = string
    description = "Region for the GCP provider"
    default = "us-west1"
}
variable "gcp_zone" {

    type = string
    description = "Zone for the GCP provider"
    default = "us-west1"
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