## Requirements

- Account in GCP.
- Install gcloud: https://cloud.google.com/sdk/docs/install
- APIs are enabled with Terraform so you don't need to do it in the first deployment.


# First step

 gcloud init
Welcome! This command will take you through the configuration of gcloud.

Your current configuration has been set to: [default]

# Create project

$PROJECT_NAME =
gcloud projects create $PROJECT_NAME --set-as-default

## Alternative

gcloud config configurations list

# Config your region (cheapest one)

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

## Enabling the Billing (needed) API.

``Billing required
Compute Engine API requires a project with a billing account.``

$ gcloud services enable compute.googleapis.com
Operation "operations/acf.p2-387603574801-7b56174e-8427-4c66-b4f6-71c4fb5f6de7" finished successfully.

