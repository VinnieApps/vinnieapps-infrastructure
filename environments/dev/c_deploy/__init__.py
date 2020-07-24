from shared.gcloud.compute import instances

def create(*, main_server_name, mysql_appuser, mysql_appuser_password):
  main_server = instances.describe(main_server_name)

  deploy_my_finances(
    main_server = main_server,
    mysql_appuser = mysql_appuser,
    mysql_appuser_password = mysql_appuser_password,
  )

def deploy_my_finances(*, main_server, mysql_appuser, mysql_appuser_password):
  # Get code
  main_server.run_command("cd /opt/apps; sudo rm -Rf my_finances; sudo git clone https://github.com/VinnieApps/my_finances.git; sudo chown -R $(whoami):$(whoami) my_finances")

  # Copy configs
  main_server.run_command("sudo cp /opt/apps/configs/my_finances/config.py /opt/apps/my_finances/app; sudo chown -R $(whoami):$(whoami) /opt/apps/my_finances")

  # Recreate DB
  main_server.run_command(f"mysql -u {mysql_appuser} -p{mysql_appuser_password} -e 'drop database if exists my_finances'")
  main_server.run_command(f"mysql -u {mysql_appuser} -p{mysql_appuser_password} -e 'create database my_finances'")
  main_server.run_command(f"cd /opt/apps/my_finances; mysql -u {mysql_appuser} -p{mysql_appuser_password} my_finances < script_my_finances.sql")

  # Install app dependencies
  main_server.run_command("cd /opt/apps/my_finances; python3 -m venv venv; source venv/bin/activate; python setup.py install")

  # Fix ownership and restart application
  main_server.run_command("sudo chown -R appuser:appuser /opt/apps/my_finances; sudo supervisorctl restart my_finances")
