# Module Variables

Variables for the configuration of the terraform module, defined in [variables](../variables.tf). Whereby the following are mandatory:

* `tenancy_ocid` 
* `region` Region where to provision the VCN.
* `compartment_id` OCID of the compartment where to create all resources.
* `ssh_public_key` The content of the ssh public key used to access the host. Either `ssh_public_key` or `ssh_public_key_path` must be specified.
* `ssh_public_key_path` path to the ssh public key used to access the host. Either `ssh_public_key` or `ssh_public_key_path` must be specified.
* `host_subnet` List of subnets for the host hosts

## Provider

| Parameter      | Description                                                                                                                                                        | Values | Default |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------|
| `tenancy_ocid` | Tenancy OCID where to create the resources. Required when configuring provider.                                                                                    | OCID   |         |
| `region`       | Region where to provision the VCN. [List of regions](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm). Required when configuring provider. |        |         |

## General OCI

| Parameter        | Description                                                                           | Values | Default |
|------------------|---------------------------------------------------------------------------------------|--------|---------|
| `compartment_id` | OCID of the compartment where to create all resources.                                | OCID   |         |
| `label_prefix`   | A string that will be prepended to all resources.                                     |        | none    |
| `resource_name`  | A string to name all resource. If undefined it will be derived from compartment name. |        | n/a     |
| `tags`           | A simple key-value pairs to tag the resources created.                                |        |         |
| `ad_index`       | The index of the availability domain. This is used to identify the availability_domain place the compute instances. |        | 1       |

## Host

| Parameter                     | Description                                                                                                                                                                     | Values                | Default          |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|------------------|
| `host_bootstrap`              | Bootstrap script to provision the host.                                                                                                                                         |                       | n/a              |
| `host_enabled`                | Whether to create the host or not.                                                                                                                                              | true/false            | false            |
| `host_image_id`               | Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux) or WIN (Windows). OEL and WIN requires that `host_os` and `host_os_version` are set correctly. | OCID,OEL or WIN       | OEL              |
| `host_name`                   | A Name portion of host.                                                                                                                                                         |                       | db               |
| `host_public_ip`              | whether to assigne a public IP or not.                                                                                                                                          | true/false            | false            |
| `host_private_ip`             | Private IP for the host.                                                                                                                                                        |                       | 10.0.1.6         |
| `host_os`                     | Base OS for the host. This is used to identify the default `bastion_image_id`                                                                                                   |                       | Oracle Linux     |
| `host_os_version`             | Base OS version for the host. This is used to identify the default `bastion_image_id`                                                                                           |                       | 7.8              |
| `host_shape`                  | The shape of compute instance.                                                                                                                                                  |                       | VM.Standard2.2   |
| `host_boot_volume_size`       | Size of the boot volume.                                                                                                                                                        |                       | 150              |
| `host_volume_enabled`         | Whether to create an additional volume or not.                                                                                                                                  | true/false            | false            |
| `host_volume_source`          | OCID of the source volume to clone.                                                                                                                                             | OCID                  | n/a              |
| `host_volume_attachment_type` | The type of volume                                                                                                                                                              | iscsi/paravirtualized | paravirtualized  |
| `host_volume_size`            | Size of the volume.                                                                                                                                                             |                       | 256              |
| `host_state`                  | Whether host should be either RUNNING or STOPPED state.                                                                                                                         | RUNNING / STOPPED     | RUNNING          |
| `host_subnet`                 | List of subnets for the hosts                                                                                                                                                   |                       | n/a              |
| `ssh_public_key_path`         | Path to the ssh public key used to access the host. set this or the `ssh_public_key`                                                                                            |                       | n/a              |
| `ssh_public_key`              | The content of the ssh public key used to access the host. set this or the `ssh_public_key_path`                                                                                |                       | n/a              |
| `yum_upgrade`                 | Enable YUM upgrade during bootstrap / cloud-init                                                                                                                                | true/false            | true             |
| `hosts_file`                  | Path to a custom hosts file which will be appended to `/etc/hosts`                                                                                                              |                       | `hosts.template` |

## Trivadis LAB

Specific parameter to configure the Trivadis LAB environment.

| Parameter          | Description                                                                                                                       | Values | Default          |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------|--------|------------------|
| `tvd_participants` | The number of resource to create. This is used to build several identical environments for a training and laboratory environment. |        | 1                |
| `tvd_domain`       | The domain name of the LAB environment. This is used to register the public IP address of the host.                               |        | trivadislabs.com |

## Local Variables

| Parameter             | Description                                                                                    | Values | Default |
|-----------------------|------------------------------------------------------------------------------------------------|--------|---------|
| `availability_domain` | Effective name of the availability domain based on `var.region` and `var.ad_index`. |        |         |
| `host_image_id`       | Tenancy OCID where to create the resources. Required when configuring provider.                |        |         |
| `resource_name`       | Local variable containing either the value of `var.resource_name` or the compartment name.     |        |         |
| `resource_shortname`  | Short, lower case version of the `resource_name` variable.                                     |        |         |
