data "google_client_config" "last" {}

output "gke_endpoint" {
  value = google_container_cluster.primary.endpoint
}

/* output "addresses" {
  description = "List of address values managed by this module"
  value       = module.address.addresses
} */

output "kubectl" {
  value = <<EOT
  Renew your kube config file by executing: 
  $ gcloud container clusters get-credentials ${google_container_cluster.primary.name}
  EOT
}