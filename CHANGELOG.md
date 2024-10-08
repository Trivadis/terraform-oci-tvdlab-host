# Changelog
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-configure-file { "MD024":{"allow_different_nesting": true }} -->
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] -

### Added

### Changed

### Fixed

### Removed

## [3.1.0] - 2024-08-14

### Changed

- disable v1 instance metadata
- enable in-transit encryption

## [3.0.14] - 2023-11-30

### Fixed

- Fix the fix volume attach issue when vm is not created

## [3.0.13] - 2023-11-30

### Fixed

- Fix volume attach issue when vm is not created

## [3.0.12] - 2023-05-04

### Changed

- Change default value for *BOOTSTRAP_STATUS1*
- add *authorized_keys* for *ansible* user

## [3.0.11] - 2023-05-04

### Added

- Add an *ansible* user with the same *authorized_keys* as the LAB user
  
## [3.0.10] - 2023-05-03

### Added

- Add cloud-init file for OEL9

## [3.0.9] - 2023-04-24

### Changed

- Fix a minor issue in SQL script of the examples

## [3.0.8] - 2023-04-24

### Fixed

- Remove *{}* to fix terraform call to function *templatefile*

## [3.0.7] - 2023-04-24

### Changed

- rename *boostrap_custom_config_status* to *bootstrap_custom_config_status*
- explicitly select */* when calculating remaining space

### Removed

- remove *dig* from login-info.sh

## [3.0.6] - 2023-04-24

### Fixed

- correctly escape variables in *bastion_config.template.sh*

## [3.0.5] - 2023-04-24

### Added

- add a check if script *bootstrap_linux_host.sh* is still running and status of
  *boostrap_custom_config_status* is set to **running**. If no login banner will
  report an error

### Changed

- change initial value for *boostrap_custom_config_status* to **starting**

## [3.0.4] - 2023-04-22

### Added

- create the file *set_terraform_config_env.sh* during bootstrap process with all
  environment variabled defined during setup

## [3.0.3] - 2023-04-22

### Changed

- change bootstrap status file to */etc/boostrap_config_status*

## [3.0.2] - 2023-04-19

### Changed

- change log base to /var/log

## [3.0.1] - 2023-04-19

### Fixed

- fix issue with *post_bootstrap_config_template*

## [3.0.0] - 2023-04-19

### Changed

- rename variable *tvd_domain* to *lab_domain*
- rename variable *tvd_def_password* to *lab_def_password*
- rename variable *lab_os_user* to *lab_os_user*
- rename variable *tvd_participants* to *numberOf_labs*
- switch to simple bootstrap without system config
- remove bootstrap_host.sh script this now has to be done as part of the LAB / Post setup

### Removed

- remove variable *host_ORACLE_ARCH*, *host_ORACLE_DATA* and *host_ORACLE_ROOT*
- remove variable *host_env_config*
- remove variable *software_password*, *software_user* and *software_repo*

## [2.4.0] - 2023-03-29

### Added

- add a dedicated cloud init file for OL7 and OL8

### Changed

- set default cloud init file based on selected OS release e.g. OL7 or OL8
- move *yum-cron* installation / configuration to cloud-init
- update examples

## [2.3.0] - 2023-03-29

### Changed

- rename *set_env_config.template.sh* to  *set_config_env.template.sh*

## [2.2.0] - 2023-03-10

### Changed

- update headers
- clean up examples

## [2.1.0] - 2023-03-10

### Added

- add dnf-automatic for REL 8 installations

### Fixed

- fix a couple of *tflint* issues

### Changed

- change bootstrap back to download from url / oci bucket
- clean up templates

### Removed

- remove unused variables
- remove file provider and upload via bastion host

## [0.5.3] - 2023-02-20

### Added

- add dnf-automatic for REL 8 installations

### Fixed

- Enhance error handling for yum install

## [0.5.2] - 2023-02-14

### Fixed

- Enhance error handling for yum-config-manager

## [0.5.1] - 2022-05-31

### Fixed

- Limit *yum-cron* installation to OEL 7

## [0.5.0] - 2022-05-18

### Added

- Install *yum-cron* and setup a basic configuration to automatically install updates

## [0.4.0] - 2022-05-03

### Added

- add Accenture SSH deamon configuration values and banner

## [0.3.13] - 2021-12-07

### Fixed

- add *CV_ASSUME_DISTID=OEL7.8* for OEL8 installation

## [0.3.12] - 2021-12-07

### Fixed

- xorg tools installation for OEL8

## [0.3.11] - 2021-12-06

### Fixed

- add a check for OEL release before disable OEL7 repos
  
## [0.3.10] - 2021-11-22

### Changed

- disable ol7_oci_included repository

## [0.3.9] - 2021-11-22

### Fixed

- fix wrong PATH setting in bootstrap template script

## [0.3.8] - 2021-11-22

### Changed

- disable ol7_ksplice repository
- disable ol7_developer repository
- disable oci-included-ol7 repository
- disable ol7_MySQL80 repository
- disable ol7_MySQL80_connectors_community repository
- disable ol7_MySQL80_tools_community repository

## [0.3.7] - 2021-11-22

### Fixed

- disable ol7_ksplice repository

## [0.3.6] - 2021-10-27

### Fixed

- fix wrong path for demo alias configuration

## [0.3.5] - 2021-10-27

### Added

- update host file with own hostname
- Set hosts file immutable
- Set timezone to Europe/Zurich
- Set OCI network configuration to PRESERVE_HOSTINFO=2

### Fixed

- Add missing directory during basenv installation.

## [0.3.4] - 2021-10-27

### Fixed

- Fix issue with curly brackets in bootstrap script

## [0.3.3] - 2021-10-27

### Added

- update basenv.conf with lab environment. Define alias for demo and lab folders

## [0.3.2] - 2021-10-27

### Fixed

- fix replacement of hyphens for lab names with multiple hyphens. Seems that
  there has been other variables been defined.

## [0.3.1] - 2021-10-15

### Fixed

- fix replacement of hyphens for lab names with multiple hyphens

## [0.3.0] - 2021-10-11

### Changed

- Explicitly remove oci and etc folder in LAB base to make sure no sensitive
  information is stored in the lab folder.

## [0.2.1] - 2021-09-23

### Changed

- Add password reset for *os_user* *lab_def_password* in bootstrap template

## [0.2.0] - 2021-09-07

### Added

- add OCI Stack schema templates
- add Database 21c config

### Changed

- update examples with local variable for defined tags

## [0.1.0] - 2021-06-20

### Added

- add new variable for defined tags *defined_tags*
- example crontab to [host_db12c](examples/host_db12c/cloudinit/crontab), [host_db18c](examples/host_db18c/cloudinit/crontab) and [host_db19c](examples/host_db19c/cloudinit/crontab)
- example *oracle.service* file to [host_db12c](examples/host_db12c/cloudinit/oracle.service), [host_db18c](examples/host_db18c/cloudinit/oracle.service) and [host_db19c](examples/host_db19c/cloudinit/oracle.service)
- add reboot with while loop in *post_config_db_env.sh* to reboot DB server as
  soon as volumes are available

### Changed

- change base module version in example files to `version = ">=0.1.0"`
- Update examples to new defined tags *defined_tags*
- Update *config_db_env.sh* in DB example to replace mount points in *oracle.service*

### Fixed

- Update *config_db_env.sh* in DB example and remove *.sh* string while
  replacing DB name in *crontab* file.
- Update *config_db_env.sh* in DB example and replace *local* with *BE_DIR_NAME*
  variable
- fix [variable.tf](examples/variables.tf) to match correct variable values

## [0.0.17] - 2021-06-16

### Added

- add example *bash_profile* to all examples using basenv. The profile does
  source *basenv.ksh* conditionally e.g. if it is available.
- Add reboot command to all post config example scripts.

### Changed

- update file header [set_config_env.template.sh](cloudinit/templates/set_config_env.template.sh)
- change default *LOG_BASE* in all example config script to script execution
  directory rather than `/tmp`.
- change base module version in example files to `version = ">=0.0.17"`

### Fixed

- Fix wrong log file name in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)
  for post config scripts

## [0.0.16] - 2021-06-15

### Added

- add example *POST_CONF_ENV* scripts for the different examples.

### Changed

- changed default value for *task_lab_config* to *true*.
- add verbose information in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh).
- update terraform example files to latest source version [0.0.16].

### Fixed

- fix [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh) to copy bash skel files only if the do not exits.

## [0.0.15] - 2021-06-14

### Changed

- Introduce post configuration script for cloned systems. If system is initialized if will look for the script defined by *POST_CONFIG_ENV*. The script will then be executed nohup as user *oracle*.
- update terraform example files to latest source version [0.0.15].

### Fixed

- Initialize bash variable *CONFIG_ENV* and *POST_CONFIG_ENV* in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)

## [0.0.14] - 2021-06-14

### Changed

- Remove service restart in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)
- update terraform example files to latest source version [0.0.14].

## [0.0.13] - 2021-06-14

### Changed

- Change behavior of command in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)
  LAB environment will only be deployed if `$LAB_REPO` and `$LAB_NAME` is defined.
  Otherwise it will take config files from the *cloudinit* folder.
- update terraform example files to latest source version [0.0.13].

## [0.0.12] - 2021-06-12

### Fixed

- Fix issue with escape of slash in sed command in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)

## [0.0.11] - 2021-06-12

### Changed

- Add empty variable to `set_config_env.template.sh` i.e. *ORACLE_ROOT*,
  *ORACLE_DATA*, *ORACLE_ARCH* and *ORACLE_BASE*
- Bootstrap script now update variables *ORACLE_ROOT*, *ORACLE_DATA*,
  *ORACLE_ARCH* and *ORACLE_BASE* in `set_config_env.template.sh`
- update terraform example files to latest source version [0.0.11].

### Fixed

- check if config has to run

## [0.0.10] - 2021-06-12

### Changed

- update terraform example files to latest source version [0.0.10].
- reorder *runcmd* in cloud-init. First change permissions of some files
- disable agent for file provisioner connect.

### Fixed

- remove dependency on `local` for different setups. It now can be parameterized
  by setting *BE_DIR_NAME*. Default is `local`.
- check if oracle service does exist before restarting it.

## [0.0.9] - 2021-06-12

### Changed

- update to latest source version

### Fixed

- check for service

## [0.0.8] - 2021-06-12

### Fixed

- fix issue with undefined *EMAIL*

## [0.0.7] - 2021-06-11

### Fixed

- fix issue with BE_ALIAS

## [0.0.6] - 2021-06-11

### Changed

- Add service, crontab and housekeeping configuration to the `config_db_env.sh` files.
- Add *ORACLE_ROOT*, *ORACLE_DATA* and *ORACLE_ARCH* variables
- Remove *ORADBA_PKG* from [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)
- Add host example for Oracle Unified Directory 12c [host_oud12c](examples/host_oud12c)

### Fixed

- fix wrong header info in *tfvars.example* files

## [0.0.5] - 2021-06-11

### Added

- Add host example for Oracle Database 18c [host_db18c](examples/host_db18c)
- Add host example for Oracle Database 12c Release 2 [host_db12c](examples/host_db12c)

### Changed

- change base module version in example files to `version = ">=0.0.5"`

### Fixed

- add dummy oratab entry in [bootstrap_host.template.sh](cloudinit/templates/bootstrap_host.template.sh)
  if variable *BE_ALIAS* is defined in the *set_env* file.
- Fix header in example files

## [0.0.4] - 2021-06-11

### Added

- Add host example for Oracle Database 19c [host_db19c](examples/host_db19c)

### Changed

- change set env scripts [set_env_wls12c_config.sh](examples/host_wls12c/cloudinit/set_env_wls12c_config.sh) and [set_env_wls14c_config.sh](examples/host_wls14c/cloudinit/set_env_wls14c_config.sh) to dynamically build the SOFTWARE_LIST string.
- remove dependency on *task_db_install* to run *task_basenv_install*
- Start to build SOFTWARE_LIST b based on environment variables
- Clean up DB config scripts for [host_db19c](examples/host_db19c)

### Fixed

- add missing value for DOMAIN_NAME in example [host_wls12c](examples/host_wls12c) and [host_wls14c](examples/host_wls14c)

## [0.0.3] - 2021-06-11

### Added

- Add readme files for the [cloudinit](cloudinit) folder
- Add example for a WLS 12c [host_wls12c](examples/host_wls12c/README.md)

### Changed

- Add prerequisites to [README.md](examples/host_wls14c/README.md) and
  [README.md](examples/host_wls12c/README.md)

## [0.0.2] - 2021-06-11

### Added

- Add readme files for the [cloudinit](cloudinit) folder
- Add example for a WLS 14c [host_wls14c](examples/host_wls14c/README.md)

### Changed

- fix upload of cloudinit config files

## [0.0.1] - 2021-06-08

### Added

- add initial version of terraform configuration

[unreleased]: https://github.com/Trivadis/terraform-oci-tvdlab-host
[0.0.1]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.1
[0.0.2]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.2
[0.0.3]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.3
[0.0.4]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.4
[0.0.5]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.5
[0.0.6]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.6
[0.0.7]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.7
[0.0.8]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.8
[0.0.9]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.9
[0.0.10]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.10
[0.0.11]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.11
[0.0.12]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.12
[0.0.13]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.13
[0.0.14]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.14
[0.0.15]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.15
[0.0.16]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.16
[0.0.17]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.0.17
[0.1.0]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.1.0
[0.2.0]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.2.0
[0.2.1]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.2.1
[0.3.0]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.0
[0.3.1]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.1
[0.3.2]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.2
[0.3.3]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.3
[0.3.4]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.4
[0.3.5]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.5
[0.3.6]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.6
[0.3.7]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.7
[0.3.8]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.8
[0.3.9]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.9
[0.3.10]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.10
[0.3.11]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.11
[0.3.12]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.12
[0.3.13]: https://github.com/Trivadis/terraform-oci-tvdlab-host/releases/tag/v0.3.13
