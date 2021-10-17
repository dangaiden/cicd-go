###############################
### Project configurations
###############################
variable "project_name" {
  type        = string
  description = "Project ID for GCP"
  default     = "october-cicd-go"
}
variable "project_id" {
  type        = string
  description = "Project ID for GCP"
  default     = "october-cicd-go"
}
variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list(any)
}

###############################
### GCP Region and zone
###############################

variable "gcp_region" {
  type        = string
  description = "Region for the GCP provider"
  default     = "us-west1"
}
variable "gcp_zone" {
  type        = string
  description = "Zone for the GCP provider"
  default     = "us-west1-c"
}

variable "vpc_subnet" {
  type        = string
  description = "CIDR Range for the VPC"
  default     = "10.10.1.0/24"
}

##########################
##### GKE
##########################


variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {
      # External network that can access Kubernetes master through HTTPS. Must
      # be specified in CIDR notation. This block should allow access from any
      # address, but is given explicitly to prevent Google's defaults from
      # fighting with Terraform.
      cidr_block = "0.0.0.0/0"
      # Field for users to identify CIDR blocks.
      display_name = "default access to everyone (not limited)"
    },
  ]

  description = <<EOF
Defines up to 20 external networks that can access Kubernetes master
through HTTPS.
EOF
}

variable "min_master_version" {
  default     = "1.21"
  description = "Minimum version for the K8s master node managed by GCP"
}

variable "nodes_type" {
  default     = "e2-standard-2"
  description = "Machine type for GKE nodes"
}

#####################
### 
#####################

#####################
### OTHERS
#####################
#variable "credentials_file" { }