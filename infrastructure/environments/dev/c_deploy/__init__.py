from infrastructure.gcloud.compute import instances

def create(*, main_server_name):
  main_server = instances.describe(main_server_name)

  deploy_my_finances(main_server = main_server)
  deploy_photos(main_server=main_server)

def deploy_my_finances(*, main_server):
  # Get code
  main_server.run_command("cd /opt/apps; sudo rm -Rf my_finances; sudo git clone https://github.com/VinnieApps/my_finances.git; sudo chown -R $(whoami):$(whoami) my_finances")

  # Copy configs
  main_server.run_command("sudo cp /opt/apps/configs/my_finances/config.py /opt/apps/my_finances/app; sudo chown -R $(whoami):$(whoami) /opt/apps/my_finances")
  main_server.run_command("sudo cp /opt/apps/configs/my_finances/config.ini /opt/apps/my_finances; sudo chown -R $(whoami):$(whoami) /opt/apps/my_finances")

  # Install app dependencies
  main_server.run_command("cd /opt/apps/my_finances; python3 -m venv venv; source venv/bin/activate; python setup.py -q install")

  # Fix ownership and restart application
  main_server.run_command("sudo chown -R appuser:appuser /opt/apps/my_finances; sudo supervisorctl restart my_finances")

def deploy_photos(*, main_server):
  # Download and extract frontend
  command = "mkdir -p /opt/apps/photos; cd /opt/apps/photos; sudo chown -R $(whoami):$(whoami) /opt/apps/photos;"
  command = command + "latest_release_json=$(curl -L https://api.github.com/repos/VinnieApps/photos-frontend/releases/latest);"
  command = command + "photos_frontend_url=$(echo $latest_release_json | jq -r '.assets[0].browser_download_url'); curl -L -o photos-frontend.tar.gz $photos_frontend_url;"
  command = command + "rm -Rfv frontend; mkdir frontend; tar -xvf photos-frontend.tar.gz --directory frontend;"

  # Download JARs
  command = command + "latest_release_json=$(curl -L https://api.github.com/repos/VinnieApps/photos/releases/latest);"
  command = command + "photos_jobs_url=$(echo $latest_release_json | jq -r '.assets[0].browser_download_url'); curl -L -o photos-jobs.jar $photos_jobs_url;"
  command = command + "photos_service_url=$(echo $latest_release_json | jq -r '.assets[1].browser_download_url'); curl -L -o photos-service.jar $photos_service_url;"
  main_server.run_command(command)

  # Copy configs
  main_server.run_command("sudo cp /opt/apps/configs/photos/application.yml /opt/apps/photos/application.yml")

  # Fix ownership and restart application
  main_server.run_command("sudo chown -R appuser:appuser /opt/apps/photos; sudo supervisorctl restart photos-service photos-jobs")
