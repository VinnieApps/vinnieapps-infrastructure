import click

@click.group()
def main():
  pass

@main.group()
def create():
  pass

@main.group()
def destroy():
  pass

@create.command(name="dev")
@click.argument('gcp_project')
@click.argument('terraform_state_bucket')
def create_dev(gcp_project, terraform_state_bucket):
  from infrastructure.environments import dev
  dev.create(
    base_domain_name=gcp_project,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )

@destroy.command(name="dev")
@click.argument('gcp_project')
@click.argument('terraform_state_bucket')
def destroy_dev(gcp_project, terraform_state_bucket):
  from infrastructure.environments import dev
  dev.destroy(
    base_domain_name=gcp_project,
    gcp_project=gcp_project,
    terraform_state_bucket=terraform_state_bucket,
  )
