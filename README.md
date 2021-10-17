

# Requisites

- A GitHub account obviously.
- Terraform installed (v1.0.8 used)
- A GCP account with a **project already created and Billing **linked**.
- Install and configure [gcloud-sdk] (https://cloud.google.com/sdk/docs/quickstarts)
- kubectl installed

> For HTTPS ACME , you will need a **public domain registered** and configure additional permissions, otherwise you won't be able to issue certificates to your endpoints.
I haven't been able to set up (using DNS01 challenge) correctly due to having my domain in Route53 and the GKE cluster in GCP. You should [check] () the official documentation before going forward.


# Installation (GKE bootstrap)

To deploy all the infrastructure withink GCP, we will use terraform which help us to deploy the needed resource to setup a
GKE cluster


# Kubernetes deployment

Despite you can use the Kubernetes or Kubectl providers, each has it's own drawbacks so I decided it will be easier to use
kustomize/kubectl directly in order to apply our manifests which contain the needed deployment for the Go application.

After the GCP infrastructure has been deployed, proceed to renew your kube config file by executing:
```bash
gcloud container clusters get-credentials <gke-cluster-name>
```

```bash
kubectl apply -f manifests/
```


# Infrastructure Diagram

# Developer overview Diagram

# Problems found

In my case my public domain is

# GitHub Actions

