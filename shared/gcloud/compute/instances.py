import json
import subprocess
import sys

def describe(instance_name):
  arguments = ["gcloud", "compute", "instances", "describe", "--format=json"]
  arguments.append(instance_name)
  completed_describe = subprocess.run(arguments, capture_output=True, check=True)
  return Instance(json.JSONDecoder().decode(completed_describe.stdout.decode('utf-8')))

class Instance:
  def __init__(self, instance_json):
    self.instance = instance_json

  def nat_ip(self):
    return self.instance["networkInterfaces"][0]["accessConfigs"][0]["natIP"]

  def run_command(self, command):
    arguments = ["gcloud", "compute", "ssh", self.instance["name"], '--command', command]
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

    print("File '{file}' uploaded successfully.")
