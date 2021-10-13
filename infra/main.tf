terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.0"
    }
  }
}

provider "google" {
  region = var.gcp_region
  zone   = var.gcp_zone
}

