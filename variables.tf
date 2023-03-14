# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: variables.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.10
# Revision...: 
# Purpose....: Variable file for the terraform module tvdlab host.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

# provider identity parameters -------------------------------------------------
variable "tenancy_ocid" {
  description = "tenancy OCID where to create the resources"
  type        = string
}

# general oci parameters -------------------------------------------------------
variable "compartment_ocid" {
  description = "OCID of the compartment where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "A string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "resource_name" {
  description = "user-friendly string to name all resource. If undefined it will be derived from compartment name. "
  type        = string
  default     = ""
}

variable "ad_index" {
  description = "The index of the availability domain. This is used to identify the availability_domain place the compute instances."
  default     = 1
  type        = number
}

variable "defined_tags" {
  description = "Defined tags for this resource"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A simple key-value pairs to tag the resources created"
  type        = map(any)
  default     = {}
}

# Trivadis LAB specific parameter ----------------------------------------------
variable "tvd_participants" {
  description = "The number of similar hosts to be created"
  type        = number
  default     = 1
}

variable "tvd_domain" {
  description = "The domain name of the environment"
  type        = string
  default     = "trivadislabs.com"
}

variable "tvd_os_user" {
  description = "Default OS user used to bootstrap"
  default     = "oracle"
  type        = string
}

variable "tvd_def_password" {
  description = "Default password for windows administrator, oracle, directory and more"
  type        = string
}

variable "lab_source_url" {
  description = "preauthenticated URL to the LAB source ZIP file."
  default     = ""
  type        = string
}

variable "ssh_authorized_keys" {
  description = "SSH authorized keys to access the resource."
  type        = string
}

variable "software_repo" {
  description = "Software repository URL to OCI object store swift API"
  type        = string
}

variable "software_user" {
  description = "Default OCI user to access the software repository"
  default     = ""
  type        = string
}

variable "software_password" {
  description = "Default OCI password to access the software repository"
  default     = ""
  type        = string
}

# Host Parameter ---------------------------------------------------------------
variable "host_enabled" {
  description = "whether to create the compute instance or not."
  default     = false
  type        = bool
}

variable "host_name" {
  description = "Name portion of host"
  default     = "db19"
  type        = string
}

variable "host_image_id" {
  description = "Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux)."
  default     = "OEL"
  type        = string
}

variable "host_os" {
  description = "Base OS for the host."
  default     = "Oracle Linux"
  type        = string
}

variable "host_os_version" {
  description = "Define Base OS version for the host."
  default     = "7.9"
  type        = string
}

variable "host_subnet" {
  description = "List of subnets for the host hosts"
  type        = list(string)
}

variable "host_public_ip" {
  description = "whether to assigne a public IP or not."
  default     = false
  type        = bool
}

variable "host_private_ip" {
  description = "Private IP for host."
  default     = "10.0.1.19"
  type        = string
}

variable "hosts_file" {
  description = "path to a custom /etc/hosts which has to be appended"
  default     = ""
  type        = string
}

variable "host_state" {
  description = "Whether the host should be either RUNNING or STOPPED state. "
  default     = "RUNNING"
  type        = string
}

variable "host_shape" {
  description = "The shape of compute instance."
  default     = "VM.Standard.E4.Flex"
  type        = string
}

variable "host_ocpus" {
  description = "The ocpus for the shape."
  default     = 2
  type        = number
}

variable "host_memory_in_gbs" {
  description = "The memory in gbs for the shape."
  default     = 16
  type        = number
}

variable "host_boot_volume_size" {
  description = "Size of the boot volume."
  default     = 150
  type        = number
}

variable "host_volume_enabled" {
  description = "whether to create an additional volume or not."
  default     = false
  type        = bool
}

variable "host_volume_source" {
  description = "Source block volume to clone from."
  default     = ""
  type        = string
}

variable "host_volume_attachment_type" {
  description = "The type of volume."
  default     = "paravirtualized"
  type        = string
}

variable "host_volume_size" {
  description = "Size of the additional volume."
  default     = 256
  type        = number
}

variable "host_env_config" {
  description = "Host environment config script used to bootstrap host."
  default     = ""
  type        = string
}

variable "host_setup_folder" {
  description = "Host specific setup folder for post bootstrap scripts. Defaults to $path.module/cloudinit/"
  default     = ""
  type        = string
}

variable "host_cloudinit_template" {
  description = "Host specific cloudinit YAML file. Defaults to $path.module/cloudinit/templates/linux_host.yaml"
  default     = ""
  type        = string
}

variable "host_bootstrap_template" {
  description = "Host specific bootstrap template script. Defaults to $path.module/cloudinit/templates/bootstrap_host.template.sh"
  default     = ""
  type        = string
}

# Oracle Home configuration variable
variable "host_ORACLE_ROOT" {
  description = "default Oracle root / software folder."
  default     = "/u00"
  type        = string
}

variable "host_ORACLE_DATA" {
  description = "default Oracle data folder used to store datafiles."
  default     = "/u01"
  type        = string
}

variable "host_ORACLE_ARCH" {
  description = "default Oracle arch folder used to store archive logs and backups."
  default     = "/u02"
  type        = string
}
# --- EOF ----------------------------------------------------------------------
