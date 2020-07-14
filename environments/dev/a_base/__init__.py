from shared import terraform

import os
import subprocess
import sys

def create(*, gcp_project, terraform_state_bucket):
  module_dir = os.path.dirname(__file__)

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=module_dir)
  terraform.apply(working_directory=module_dir, environment="dev", project_id=gcp_project)

  # TODO: Wait for init script to finish

def destroy(*, gcp_project, terraform_state_bucket):
  module_dir = os.path.dirname(__file__)

  terraform.init(terraform_state_bucket=terraform_state_bucket, working_directory=module_dir)
  terraform.destroy(working_directory=module_dir, environment="dev", project_id=gcp_project)
