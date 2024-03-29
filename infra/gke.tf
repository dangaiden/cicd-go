################################################
######### GKE CLUSTER DEFINITION ############
################################################
resource "google_container_cluster" "primary" {
  name     = "${var.project_name}-cl"
  location = var.gcp_zone
  project  = var.project_name
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = var.min_master_version


  ### MASTER AUTHORIZED NETWORKS (EXTERNAL IPs ACCESS)
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }

  }

  ######################################################  
  ########## NODE CONFIGURATION (MASTER) ############
  ######################################################

  node_config {
    // https://cloud.google.com/sdk/gcloud/reference/container/node-pools/create#--scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    preemptible  = true
    machine_type = var.nodes_type
    tags         = ["gke-node", "${var.project_id}-gke"]

  }

  cluster_autoscaling {
    enabled = false
  }

  # Timeouts for operations within the node.
  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
  depends_on = [
    google_compute_network.vpc_network,
  ]

}

##########################################
######### NODEPOOL DEFINITION ############
##########################################
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.project_name}-node-pool"
  location   = var.gcp_zone
  project    = var.project_name
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.nodes_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


################################################
############ HELM definitions #######################
################################################
data "google_client_config" "current" {}

#https://registry.terraform.io/providers/hashicorp/helm/latest/docs
provider "helm" {

  kubernetes {
    host = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.current.access_token
    
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

############################## 
### Helm release of Nginx
##############################

# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
resource "helm_release" "nginx" {
  name             = "nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress"
  version          = "4.0.1"
  create_namespace = true
  values           = [file("manifests/nginx-values.yaml")]

  depends_on = [
    google_container_node_pool.primary_preemptible_nodes
  ]

}
####################################
### Helm release of Cert-manager
####################################
resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  version          = "1.5.3"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    google_container_node_pool.primary_preemptible_nodes
  ]

}