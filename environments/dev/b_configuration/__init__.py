from shared.gcloud.compute import instances

def create(*, main_server_name, mysql_root_password):
  main_server = instances.describe(main_server_name)

  create_databases(main_server = main_server, mysql_root_password = mysql_root_password)


def create_databases(*, main_server, mysql_root_password):
  databases = ["my_finances", "photos"]

  for database in databases:
    print(f"Creating database {database}...")
    main_server.run_command(f"mysql -u root -p{mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS {database}'")
