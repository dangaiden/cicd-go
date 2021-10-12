# Requirements

- APIs are enabled with Terraform so you don't need to do it in the first deployment.
- A GitHub account obviously.
- Terraform installed (v1.0.8 used)
- A GCP account
- Install and configure [gcloud-sdk] (https://cloud.google.com/sdk/docs/quickstarts)

# Steps performed:

- [ ] DNS (Domain and NS)
- [x] Network: VPC and subnet
- [ ] Permissions: IAM
- [ ] Dockerfile
- [ ] GCR
- [ ] GKE
- [ ] Ingress: Traefik deployed in GKE
- [ ] App: Deployment in GKE

- [ ] Perform everything in TF

- [ ] Now in GH actions

- [ ] Modify the app to add a new handler.

# Flowchart.

1. "terraform apply" for deliver all the GCP and GKE infrastructure with Traefik configured.
2. Push a change to the repository in the app folder to trigger a GH action.
3. The GH action will:
    3.1
    3.2
    3.3

# First step

 gcloud init
Welcome! This command will take you through the configuration of gcloud.

Your current configuration has been set to: [default]
# Create project

$PROJECT_NAME = "dangaiden-go-cicd"
gcloud projects create $PROJECT_NAME --set-as-default

## Alternative

gcloud config configurations list

- Config your region (cheapest one):

gcloud config set compute/region us-west1

#  Config your zone (cheapest one)

gcloud config set compute/zone us-west1-c

# Logging

$ gcloud auth application-default login
Your browser has been opened to visit:

    https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8085%2F&scope=openid+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&state=463vFGNp0s1IijFOsd82NGD5vb3yOD&access_type=offline&code_challenge=yHfPfXVrJqEMMYGx8FGnrhVGEoRHddzk8eNDOd8siX8&code_challenge_method=S256


Credentials saved to file: [/home/dan/.config/gcloud/application_default_credentials.json]

These credentials will be used by any library that requests Application Default Credentials (ADC).

Quota project "dangaiden-go-cicd" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.

# Enabling the Billing (needed) API and other APIs.

``Billing required
Compute Engine API requires a project with a billing account.``

$ gcloud services enable compute.googleapis.com
Operation "operations/acf.p2-387603574801-7b56174e-8427-4c66-b4f6-71c4fb5f6de7" finished successfully.

gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services enable domains.googleapis.com

# Create VPC (Global)

gcloud compute networks create vpc-cicd --subnet-mode custom

# Create FW rules

gcloud compute firewall-rules create fwr-permit-all --network vpc-cicd --allow tcp,udp,icmp --source-ranges 0.0.0.0/0

# Create subnet

gcloud compute networks subnets create vpc-cicd-snet-1 --network vpc-cicd --region us-west1 --range 10.10.1.0/24

# Provision GKE cluster.

gcloud container clusters create gke-app-1 --cluster-version=1.21\
 --logging=SYSTEM,WORKLOAD --machine-type=e2-standard-2\
 --monitoring=SYSTEM --network vpc-cicd --subnetwork=vpc-cicd-snet-1 --preemptible --enable-master-authorized-networks\
 --master-authorized-networks=0.0.0.0/0 --zone us-west1-c

~OUTPUT:

Creating cluster gke-app-1 in us-west1-c...done.                                                                                                                                                               
Created [https://container.googleapis.com/v1/projects/dangaiden-go-cicd/zones/us-west1-c/clusters/gke-app-1].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-west1-c/gke-app-1?project=dangaiden-go-cicd
kubeconfig entry generated for gke-app-1.
NAME       LOCATION    MASTER_VERSION   MASTER_IP      MACHINE_TYPE   NODE_VERSION     NUM_NODES  STATUS
gke-app-1  us-west1-c  1.21.4-gke.2300  34.83.131.168  e2-standard-2  1.21.4-gke.2300  3          RUNNING


$ kubectl get nodes
NAME                                       STATUS   ROLES    AGE   VERSION
gke-gke-app-1-default-pool-b2d97aaf-4rm3   Ready    <none>   12m   v1.21.4-gke.2300
gke-gke-app-1-default-pool-b2d97aaf-sz62   Ready    <none>   12m   v1.21.4-gke.2300
gke-gke-app-1-default-pool-b2d97aaf-vhx6   Ready    <none>   12m   v1.21.4-gke.2300

# Created generic SA via GUI

genericsa@dangaiden-go-cicd.iam.gserviceaccount.com
Roles:  Kubernetes Engine Service Agent

---
# Register domain (dangiaden.com)

gcloud beta domains registrations search-domains dangaiden.com

## Check if available
gcloud beta domains registrations get-register-parameters dangaiden.com


## Register domain
gcloud beta domains registrations register dangaiden.com

---

## Deploy traefik

Configuration Requirements

All Steps for a Successful Deployment

- [ ] Create a dedicated namespace
- [ ] Add the Traefik resources definitions
- [ ] Add the RBAC for the Traefik custom resources
- [ ] Use a custom Traefik Deployment
- [ ]   Enable the kubernetesCRD provider
- [ ]   Apply the needed kubernetesCRD provider configuration
- [ ] Add all necessary Traefik custom resources
