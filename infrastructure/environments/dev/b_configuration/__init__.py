from jinja2 import Template
from infrastructure.gcloud.compute import instances

import json
import os
import pathlib
import tempfile

def create(*, main_server_name, mysql_root_password, mysql_appuser, mysql_appuser_password, server_key):
  main_server = instances.describe(main_server_name)

  create_databases(main_server = main_server, mysql_root_password = mysql_root_password)
  add_nginx_configurations(main_server = main_server)
  add_supervisor_configurations(main_server = main_server)
  ensure_application_directories(main_server = main_server)
  create_my_finances_configuration(
    main_server = main_server,
    mysql_appuser = mysql_appuser,
    mysql_appuser_password = mysql_appuser_password,
    server_key = server_key,
  )
  create_my_finances_ini_configuration(
    main_server = main_server,
    mysql_appuser = mysql_appuser,
    mysql_appuser_password = mysql_appuser_password,
    server_key = server_key,
  )
  create_photos_configuration(
    main_server = main_server,
    mysql_appuser = mysql_appuser,
    mysql_appuser_password = mysql_appuser_password,
    server_key = server_key,
  )
  configure_certbot(main_server = main_server)

def add_nginx_configurations(*, main_server):
  main_server.upload(f"{os.path.dirname(__file__)}/nginx/my_finances.conf")
  main_server.run_command("sudo mv my_finances.conf /etc/nginx/conf.d")

  main_server.upload(f"{os.path.dirname(__file__)}/nginx/photos.conf")
  main_server.run_command("sudo mv photos.conf /etc/nginx/conf.d")

  main_server.run_command("sudo nginx -s reload")

def add_supervisor_configurations(*, main_server):
  main_server.upload(f"{os.path.dirname(__file__)}/supervisor/my_finances.ini")
  main_server.run_command("sudo mv my_finances.ini /etc/supervisor/conf.d/my_finances.conf")

  main_server.upload(f"{os.path.dirname(__file__)}/supervisor/photos-service.ini")
  main_server.run_command("sudo mv photos-service.ini /etc/supervisor/conf.d/photos-service.conf")

  main_server.upload(f"{os.path.dirname(__file__)}/supervisor/photos-jobs.ini")
  main_server.run_command("sudo mv photos-jobs.ini /etc/supervisor/conf.d/photos-jobs.conf")

  main_server.run_command("sudo supervisorctl reread; sudo supervisorctl update")

def configure_certbot(*, main_server):
  main_server.run_command("sudo certbot --redirect --nginx --non-interactive --agree-tos -m viniciusisola@gmail.com --domains finances-dev.vinnieapps.com --domains photos-dev.vinnieapps.com")

def create_my_finances_configuration(*, main_server, mysql_appuser, mysql_appuser_password, server_key):
  with open(f"{os.path.dirname(__file__)}/configs/my_finances/config.py") as f:
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

def create_my_finances_ini_configuration(*, main_server, mysql_appuser, mysql_appuser_password, server_key):
  with open(f"{os.path.dirname(__file__)}/configs/my_finances/config.ini") as f:
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

    main_server.run_command(f"sudo mkdir -p /opt/apps/configs/my_finances; sudo mv {temp_filename.name} /opt/apps/configs/my_finances/config.ini")

  main_server.run_command("sudo chown -R appuser:appuser /opt/apps")

def create_photos_configuration(*, main_server, mysql_appuser, mysql_appuser_password, server_key):
  photos_dev_config = dict()
  with open('photos_dev_secrets.json', 'r') as f:
    photos_dev_config = json.load(f)

  google_credentials=''
  with open('credentials.json', 'r') as f:
    google_credentials = f.read().replace('\n', '')

  with open(f"{os.path.dirname(__file__)}/configs/photos/application.yml") as f:
    template = Template(f.read())
    temp = tempfile.NamedTemporaryFile(delete=False)
    temp.write(template.render(
      database_password=mysql_appuser_password,
      database_username=mysql_appuser,
      google_client_id=photos_dev_config['client_id'],
      google_client_secret=photos_dev_config['secret_id'],
      google_cloud_credentials=google_credentials,
      server_key=server_key,
      token_secret=photos_dev_config['token_secret'],
    ).encode("utf-8"))
    temp.close()

    temp_filename = pathlib.Path(temp.name)
    main_server.upload(temp.name)
    temp_filename.unlink()

    main_server.run_command(f"sudo mkdir -p /opt/apps/configs/photos; sudo mv {temp_filename.name} /opt/apps/configs/photos/application.yml")

  main_server.run_command("sudo chown -R appuser:appuser /opt/apps")

def create_databases(*, main_server, mysql_root_password):
  databases = ["my_finances", "photos"]

  for database in databases:
    print(f"Creating database '{database}' if it doesn't exist...")
    main_server.run_command(f"mysql -u root -p{mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS {database}'")

def ensure_application_directories(main_server):
  main_server.run_command("sudo mkdir -p /opt/apps/my_finances /opt/apps/photos; sudo chown -R appuser:appuser /opt/apps")
