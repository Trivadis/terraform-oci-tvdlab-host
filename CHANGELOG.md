# Changelog
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-configure-file { "MD024":{"allow_different_nesting": true }} -->
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] -

### Added

### Changed

- change set env scripts [set_env_wls12c_config.sh](examples/host_wls12c/cloudinit/set_env_wls12c_config.sh) and [set_env_wls14c_config.sh](examples/host_wls14c/cloudinit/set_env_wls14c_config.sh) to dynamically build the SOFTWARE_LIST string.
- remove dependency on *task_db_install* to run *task_basenv_install*
- Start to build SOFTWARE_LIST b based on environment variables

### Fixed

- add missing value for DOMAIN_NAME in example [host_wls12c.sh](examples/host_wls12c) and [host_wls14c.sh](examples/host_wls14c)

### Removed

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
