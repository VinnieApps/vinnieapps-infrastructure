# VinnieAps Infrastructure

This project stores all the files to build the infratructure for all VinnieApps environments.

# Requirements

VinnieApps run in Google Cloud.
To build the infrastructure it uses Python and Terraform.

## Tools

To start, you'll need a Google Cloud account and project.

You will neeed the following applications to run everything:

- Python 3 - All scripting is done using Python, version `3.8.*`. [Download instructions](https://www.python.org/downloads/)
- `terraform` - Used to build all the resources in Google Cloud, version `0.12.*`. [Download instructions](https://www.terraform.io/downloads.html)
- `gcloud` - Tool used to communicate with Google Cloud instances and other things [Download instructions](https://cloud.google.com/sdk/docs#install_the_latest_cloud_tools_version_cloudsdk_current_version)

## Service Account

You'll need to create a service account.
Follow [this tutorial](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) to get a `credentials.json` file.
This file contains all that is needed to create and manage resources in your Google Cloud project.

<!-- TODO: Review this part after working on https://github.com/VinnieApps/vinnieapps-infrastructure/issues/19 -->
Download and put your `credentials.json` file in the root directory where you're running this from.
Don't worry, that file is marked to be ignored by git.

## GCP Enabled APIs

There APIs that need to be enabled in your GCP project.
To enable them, go [here](https://console.cloud.google.com/apis/library), search then click enable.

Unfortunately, that varies per environment you're going to create.
Terraform and other tools normally report a clear error message explaining what API you need and it is not enabled.

Here are some that the development environment needs:
- Cloud DNS API
- Cloud Storage API

# Repository Structure

This repository has the following structure:

- The [infrastructure](./infrastructure/README.md) directory stores the Python code and files that it needs to run the Python code.
- The [terraform](./terraform/README.md) directory stores all the Terraform modules and files required to run the modules.
- The `scripts` directory stores some reminescent bash scripts from previous incarnations of this repo. This will eventually go away when all that code migrates to Python.


# Getting Started

1. Create and activate a [virtual environment](https://docs.python.org/3/library/venv.html).
1. Install the [infrastructure](./infrastructure) application: `python setup.py install`

Then you can just call `infrastructure` to create or update the environment.
Running the command with `--help` will give more details of how it works.
