from jinja2 import Template
from shared.gcloud.compute import instances

import pathlib
import tempfile

def create(*, main_server_name, mysql_root_password, mysql_appuser, mysql_appuser_password, server_key):
  main_server = instances.describe(main_server_name)

  create_databases(main_server = main_server, mysql_root_password = mysql_root_password)
  add_nginx_configurations(main_server = main_server)
  add_supervisor_configurations(main_server = main_server)
  ensure_application_directories(main_server = main_server)
  create_application_configurations(
    main_server = main_server,
    mysql_appuser = mysql_appuser,
    mysql_appuser_password = mysql_appuser_password,
    server_key = server_key,
  )

def add_nginx_configurations(*, main_server):
  main_server.upload("environments/dev/b_configuration/nginx/my_finances.conf")
  main_server.run_command("sudo mv my_finances.conf /etc/nginx/conf.d")

  main_server.upload("environments/dev/b_configuration/nginx/photos.conf")
  main_server.run_command("sudo mv photos.conf /etc/nginx/conf.d")

  main_server.run_command("sudo nginx -s reload")

def add_supervisor_configurations(*, main_server):
  main_server.upload("environments/dev/b_configuration/supervisor/my_finances.ini")
  main_server.run_command("sudo mv my_finances.ini /etc/supervisor/conf.d/my_finances.conf")

  main_server.run_command("sudo supervisorctl reread; sudo supervisorctl update")

def create_application_configurations(*, main_server, mysql_appuser, mysql_appuser_password, server_key):
  with open("environments/dev/b_configuration/configs/my_finances/config.py") as f:
    template = Template(f.read())
    temp = tempfile.NamedTemporaryFile(delete=False)
    temp.write(template.render(
      database_password=mysql_appuser_password,
      database_username=mysql_appuser,
      server_key=server_key,
    ).encode("utf-8"))
    temp.close()

    temp_filename = pathlib.Path(temp.name)
    main_server.upload(temp.name)
    temp_filename.unlink()

    main_server.run_command(f"sudo mkdir -p /opt/apps/configs/my_finances; sudo mv {temp_filename.name} /opt/apps/configs/my_finances/config.py")

  main_server.run_command("sudo chown -R appuser:appuser /opt/apps")


def create_databases(*, main_server, mysql_root_password):
  databases = ["my_finances", "photos"]

  for database in databases:
    print(f"Creating database '{database}' if it doesn't exist...")
    main_server.run_command(f"mysql -u root -p{mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS {database}'")

def ensure_application_directories(main_server):
  main_server.run_command("sudo mkdir -p /opt/apps/my_finances /opt/apps/photos; sudo chown -R appuser:appuser /opt/apps")
