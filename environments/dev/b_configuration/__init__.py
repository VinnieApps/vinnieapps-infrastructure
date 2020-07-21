from shared.gcloud.compute import instances

def create(*, main_server_name, mysql_root_password):
  main_server = instances.describe(main_server_name)

  create_databases(main_server = main_server, mysql_root_password = mysql_root_password)
  add_nginx_configurations(main_server = main_server)

def add_nginx_configurations(*, main_server):
  main_server.upload("environments/dev/b_configuration/nginx/my_finances.conf")
  main_server.upload("environments/dev/b_configuration/nginx/photos.conf")

  main_server.run_command("sudo mv my_finances.conf /etc/nginx/conf.d")
  main_server.run_command("sudo mv photos.conf /etc/nginx/conf.d")
  main_server.run_command("sudo nginx -s reload")

def create_databases(*, main_server, mysql_root_password):
  databases = ["my_finances", "photos"]

  for database in databases:
    print(f"Creating database '{database}' if it doesn't exist...")
    main_server.run_command(f"mysql -u root -p{mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS {database}'")
