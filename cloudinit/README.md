# Cloud Init Files and Templates

This directory contains cloud-init user data files and templates used to setup
and bootstrap the different compute instances.

- [bootstrap_db_host.template.sh](bootstrap_db_host.template.sh) Script to
  bootstrap the database host. General configuration can be parameterized via
  terraform variables e.g. training name. Specific customisation has to be
  adjusted in the customization section of the script e.g. Oracle Version.
- [bootstrap_oud_host.template.sh](bootstrap_oud_host.template.sh) Script to
  bootstrap the OUD host. General configuration can be parameterized via
  terraform variables e.g. training name. Specific customisation has to be
  adjusted in the customization section of the script e.g. Oracle Version,.
- [bootstrap_win_host.template.ps1](bootstrap_win_host.template.ps1) Script to
  bootstrap the Windows Server.
- [bootstrap_wls_host.template.sh](bootstrap_wls_host.template.sh) Script to
  bootstrap the WLS host. General configuration can be parameterized via
  terraform variables e.g. training name. Specific customisation has to be
  adjusted in the customization section of the script e.g. Oracle Version,.
- [linux_host.yaml](linux_host.yaml) *cloud-init* configuration template file
  for a Linux server. This file is generically used for all kind of Linux
  servers e.g. OUD, DB and WLS server.

# Scripts

This directory contains scripts used to configure the different
compute instances after the initial bootstrap done by cloud-init.

- [oud_tvdlab](oud_tvdlab) OUD setup scripts to configure an OUD EUS instance.
- [TCDB00](TCDB00) database setup script to configure a container database.
- [TDB00](TDB00) database setup script to configure a single tenant database.
- [config_db_env.sh](config_db_env.sh) script to configuration the DB environment.
  This includes to clone, configure and backup the databases. DB names are
  defined in [set_env_db19c_config.sh](set_env_db19c_config.sh)
- [config_oud_env.sh](config_oud_env.sh) script to configuration the OUD
  environment. This includes to setup, configure and backup the OUD and OUDSM
  instances. The names are defined in [set_env_oud12c_config.sh](set_env_oud12c_config.sh)
- [config_win_env.ps1](config_win_env.ps1) script to configuration the Windows
  server.
- [create_domain.py](create_domain.py) script to create an OUDSM domain.
- [set_env_db_config.sh](set_env_db_config.sh) script to define the
  environment variables for the initial configuration of the database server.
  This includes DB names as well software packages which will be downloaded an
  installed.
- [set_env_oud12c_config.sh](set_env_oud12c_config.sh) script to define the
  environment variables for the initial configuration of the OUD server.
  This includes DB names as well software packages which will be downloaded an
  installed.
- [guacamole_connections.sql](guacamole_connections.sql) Guacamole connect
  configuration
