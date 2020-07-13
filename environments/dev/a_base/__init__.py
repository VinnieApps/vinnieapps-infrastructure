import os
import subprocess
import sys

def create(*, gcp_project, terraform_state_bucket):
  module_dir = os.path.dirname(__file__)
  print(f"Working directory: {module_dir}")
  print("Initializing Terraform...")
  
  completed_init = subprocess.run(
    ["terraform", "init", "-no-color", f"-backend-config=bucket={terraform_state_bucket}"],
    capture_output=True,
    cwd=module_dir
  )

  if completed_init.returncode != 0:
    print("Terraform init failed...")
    print(completed_init.stdout)
    print(completed_init.stderr)
    sys.exit(1)

  print("Terraform initialized!")

  arguments = ["terraform", "apply", "-no-color", "-auto-approve"]

  arguments.append("-var")
  arguments.append("environment=dev")

  arguments.append("-var")
  arguments.append(f"project_id={gcp_project}")

  print(f"Running Terraform apply...")
  completed_apply = subprocess.run(arguments, capture_output=True, cwd=module_dir)

  if completed_apply.returncode != 0:
    print("Terraform apply failed...")
    print(completed_apply.stdout)
    print(completed_apply.stderr)
    sys.exit(1)

  print(f"Terraform apply succeeded: {eval(completed_apply.stdout)}")
