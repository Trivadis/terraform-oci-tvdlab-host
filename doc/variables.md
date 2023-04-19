# Module Variables

Variables for the configuration of the terraform module, defined in [variables](../variables.tf). Whereby the following are mandatory:

- `tenancy_ocid` tenancy id where to create the resources.
- `compartment_ocid` OCID of the compartment where to create all resources.
- `host_subnet` List of subnets for the host hosts.
- `ssh_authorized_keys` Authorized ssh public key allowed to access the host.  
- `lab_def_password` Default password for windows administrator, oracle, directory and more

## Provider

| Parameter      | Description                                                                                                                                                        | Values | Default |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------|
| `tenancy_ocid` | Tenancy OCID where to create the resources. Required when configuring provider.                                                                                    | OCID   |         |

## General OCI

| Parameter          | Description                                                                                                         | Values | Default |
|--------------------|---------------------------------------------------------------------------------------------------------------------|--------|---------|
| `compartment_ocid` | OCID of the compartment where to create all resources.                                                              | OCID   |         |
| `label_prefix`     | A string that will be prepended to all resources.                                                                   |        | none    |
| `resource_name`    | A string to name all resource. If undefined it will be derived from compartment name.                               |        | n/a     |
| `tags`             | A simple key-value pairs to tag the resources created.                                                              |        |         |
| `ad_index`         | The index of the availability domain. This is used to identify the availability_domain place the compute instances. |        | 1       |

## Host

| Parameter                     | Description                                                                                                                                                                     | Values                | Default                          |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|----------------------------------|
| `host_enabled`                | Whether to create the host or not.                                                                                                                                              | true/false            | false                            |
| `host_image_id`               | Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux) or WIN (Windows). OEL and WIN requires that `host_os` and `host_os_version` are set correctly. | OCID,OEL or WIN       | OEL                              |
| `host_name`                   | A Name portion of host.                                                                                                                                                         |                       | db                               |
| `host_public_ip`              | whether to assigne a public IP or not.                                                                                                                                          | true/false            | false                            |
| `host_private_ip`             | Private IP for the host.                                                                                                                                                        |                       | 10.0.1.6                         |
| `host_os`                     | Base OS for the host. This is used to identify the default `bastion_image_id`                                                                                                   |                       | Oracle Linux                     |
| `host_os_version`             | Base OS version for the host. This is used to identify the default `bastion_image_id`                                                                                           |                       | 7.8                              |
| `host_shape`                  | The shape of compute instance.                                                                                                                                                  |                       | VM.Standard.E4.Flex              |
| `host_boot_volume_size`       | Size of the boot volume.                                                                                                                                                        |                       | 150                              |
| `host_ocpus`                  | The ocpus for the shape.                                                                                                                                                        |                       | 2                                |
| `host_memory_in_gbs`          | The memory in gbs for the shape.                                                                                                                                                |                       | 16                               |
| `host_volume_enabled`         | Whether to create an additional volume or not.                                                                                                                                  | true/false            | false                            |
| `host_volume_source`          | OCID of the source volume to clone.                                                                                                                                             | OCID                  | n/a                              |
| `host_volume_attachment_type` | The type of volume                                                                                                                                                              | iscsi/paravirtualized | paravirtualized                  |
| `host_volume_size`            | Size of the volume.                                                                                                                                                             |                       | 256                              |
| `host_state`                  | Whether host should be either RUNNING or STOPPED state.                                                                                                                         | RUNNING / STOPPED     | RUNNING                          |
| `host_subnet`                 | List of subnets for the hosts                                                                                                                                                   |                       | n/a                              |
| `ssh_authorized_keys`         | Authorized ssh public key allowed to access the host.                                                                                                                           |                       | n/a                              |
| `host_env_config`             | Host specific setup folder for post bootstrap scripts. Defaults to $path.module/cloudinit/templates/set_config_env.template.sh.                                                 |                       | `set_config_env.template.sh`     |
| `host_setup_folder`           | description = "Host specific setup folder for post bootstrap scripts. Defaults to $path.module/cloudinit.                                                                       |                       | n/a                              |
| `host_cloudinit_template`     | Host specific cloudinit YAML file. Defaults to $path.module/cloudinit/templates/linux_host.yaml.                                                                                |                       | `linux_host.yaml`                |
| `host_bootstrap_template`     | Host specific bootstrap template script. Defaults to $path.module/cloudinit/templates/bootstrap_host.template.sh.                                                               |                       | `bootstrap_host.template.shyaml` |
| `hosts_file`                  | Path to a custom hosts file which will be appended to `/etc/hosts`                                                                                                              |                       | `hosts.template`                 |
| `host_ORACLE_ROOT`            | default Oracle root / software folder.                                                                                                                                          |                       | `/u00`                           |
| `host_ORACLE_DATA`            | default Oracle data folder used to store datafiles.                                                                                                                             |                       | `/u01`                           |
| `host_ORACLE_ARCH`            | default Oracle arch folder used to store archive logs and backups.                                                                                                              |                       | `/u02`                           |

## Trivadis LAB

Specific parameter to configure the Trivadis LAB environment.

| Parameter           | Description                                                                                                                       | Values | Default          |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|--------|------------------|
| `tvd_participants`  | The number of resource to create. This is used to build several identical environments for a training and laboratory environment. |        | 1                |
| `lab_domain`        | The domain name of the LAB environment. This is used to register the public IP address of the host.                               |        | trivadislabs.com |
| `tvd_os_user`       | The default OS user used to setup the compute instance.                                                                           |        | `oracle`         |
| `lab_def_password`  | Default password for windows administrator, oracle, directory and more                                                            |        | n/a              |
| `lab_source_url`    | pre-Authenticated URL to the LAB source ZIP file.                                                                                 |        | n/a              |
| `software_repo`     | Software repository URL to OCI object store swift API or any other URL where packages can be downloaded using `curl`              |        | n/a              |
| `software_user`     | Default OCI user to access the software repository                                                                                |        | n/a              |
| `software_password` | Default OCI password to access the software repository.                                                                           |        | n/a              |

## Local Variables

| Parameter                 | Description                                                                                                                                                                                                             | Values                       | Default |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|---------|
| `availability_domain`     | Effective name of the availability domain based on region and `var.ad_index`.                                                                                                                                     |                              |         |
| `host_image_id`           | Tenancy OCID where to create the resources. Required when configuring provider.                                                                                                                                         |                              |         |
| `resource_name`           | Local variable containing either the value of `var.resource_name` or evaluated based on the compartment name.                                                                                                           |                              |         |
| `resource_shortname`      | Short, lower case version of the `resource_name` variable without any `-`.                                                                                                                                              |                              |         |
| `host_image_id`           | OCID of the hostname image. If `var.host_image_id` is set to *OEL*, then the effective OCID will be evaluated using `data.oci_core_images` and based on `var.host_os`, `var.host_os_version` and `var.compartment_ocid` | OCID                         | OEL     |
| `hosts_file`              | Host file to upload to the compute instance                                                                                                                                                                             |                              |         |
| `host_env_config`         | Environment script to initiate the compute instance.                                                                                                                                                                    | `set_config_env.template.sh` |         |
| `host_setup_folder`       | Cloudinit configuration folder                                                                                                                                                                                          | `cloudinit`                  |         |
| `host_cloudinit_template` | Cloudinit YAML file used to initiate the compute instance.                                                                                                                                                              | `linux_host.yaml`            |         |
| `host_bootstrap_template` | Bootstrap template file to setup the compute instance.                                                                                                                                                                  | `bootstrap_host.template.sh` |         |
| `host_bootstrap`          | Bootstrap file with actual values                                                                                                                                                                                       |                              |         |
