# Cloud Init Files and Templates

This directory contains cloud-init user data files and templates used to setup
and bootstrap the a WLS 12c environment. Files in this folder will be uploaded
after creation of the resource to the corresponding bootstrap folder on the resource.
The default location is `/home/${var.tvd_os_user}/cloudinit`.

- [set_env_wls12c_config.sh](set_env_wls12c_config.sh) script to set the corresponding environment variables for installation, software packages etc.
- [create_domain.py](create_domain.py) python script to create a WLS domain
- [config_wls_env.sh](config_wls_env.sh) script to create and configure a WLS domain
