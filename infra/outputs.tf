#data "google_client_config" "current" {}

output "gke_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "project" {
  value = data.google_client_config.current.project
}

output "config_current_id" {
  value = data.google_client_config.current.id
}