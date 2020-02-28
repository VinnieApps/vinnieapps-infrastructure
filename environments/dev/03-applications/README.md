# 03-applications

Contains resources that are required for the applications to run. There's a thin line here and this module should only include infrastructure pieces, not runtime pieces. Good examples are:

- Databases
- Services
- Ingress/Routing
- Storage like buckets

Bad examples include anything that will change for each application deployment:

- Application deployments
- Docker images

# Pre-requisits

- All previous layers installed correctly
- `terraform` installed (v0.12.19)
- A bucket in Google Cloud storage to store Terraform state
