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
