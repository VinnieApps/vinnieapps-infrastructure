import json
import subprocess
import sys

def describe(instance_name):
  arguments = ["gcloud", "compute", "instances", "describe", "--format=json"]
  arguments.append(instance_name)

  completed_describe = subprocess.run(arguments, capture_output=True)
  if completed_describe.returncode != 0:
    print("-- Standard Output --")
    print(completed_describe.stdout.decode('utf-8'))
    print("---------------------")
    print("-- Standard Error  --")
    print(completed_describe.stderr.decode('utf-8'))
    print("---------------------")
    sys.exit(2)
  return Instance(json.JSONDecoder().decode(completed_describe.stdout.decode('utf-8')))

class Instance:
  def __init__(self, instance_json):
    self.instance = instance_json

  def nat_ip(self):
    return self.instance["networkInterfaces"][0]["accessConfigs"][0]["natIP"]

  def run_command(self, command, user=None):
    arguments = ["gcloud", "compute", "ssh", '--command', command]
    if user is None:
      arguments.append(self.instance["name"])
    else:
      arguments.append(f"{user}@{self.instance['name']}")

    completed_command = subprocess.run(arguments, capture_output=True)

    if completed_command.returncode != 0:
      print("-- Command failed! --")
      print("-- Standard Output --")
      print(completed_command.stdout.decode('utf-8'))
      print("---------------------")
      print("-- Standard Error  --")
      print(completed_command.stderr.decode('utf-8'))
      print("---------------------")
      sys.exit(2)

    print(completed_command.stdout.decode('utf-8'))

  def upload(self, file):
    arguments = ["gcloud", "compute", "scp", file, f"{self.instance['name']}:~"]
    completed_scp = subprocess.run(arguments, capture_output=True)

    if completed_scp.returncode != 0:
      print("-- Command failed! --")
      print("-- Standard Output --")
      print(completed_scp.stdout.decode('utf-8'))
      print("---------------------")
      print("-- Standard Error  --")
      print(completed_scp.stderr.decode('utf-8'))
      print("---------------------")
      sys.exit(2)

    print(f"File '{file}' uploaded successfully.")
