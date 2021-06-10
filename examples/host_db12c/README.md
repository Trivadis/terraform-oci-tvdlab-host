# Database 12c configuration

This directory contains terraform configuration and cloud-init user data files
to setup and bootstrap the a Database 12c environment. The `*.tf` files and the
`cloudinit` folder in this folder must be placed in the corresponding location
of you terraform configuration.

- [host_db12c.tf](host_db12c.tf) Terraform configuration to call the module
  `tvdlab-host` as basis to setup the Database 12c environment
- [host_db12c.auto.tfvars](host_db12c.auto.tfvars) Terraform variable file to
  configure the Database 12c terraform configuration.
- [cloudinit](cloudinit) folder with the configuration files.

## Prerequisites

To use the module, a few requirements must be met:

- Define the mandatory parameter for
  - *region* the OCI region where resources will be created
  - *compartment_ocid* OCID of the compartment where to create all resources
  - *tenancy_ocid* tenancy id where to create the resources
  - *host_subnet* List of subnets for the host hosts
  - *tvd_def_password* Default password for windows administrator, oracle, directory and more
  - *lab_source_url* preauthenticated URL to the LAB source ZIP file.
  - *ssh_authorized_keys* SSH authorized keys to access the resource.
  - *ssh_private_key* SSH private key used to access the internal hosts for file upload.
- provide a URL for software download to make sure Oracle binaries will be
  downloaded
  - *software_repo* software repository URL to OCI object store swift API
  - *software_user* default OCI user to access the software repository
  - *software_password* default OCI password to access the software repository

## Using the Module for Database 12c

To use the module on a Database 12c server, the following procedure should be
followed.

- Create a corresponding folder for the Database 12c configuration in the root
  of the terraform project

```bash
mkdir $TERRAFORM_ROOT/host_db12c
```

- Copy the configuration files to the new folder

```bash
cp -r cloudinit $TERRAFORM_ROOT/host_db12c
```

- Copy the terraform configuration files to the root of the terraform project

```bash
cp host_db12c.tf $TERRAFORM_ROOT
cp host_db12c.auto.tfvars $TERRAFORM_ROOT
```

- Adjust the `host_db12c.auto.tfvars` file to match the environment
- Adjust the `set_env_db12c_config.sh` file e.g. software packages and other
  environment variables.
