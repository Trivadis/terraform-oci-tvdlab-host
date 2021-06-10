# ------------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: main.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.05.05
# Revision...: 
# Purpose....: Main configuration to build the training environment.
# Notes......: Define the core resouces using the module tvdlab-base
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

# - ADD VCM Module -------------------------------------------------------------
module "tvdlab-db19c" {
  source = "Trivadis/tvdlab-host/oci"
  #source  = "./host_db19c"

  # - Mandatory Parameters -----------------------------------------------------
  region              = var.region                          # The OCI region where resources will be created
  compartment_ocid    = var.compartment_ocid                # OCID of the compartment where to create all resources
  tenancy_ocid        = var.tenancy_ocid                    # tenancy id where to create the resources
  host_subnet         = module.tvdlab-vcn.private_subnet_id # List of subnets for the host hosts
  tvd_def_password    = var.tvd_def_password                # Default password for windows administrator, oracle, directory and more
  lab_source_url      = var.lab_source_url                  # preauthenticated URL to the LAB source ZIP file.
  ssh_authorized_keys = local.ssh_authorized_keys           # SSH authorized keys to access the resource.
  ssh_private_key     = local.ssh_private_key               # ssh private key used to access the internal hosts.
  # - Optional Parameters ------------------------------------------------------
  # Lab Configuration
  resource_name         = var.resource_name                       # user-friendly string to name all resource. If undefined it will be derived from compartment name.
  tvd_domain            = var.tvd_domain                          # The domain name of the LAB environment
  tvd_os_user           = var.tvd_os_user                         # Default OS user used to bootstrap
  tvd_participants      = var.tvd_participants                    # The number of VCN to create
  bastion_hosts         = module.tvdlab-bastion.bastion_public_ip # List of bastion host ips
  software_repo         = var.software_repo                       # Software repository URL to OCI object store swift API
  software_user         = var.software_user                       # Default OCI user to access the software repository
  software_password     = var.software_password                   # Default OCI password to access the software repository
  ad_index              = var.ad_index                            # The index of the availability domain. This is used to identify the availability_domain place the compute instances.
  label_prefix          = var.label_prefix                        # A string that will be prepended to all resources
  tags                  = var.tags                                # A simple key-value pairs to tag the resources created
  hosts_file            = local.hosts_file                        # path to a custom /etc/hosts which has to be appended"
  host_ORACLE_ROOT      = var.ORACLE_ROOT                         # default Oracle root / software folder 
  host_ORACLE_DATA      = var.ORACLE_DATA                         # default Oracle data folder used to store datafiles
  host_ORACLE_ARCH      = var.ORACLE_ARCH                         # default Oracle arch folder used to store archive logs and backups
  host_setup_folder     = "./host_db19c"                          # Host specific setup folder for post bootstrap scripts. Defaults to $path.module/cloudinit/templates/set_env_config.template.sh
  host_env_config       = "./host_db19c/set_env_db19_config.sh"   # Host environment config script used to bootstrap host.
  host_enabled          = var.host_db19c_enabled                  # whether to create the compute instance or not.
  host_name             = var.host_db19c_name                     # Name portion of host
  host_image_id         = var.host_db19c_image_id                 # Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux).
  host_boot_volume_size = var.host_db19c_boot_volume_size         # Size of the boot volume.
  host_ocpus            = var.host_db19c_ocpus                    # The ocpus for the shape.
  host_memory_in_gbs    = var.host_db19c_memory_in_gbs            # The memory in gbs for the shape.
  host_volume_enabled   = var.host_db19c_volume_enabled           # add a block volume
  host_volume_size      = var.host_db19c_volume_size              # Size of the additional volume.
  host_volume_source    = var.host_db19c_volume_source            # Source block volume to clone from.
  host_private_ip       = var.host_db19c_private_ip               # Private IP for host.
  host_shape            = var.host_db19c_shape                    # The shape of compute instance.
  host_state            = var.host_db19c_state                    # Whether the host should be either RUNNING or STOPPED state.
}

# ------------------------------------------------------------------------------
# - Variables
# ------------------------------------------------------------------------------

# Host Parameter ---------------------------------------------------------------
variable "host_db19c_enabled" {
  description = "whether to create the compute instance or not."
  default     = false
  type        = bool
}

variable "host_db19c_name" {
  description = "Name portion of host"
  default     = "db19"
  type        = string
}

variable "host_db19c_image_id" {
  description = "Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux)."
  default     = "OEL"
  type        = string
}

variable "host_db19c_boot_volume_size" {
  description = "Size of the boot volume."
  default     = 150
  type        = number
}

variable "host_db19c_shape" {
  description = "The shape of compute instance."
  default     = "VM.Standard.E3.Flex"
  type        = string
}

variable "host_db19c_ocpus" {
  description = "The ocpus for the shape."
  default     = 2
  type        = number
}

variable "host_db19c_memory_in_gbs" {
  description = "The memory in gbs for the shape."
  default     = 16
  type        = number
}

variable "host_db19c_volume_enabled" {
  description = "whether to create an additional volume or not."
  default     = false
  type        = bool
}

variable "host_db19c_volume_source" {
  description = "Source block volume to clone from."
  default     = ""
  type        = string
}

variable "host_db19c_volume_size" {
  description = "Size of the additional volume."
  default     = 256
  type        = number
}

variable "host_db19c_private_ip" {
  description = "Private IP for host."
  default     = "10.0.1.19"
  type        = string
}

variable "host_db19c_state" {
  description = "Whether the host should be either RUNNING or STOPPED state. "
  default     = "RUNNING"
}

# --- EOF ----------------------------------------------------------------------