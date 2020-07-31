# Terraform

This directory contains the Terraform modules used to provision parts of the infrastructure necessary for each environment.
It's important to note that not all resources are created through Terraform, some are created using other tools, each environment is different.

## Directory structure

- `applications` - contains modules specific to each application.
- `environments` - contains modules specific to each environment.
- `shared` - any shared modules goes in this directory.
