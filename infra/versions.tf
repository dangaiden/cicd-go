terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.87.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }
  }
  required_version = "1.0.8"
}