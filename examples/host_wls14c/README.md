# WLS 14c configuration

This directory contains terraform configuration and cloud-init user data files
to setup and bootstrap the a WLS 14c environment. The `*.tf` files and the
`cloudinit` folder in this folder must be placed in the corresponding location
of you terraform configuration.

- [host_wls14c.tf](host_wls14c.tf) Terraform configuration to call the module
  `tvdlab-host` as basis to setup the WLS 14c environment
- [host_wls14c.auto.tfvars](host_wls14c.auto.tfvars) Terraform variable file to
  configure the WLS 14c terraform configuration.
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

## Using the Module for WLS 14c

To use the module on a WLS 14c server, the following procedure should be followed.

- Create a corresponding folder for the WLS 14c configuration in the root of the terraform project

```bash
mkdir $TERRAFORM_ROOT/host_wls14c
```

- Copy the configuration files to the new folder

```bash
cp -r cloudinit $TERRAFORM_ROOT/host_wls14c
```

- Copy the terraform configuration files to the root of the terraform project

```bash
cp host_wls14c.tf $TERRAFORM_ROOT
cp host_wls14c.auto.tfvars $TERRAFORM_ROOT
```

- Adjust the `host_wls14c.auto.tfvars` file to match the environment
- Adjust the `set_env_wls14c_config.sh` file e.g. software packages and other
  environment variables.
