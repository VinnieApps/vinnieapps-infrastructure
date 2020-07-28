from infrastructure import terraform
from infrastructure.gcloud.compute import instances

import os
import requests
import subprocess
import sys
import time

def create(*, base_domain_name, gcp_project, terraform_state_bucket):
  terraform_dir = "terraform/environments/dev"

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=terraform_dir)
  terraform.apply(working_directory=terraform_dir, base_domain_zone_name=base_domain_name, environment="dev", project_id=gcp_project)

  main_server_ip = instances.describe("dev-main-server").nat_ip()

  status_code = -1
  while True:
    try:
      # This depends on the fact that the server init script install
      # nginx as the last step
      resp = requests.get(f"http://{main_server_ip}")
      if resp.status_code == requests.codes.ok:
        break
    except:
      pass
    print("Waiting for init script to finish...")
    time.sleep(10)

  print("Development infrastructure is ready!")
  return terraform.output(working_directory=terraform_dir)

def destroy(*, base_domain_name, gcp_project, terraform_state_bucket):
  terraform_dir = "terraform/environments/dev"

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=terraform_dir)
  terraform.destroy(working_directory=terraform_dir, base_domain_zone_name=base_domain_name, environment="dev", project_id=gcp_project)
