# Cloud Init Templates

This directory contains cloud-init user data templates used to setup and bootstrap
the different compute instances.

- [bastion_config.template.sh](bastion_config.template.sh) Script to
  run post bootstrap configuration, OUD and WLS host. General configuration can be
  parameterized via terraform variables e.g. training name. Specific customisation
  has to be adjusted in the corresponding *set_env_config* file. e.g. Oracle Version.
- [linux_host.yaml](linux_host.yaml) *cloud-init* configuration template file
  for a Linux server. This file is generically used for all kind of Linux
  servers e.g. OUD, DB and WLS server.
