# Requisites

- A GitHub account obviously.
- Terraform installed (v1.0.8 used)
- A GCP account with a **project already created and Billing **linked**. 
Your user should have full permissions although **a SA is recommended** instead of the root account for the projeect
- Install and configure (gcloud-sdk) [https://cloud.google.com/sdk/docs/quickstarts]
- **kubectl** installed
- (Helm) v3 [https://helm.sh/docs/intro/quickstart/]
- If you want to use ACME, you will need a **public domain registered** and perform additional configurations (depending on how you want to do it). *Here I'll be using custom CA which will deploy certificates not trusted publicly.*


# Installation (GKE bootstrap)

To deploy all the infrastructure withink GCP, we will use terraform which help us to deploy the needed resource to setup a
GKE cluster.

Clone the repo, go to the "infra" folder.
Iniatalize providers: `terraform init`
And then process with: `terraform plan && terraform apply -auto-approve`

This will deploy the following componentes:

- A functionally public GKE cluster.
- 2 Helm releases with Nginx (4.0.3) and Cert-manager (1.4?) installed.

# Kubernetes deployment

Despite you can use the Kubernetes or Kubectl providers, each has it's own drawbacks so I decided it will be easier to use
kustomize/kubectl directly in order to apply our manifests which contain the needed deployment for the Go application.

After the GCP infrastructure has been deployed, proceed to renew your kube config file by executing:
```bash
gcloud container clusters get-credentials <gke-cluster-name>
export KUBE_CONFIG_PATH=~/.kube/config
```

Now, to deploy our custom application perform:

```bash
kubectl apply -f manifests/
```

```bash
kubectl apply -f manifests/
```


It will configure an application with a service and ingress. That ingress will cre



# Infrastructure Diagram

# Developer overview Diagram

# GitHub Actions

# Problems found

### ACME with DNS01 challenge

DNS01 Challenge with domain in Route53 and K8s cluster in GKE was unsucessful:
``` bash
wildcard is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::xxxxxx:policy/DNS-Route53-role
           status code: 403, request id: e1bb82af-1811-4fd2-a38b-bsasdfasdf1
```

I've even tried to delegate a subdomain (go.itgaiden.com) from Route53 to Google Cloud DNS but no success:
``` bash
 Warning  PresentError  4m50s (x7 over 9m57s)  cert-manager  Error presenting challenge: When querying the SOA record for the domain '_acme-challenge.go.itgaiden.com.' using nameservers [10.8.0.10:53], rcode was expected to be 'NOERROR' or 'NXDOMAIN', but got 'SERVFAIL'
```
In the official [documentation) [https://cert-manager.io/docs/configuration/acme/dns01/route53/] seems to state that assume the cluster is in AWS, therefore, although there could be people that accomplished in the past, for some reason now doesn't seem possible although I have spent a lot of time on this.

### Using Traefik v2.x.x and "PathPrefix"

Although it works correctly out of the box, for some reason, when you using only "PathPrefix" like for example:
```
routes:
    - match: (PathPrefix(`/something`) || PathPrefix(`/somethingelse`))
    kind: Rule
```

I spent some time with this and I finally decided to move to the Nginx Ingress.



