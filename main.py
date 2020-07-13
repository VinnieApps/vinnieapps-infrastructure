import click

@click.group()
def create():
  pass

@click.group()
def destroy():
  pass

@create.command(name="dev")
@click.argument('gcp_project')
@click.argument('tf_state_bucket')
def create_dev(tf_state_bucket, gcp_project):
  from environments import dev
  dev.create(terraform_state_bucket=tf_state_bucket, gcp_project=gcp_project)

