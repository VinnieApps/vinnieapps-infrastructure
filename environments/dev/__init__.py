def create(*, base_domain_name, gcp_project, terraform_state_bucket):
  from environments.dev.a_base import create as create_base
  from environments.dev.b_configuration import create as create_configuration

  output = create_base(
    base_domain_name=base_domain_name,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )

  create_configuration(
    mysql_appuser=output["mysql_username"]["value"],
    mysql_appuser_password=output["mysql_password"]["value"],
    mysql_root_password=output["mysql_root_password"]["value"],
    main_server_name=output["main_server_name"]["value"],
    server_key=output["server_key"]["value"],
  )

def destroy(*, base_domain_name, gcp_project, terraform_state_bucket):
  from environments.dev.a_base import destroy as destroy_base

  destroy_base(
    base_domain_name=base_domain_name,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )
