## Default gcloud credentials
# /home/<user>/.config/gcloud/application_default_credentials.json

provider "google" {
  #credentials = file(var.credentials_file)
  region = var.gcp_region
  zone   = var.gcp_zone
}


## Enable the necessary services on the project for deployments

resource "google_project_service" "gcp_services" {
  count   = length(var.gcp_service_list)
  project = var.project_id
  service = var.gcp_service_list[count.index]
  #disable_dependent_services = false
  disable_on_destroy = false
}

/*I am avoiding creating projects because of how GCP handles it.
The project doesn't get deleted but in an inactive status and
associated with a Billing account which can cause your quota
to exceed.

 resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_name
  billing_account = data.google_billing_account.account.id
} */


# Read Google Cloud Compoute(GCP) billing account id which is needed
/* data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
} */


## Kubeconfig file

/* resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
} */