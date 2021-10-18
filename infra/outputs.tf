/* output "gke_endpoint" {
  value = google_container_cluster.primary.endpoint
} */

output "kubectl_update" {
  value = <<EOT
  Renew your kube config file by executing: 
  gcloud container clusters get-credentials ${google_container_cluster.primary.name}
  export KUBE_CONFIG_PATH=~/.kube/config
  EOT
}