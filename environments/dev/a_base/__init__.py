from shared import terraform
from shared.gcloud.compute import instances

import os
import requests
import subprocess
import sys
import time

def create(*, gcp_project, terraform_state_bucket):
  module_dir = os.path.dirname(__file__)

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=module_dir)
  terraform.apply(working_directory=module_dir, environment="dev", project_id=gcp_project)

  main_server_ip = instances.describe("dev-main-server")["networkInterfaces"][0]["accessConfigs"][0]["natIP"]

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

def destroy(*, gcp_project, terraform_state_bucket):
  module_dir = os.path.dirname(__file__)

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=module_dir)
  terraform.destroy(working_directory=module_dir, environment="dev", project_id=gcp_project)
