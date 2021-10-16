
#data "google_client_config" "configk8s" {}

#https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs
provider "kubectl" {
  load_config_file = false

  host = google_container_cluster.primary.endpoint

  #host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  #token = data.google_client_config.default.access_token
  #cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  #config_path    = "~/.kube/config"

  client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

## Traefik ingress route

data "kubectl_path_documents" "docs" {
  pattern = "./manifests/*.yaml"
}

resource "kubectl_manifest" "deployment" {
  for_each  = data.kubectl_path_documents.docs.manifests
  yaml_body = each.value
}


/*
## Traefik-ingressroutes
resource "kubectl_manifest" "traefik-routes" {
    yaml body = <<YAML
# dashboard.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: dashboard
  namespace: traefik
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: (PathPrefix(`/dashboard`) || PathPrefix(`/api`))
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
YAML
}

## Go-app Deployment and service
resource "kubectl_manifest" "go-app-deployment" {
    yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: go-deployment
  namespace: app
  labels:
    app: go-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: go-app
  template:
    metadata:
      labels:
        app: go-app
    spec:
      containers:
      - name: go-app
        image: gcr.io/dangaiden-go-cicd/goserver:v1
        ports:
        - containerPort: 8080
---
kind: Service
apiVersion: v1
metadata:
  name: go-service
  namespace: app
spec:
  selector:
    app: go-app
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
YAML
}


## Ingress routes for Go-app
resource "kubectl_manifest" "go-app-routes" {
    yaml_body = <<YAML
#app-routes.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: go-ingress
  namespace: app

spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(`itgaiden.com`)
      kind: Rule
      services:
        - name: go-service
          namespace: app
          port: 80
YAML
}
*/