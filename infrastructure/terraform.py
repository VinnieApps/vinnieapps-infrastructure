import json
import subprocess
import sys

def apply(*, working_directory, **kwargs):
  print(f"Running Terraform apply...")
  arguments = ["terraform", "apply", "-auto-approve"]

  for var in kwargs:
    arguments.append("-var")
    arguments.append(f"{var}={kwargs[var]}")

  apply_subprocess = subprocess.Popen(arguments, cwd=working_directory)
  apply_subprocess.wait()

  if apply_subprocess.returncode != 0:
    print("Terraform apply failed...")
    sys.exit(1)

  print(f"Terraform apply succeeded!")

def destroy(*, working_directory, **kwargs):
  print(f"Running Terraform destroy...")
  arguments = ["terraform", "destroy", "-auto-approve"]

  for var in kwargs:
    arguments.append("-var")
    arguments.append(f"{var}={kwargs[var]}")

  apply_subprocess = subprocess.Popen(arguments, cwd=working_directory)
  apply_subprocess.wait()

  if apply_subprocess.returncode != 0:
    print("Terraform destroy failed...")
    sys.exit(1)

  print(f"Terraform destroy succeeded!")

def init(*, terraform_state_bucket, working_directory):
  print(f"Working directory: {working_directory}")
  print("Initializing Terraform...")

  init_subprocess = subprocess.Popen(
    ["terraform", "init", f"-backend-config=bucket={terraform_state_bucket}"],
    cwd=working_directory,
  )

  init_subprocess.wait()

  if init_subprocess.returncode != 0:
    print("Terraform init failed")
    sys.exit(1)

  print("Terraform initialized!")

def output(*, working_directory):
  completed_output = subprocess.run(["terraform", "output", "-json"], capture_output=True, cwd=working_directory)

  if completed_output.returncode != 0:
    print("Terraform output failed")
    print(completed_output.stdout.decode('utf-8'))
    print(completed_output.stderr.decode('utf-8'))
    sys.exit(1)

  return json.JSONDecoder().decode(completed_output.stdout.decode('utf-8'))
