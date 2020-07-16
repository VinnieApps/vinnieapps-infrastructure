def create(*, terraform_state_bucket, gcp_project):
  from environments.dev.a_base import create as create_base
  from environments.dev.b_configuration import create as create_configuration

  output = create_base(gcp_project=gcp_project, terraform_state_bucket=terraform_state_bucket)
  create_configuration(
    main_server_name=output["main_server_name"]["value"],
    mysql_root_password=output["mysql_root_password"]["value"],
  )

def destroy(*, terraform_state_bucket, gcp_project):
  from environments.dev.a_base import destroy as destroy_base

  destroy_base(gcp_project=gcp_project, terraform_state_bucket=terraform_state_bucket)
