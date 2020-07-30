from infrastructure import terraform

def create(*, gcp_project):
  terraform_dir = "terraform/environments/local"
  terraform.init(working_directory=terraform_dir)
  terraform.apply(working_directory=terraform_dir, environment="local", project_id=gcp_project)

def destroy(*, gcp_project):
  terraform_dir = "terraform/environments/local"
  terraform.init(working_directory=terraform_dir)
  terraform.destroy(working_directory=terraform_dir, environment="local", project_id=gcp_project)
