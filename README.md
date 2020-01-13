# VinnieAps Infrastructure

This project stores all the files to build the infratructure for all VinnieApps environments.

# Requirements

VinnieApps run in Google Cloud and Kubernetes.
To build the infrastructure it uses Terraform.

To start, you'll need a Google Cloud account and project.

You will neeed the following applications to run everything:

- `terraform` - Used to build all the resources in Google Cloud, version `0.12.*`. [Download instructions](https://www.terraform.io/downloads.html)
- `docker` - Used to generate TLS certificates from Let's Encrypt. [Download Instructions](https://www.docker.com/products/developer-tools)

You'll also need to create a service account.
Follow [this tutorial](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) to get a `credentials.json` file.
This file contains all Terraform needs to create resources in your Google Cloud project.
Download and put your `credentials.json` file in the `terraform` directory.
Don't worry, that file is marked to be ignored by git.

## GCP Enabled APIs

The following APIs need to be enabled in your GCP project.
To enable them, go [here](https://console.cloud.google.com/apis/library), search then click enable.

- Google Cloud DNS API
- Kubernetes Engine API

## Let's Encrypt

To generate the TLS certificate and key for the subdomain you'll need to be able to manage the domain.
The challenge will ask you to place a value in a TXT record under a subdomain of your subdomain.

The script `scripts/letsencrypt_certificate.sh` will execute a Docker image provided by Let's Encrypt that will take you through the challenge.
Execute it from the root of this repo and after you're done it will have created a `letsencrypt` folder which will be used as volumes to the container.
After running the script and following the instructions, the two files (private key and pem) will be generated under the following directory:

```
letsencrypt/etc/letsencrypt/live/{your-sub-domain}/fullchain.pem
letsencrypt/etc/letsencrypt/live/{your-sub-domain}/privkey.pem
```

With the files generated, copy them to the `terraform` folder.

# Repository Structure

The `terraform` directory contains all the files necessary to create all environments.
In it there are three base folders:

- `applications` - contains application specific modules that can be shared between environments.
- `environments` - contains all the environments folders. This is where you'll want to execute Terraform from.
- `shared` - shared modules.
