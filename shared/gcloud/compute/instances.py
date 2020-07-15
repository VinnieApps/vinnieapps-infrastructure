import json
import subprocess

def describe(instance_name):
  arguments = ["gcloud", "compute", "instances", "describe", "--format=json"]
  arguments.append(instance_name)
  completed_describe = subprocess.run(arguments, capture_output=True, check=True)
  return json.JSONDecoder().decode(completed_describe.stdout.decode('utf-8'))
