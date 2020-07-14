def create(*, terraform_state_bucket, gcp_project):
  from environments.dev.a_base import create as create_base

  create_base(gcp_project=gcp_project, terraform_state_bucket=terraform_state_bucket)

def destroy(*, terraform_state_bucket, gcp_project):
  from environments.dev.a_base import destroy as destroy_base

  destroy_base(gcp_project=gcp_project, terraform_state_bucket=terraform_state_bucket)
