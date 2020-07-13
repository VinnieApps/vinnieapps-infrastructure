# 03-applications

Create all resources necessary to run the applications that Terraform doesn't support.

This layer also includes deploying the applications so it will try to query GitHub for latest versions and git SHAs, then generate Kubernetes deployments that will be applied to the cluster.

# Pre-requisits

- All previous layers installed correctly
- `kubectl`
