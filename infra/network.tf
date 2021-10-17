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


# This could be used to reserve an static IP and then changing it
# in your DNS provider.

/* resource "google_compute_global_address" "external_ip" {
  provider      = google-beta
  name          = "global-psconnect-ip"
  address_type  = "EXTERNAL"
  network       = google_compute_network.network.id
  project = var.project_id
  #address       
  #Ommitting address in purpose to let GCP choose an available one.
} */