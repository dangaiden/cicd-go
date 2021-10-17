# Requirements

- APIs are enabled with Terraform so you don't need to do it in the first deployment.
- A GitHub account obviously.
- Terraform installed (v1.0.8 used)
- A GCP account with a project created and Billing linked
- Install and configure [gcloud-sdk] (https://cloud.google.com/sdk/docs/quickstarts)
- Kubernetes 1.14+
- Helm version 3.x is [installed] (https://helm.sh/docs/intro/install/)

# Useful commands

export KUBECONFIG="$PWD/kubeconfig_{{name}}-eks"

# Useful links

https://registry.terraform.io/providers/hashicorp/google/latest/docs
# Steps performed:

- [x] DNS (Domain and NS)
- [x] Network: VPC and subnet
- [x] Permissions: IAM
- [x] Dockerfile
- [x] GCR
- [x] GKE
- [x] Ingress: Traefik deployed in GKE
- [x] App: Deployment in GKE
- [ ] Let's encrypt certificates.

- [ ] Perform everything in TF (Friday and Saturday)

- [ ] Now in GH actions (Sunday?)

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

PROJECT_NAME="dangaiden-go-cicd"
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

# Create External IP address (not needed)

gcloud compute addresses create public-ipaddr --project=dangaiden-go-cicd --network-tier=STANDARD --region=us-central1

# Provision GKE cluster.

gcloud container clusters create dan-1410-cluster --cluster-version=1.21\
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


# Install traefik with Helm

https://doc.traefik.io/traefik/v2.4/getting-started/install-traefik/#use-the-helm-chart

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm search repo traefik
NAME           	CHART VERSION	APP VERSION	DESCRIPTION                                  
traefik/traefik	10.6.0       	2.5.3      	A Traefik based Kubernetes ingress controller

```bash
helm install traefikv2 traefik/traefik -n traefik --create-namespace\
 --set allowCrossNamespace=true\
 --values "traefik-values.yaml"
```

helm upgrade traefikv2 traefik/traefik -n traefik --values "traefik-values.yaml"




kubectl apply -f k8s/helm_traefik/ingressroute-dashboard.yaml

## Checking all is correct
kubectl -n traefik get all

Access http://traefik-ui.example.com/dashboard/

# Using GCR

- Example with SA
/gcloud auth login
/gcloud auth activate-service-account --key-file=.secrets/gcp.json
/gcloud auth configure-docker -q
/checkout

## Process
docker build -t goserver .
docker tag goserver:latest gcr.io/$PROJECT_NAME/goserver:v1
docker push gcr.io/$PROJECT_NAME/goserver:v1
docker pull gcr.io/$PROJECT_NAME/goserver:v1
---
- Example
gcloud auth configure-docker
docker tag gcr.io/google-samples/hello-app:1.0 gcr.io/$PROJECT_NAME/quickstart-image:tag1
docker push gcr.io/$PROJECT_NAME/quickstart-image:tag1

# Deploying app

kubectl create namespace application
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-routes.yaml


# Generate certificates

## Set up an IAM role (Create a Policy in AWS Console)

Policy name: DNS-Route53-role 

Using the JSON: https://cert-manager.io/docs/configuration/acme/dns01/route53/

Paste the content in JSON window:

``` bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}

```

## Create Access and Secret Keys in AWS

Going to IAM > Add User > Access-Programmatic access
Name:route53-user
Custom password: DMEQ72SM@60
Attach existing policies directly -> DNS-Route53-role 




## Create secret in k8s

kubectl create secret generic acme-route53 --from-file=secret-access-key=[YOU_SECRET_ACCESS_KEY_FILE]

## We will use this Helm Chart to define some things:

https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

- Add the Jetstack Helm repository
$ helm repo add jetstack https://charts.jetstack.io
- Install the cert-manager helm chart
$ helm install cert-manager -n cert-manager --create-namespace \
 --values "cert-manager-values.yaml" \
 --version v1.5.3 jetstack/cert-manager


## Cluster Issuer

Follow details for: https://cert-manager.io/docs/configuration/acme/dns01/route53/

# Created generic SA via GUI

gcloud iam service-accounts create images-sa --display-name="SA for managing Docker images"

gcloud iam service-accounts create k8s-dns-sa --display-name="DNS Service Account"

# EXPORT current kubeconfig for being able to destroy after using HELM.

gcloud container clusters get-credentials <cluster-name>
gcloud container clusters get-credentials october-cicd-go-cl
export KUBE_CONFIG_PATH=~/.kube/config
terraform destroy
