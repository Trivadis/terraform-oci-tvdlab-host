# Cloud Init Files and Templates

This directory contains cloud-init user data files and templates used to setup
and bootstrap the a WLS 12c environment. Files in this folder will be uploaded
after creation of the resource to the corresponding bootstrap folder on the resource.
The default location is `/home/${var.tvd_os_user}/cloudinit`.

- [set_env_db19c_config.sh](set_env_db19c_config.sh) script to set the
  corresponding environment variables for installation, software packages etc.
- [TDB01](TDB01) scripts to configure a container database TDB01
- [TDB02](TDB02) scripts to configure a single tenant database TDB02
- [config_db_env.sh](config_db_env.sh) script to create and configure the Oracle
  Databases
