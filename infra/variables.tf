
### Project name
variable "project_id" {
    type = string
    description = "Project ID for GCP"
    default = "dangaiden-tf-project"
}

### Region and zone

variable "gcp_region" {
    type = string
    description = "Region for the GCP provider"
    default = "us-west1"
}
variable "gcp_zone" {
    type = string
    description = "Zone for the GCP provider"
    default = "us-west1-c"
}

variable "vpc_subnet" {
  type = string
  description = "CIDR Range for the VPC"
  default = "10.10.1.0/24"
}


