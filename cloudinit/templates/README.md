# Cloud Init Templates

This directory contains cloud-init user data templates used to setup and bootstrap
the different compute instances.

- [bootstrap_host.template.sh](bootstrap_host.template.sh) Script to
  bootstrap the database, OUD and WLS host. General configuration can be
  parameterized via terraform variables e.g. training name. Specific customisation
  has to be adjusted in the corresponding *set_env_config* file. e.g. Oracle Version.
- [linux_host.yaml](linux_host.yaml) *cloud-init* configuration template file
  for a Linux server. This file is generically used for all kind of Linux
  servers e.g. OUD, DB and WLS server.
- [set_config_env.template.sh](set_config_env.template.sh) Script used to set the
  environment variables during bootstrap phase as well post bootstrap. This file
  is an example for a 19c Database server setup. More examples can be found in
  the [examples](../examples) folder servers e.g. OUD, DB and WLS server.
