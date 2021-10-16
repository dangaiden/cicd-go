# VPC
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_name}-vpc"
  project                 = var.project_name
  auto_create_subnetworks = "false"
  /*   depends_on = [
    google_project.project,
  ] */
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.name
  project       = var.project_name
  ip_cidr_range = var.vpc_subnet
}
