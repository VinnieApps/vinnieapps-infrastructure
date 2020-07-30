def create(*, base_domain_name, gcp_project, terraform_state_bucket):
  from infrastructure.environments.dev.a_base import create as create_base
  from infrastructure.environments.dev.b_configuration import create as create_configuration
  from infrastructure.environments.dev.c_deploy import create as deploy_applications

  output = create_base(
    base_domain_name=base_domain_name,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )

  create_configuration(
    main_server_name=output["main_server_name"]["value"],
    mysql_appuser=output["mysql_username"]["value"],
    mysql_appuser_password=output["mysql_password"]["value"],
    mysql_root_password=output["mysql_root_password"]["value"],
    server_key=output["server_key"]["value"],
  )

  deploy_applications(
    main_server_name=output["main_server_name"]["value"],
    mysql_appuser=output["mysql_username"]["value"],
    mysql_appuser_password=output["mysql_password"]["value"],
  )

def destroy(*, base_domain_name, gcp_project, terraform_state_bucket):
  from infrastructure.environments.dev.a_base import destroy as destroy_base

  destroy_base(
    base_domain_name=base_domain_name,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )
