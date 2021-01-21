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

### Execution Notes:
Each SubFolder (Code Library) contains an environment folder for runtime information: dev, test, prod.  
The "backend.tfvars.secret" is included in the git ignore file, the included backend.tfvars is a sample file.
#### Inital/Reconfiguration
* Example 1: terraform init -reconfigure -backend-config="dev/backend.tfvars"
* Example 2: terraform init -reconfigure -backend-config="dev/backend.tfvars.secret"
#### Subsequent runs
* Example 3: terraform init -backend-config="dev/backend.tfvars"
* Example 4: terraform init -backend-config="dev/backend.tfvars.secret"


### Notes:
* All terraform scripts require you to change the storage account and resource group of the state files prior to execution
* If this is your first time using these scripts please see the README.md in the setup directory
