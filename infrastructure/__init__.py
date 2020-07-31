import click

@click.group()
def main():
  '''
    Application to manage VinnieApps infrastructure.
  '''
  pass

@main.group()
def create():
  '''
    Create the infrastructure for a specific environment.
    Each sub-command represents an environment.
  '''
  pass

@main.group()
def destroy():
  '''
    Destroy the infrastructure for a specific environment.
    Each sub-command represents an environment.
  '''
  pass

@create.command(name="dev")
@click.argument('gcp_project')
@click.argument('terraform_state_bucket')
def create_dev(gcp_project, terraform_state_bucket):
  '''
    Create or update the development environment.

    GCP_PROJECT             The Google Cloud project ID to be used.
    TERRAFORM_STATE_BUCKET  The GCS bucket where the Terraform state is.
  '''
  from infrastructure.environments import dev
  dev.create(
    base_domain_name=gcp_project,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )

@create.command(name="local")
@click.argument('gcp_project')
def create_local(gcp_project):
  '''
    Create or update the infrastructure required to run the projects locally.
    This does not create databases or any other local resources, only resources that run in the cloud.

    GCP_PROJECT    The Google Cloud project ID to be used.
  '''
  from infrastructure.environments import local
  local.create(gcp_project=gcp_project)

@destroy.command(name="dev")
@click.argument('gcp_project')
@click.argument('terraform_state_bucket')
def destroy_dev(gcp_project, terraform_state_bucket):
  '''
    Destroy the development environment.

    GCP_PROJECT             The Google Cloud project ID to be used.
    TERRAFORM_STATE_BUCKET  The GCS bucket where the Terraform state is.
  '''
  from infrastructure.environments import dev
  dev.destroy(
    base_domain_name=gcp_project,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )

@destroy.command(name="local")
@click.argument('gcp_project')
def create_local(gcp_project):
  '''
    Destroy the infrastructure required to run the projects locally.
    This does not delete databases or any other local resources, only resources that run in the cloud.

    GCP_PROJECT    The Google Cloud project ID to be used.
  '''
  from infrastructure.environments import local
  local.destroy(gcp_project=gcp_project)