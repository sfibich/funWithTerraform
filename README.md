# funWithTerraform
Series of Terraform scripts focusing on Azure from the Linux Bash perspective.

## SubFolders (Code Library):
The each sub folder is meant to be its own terraform module not a submodule.  This means you will not find a main.tf, variables.tf, or a output.tf
in the root of this repo.  It also explains why there is no modules folder in the root of this repo.
* privateLink - Terraform scripts to set up Azure Private Link along with resources for demonstration purposes
* setup - Bash scripts to set up Azure to hold state files as well as load variables to your session
* simpleTestResourceGroup - simple script to validate terraform setup
* template - a template project to copy to other folder when starting new terrform work.
* workstationUbuntu - Terraform scripts to create an Ubuntu workstation suitable for development

### First time Execution Notes
If this is your first time running the code in the repository please see the README.md in the setup folder.  The scripts in that folder configure  your Azure environment as well as your bash environment as expected by the rest of the scripts in this repository.

### General Execution Notes:
Please run "source ./LoadAzureTerraformSecretsToEnvVars.sh" to initialize the env variables for each new bash session.  This will allow the terraform scripts to pick up the expected variables

### Terraform Init
Each Sub-Folder is set up to be its own independent module.  So for each module the very first time you run it you are expected to "init" the back end. Below is an example of initializing the back end for a development environment.  Files for production and test are provided as well
```
terraform init -reconfigure \ 
 -backend-config="storage_account_name=$BACKEND_STORAGE_ACCOUNT" \
 -backend-config="container_name=$BACKEND_CONTAINER" \
 -backend-config="resource_group_name=$TERRAFORM_RESOURCE_GROUP" \
 -backend-config="dev/backend.tfvars" 
```

