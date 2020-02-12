# 02 - Kubernetes

Contains resources that needs to be created inside the Kubernetes cluster. Includes:

- Contour as the Ingress controller

# Pre-requisites

- Previous layers
- `gcloud` tool installed and logged in the correct account/project
- `kubectl` installed

# Running it

```
$ gcloud container clusters get-credentials kubernetes-dev
$ kubectl apply -f 001-contour.yml
```
