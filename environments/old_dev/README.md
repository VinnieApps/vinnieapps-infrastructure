# dev environment

This contains the resources to create a dev enviornment with the applications installed.

## Layers

Each sub-directory in here contains a layer of the stack. Layers are dependent on each other and will probably not work if the previous layer hasn't been correctly created. There's a README on each folder explaining what's in that stack and what should go in there.

To create (or update) the resources for a layer, you can go in there and run the `create.sh` file. The file should be idempotent and any existing resources will not be affected. The create script should also inform you of any extra information needed to create that layer.

To destroy the resources in a specific layer, there's another bash script called `destroy.sh`. Running that file should destroy all the resources created for that layer.
