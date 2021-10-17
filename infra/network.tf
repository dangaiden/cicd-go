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

/* module "address" {
  source       = "terraform-google-modules/address/google"
  version      = "3.0.0"
  project_id   = var.project_id
  region       = var.gcp_region
  address_type = "EXTERNAL"
  names = [
    "regional-external-ip-address-1",
  ]
} */