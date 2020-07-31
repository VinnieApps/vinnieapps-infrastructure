# Infrastructure Builder

This is a Python application that is used to build all environments.

The `environments` folder has the modules to create/update/destroy each environment.
The modules are not runnable by themselves, instead they are called from the root command `infrastructure` from the [infrastructure/__init__.py](.infrastructure/__init__.py) file.

# Development

To work with the code from your local machine, you'll need the tools described in the main [README](../README.md).
After all the tools and pre-requisites, you need to

- Create a virtual environment with the following command: `python3 -m venv venv`
- Activate the virtual environment:
  - For Windows: `venv\Scripts\Activate.bat`
  - For Mac ou Unix: `source venv/bin/activate`
- Then run `python setup.py develop`

After that the app is installed and can be executed by running the command `infrastructure`, here is a sample:

```
$ infrastructure --help
Usage: infrastructure [OPTIONS] COMMAND [ARGS]...

  Application to manage VinnieApps infrastructure.

Options:
  --help  Show this message and exit.

Commands:
  create   Create the infrastructure for a specific environment.
  destroy  Destroy the infrastructure for a specific environment.
```
