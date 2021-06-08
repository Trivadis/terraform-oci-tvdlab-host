# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: main.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Main file to use terraform module tvdlab compute.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "3.96.0"
    }
  }
}

# define the terraform provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "tvdlab-compute" {
  source  = "Trivadis/tvdlab-compute/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid   = var.tenancy_ocid
  region         = var.region
  compartment_id = var.compartment_id
  # either ssh_public_key or ssh_public_key_path must be specified
  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  host_subnet         = module.tvdlab-vcn.public_subnet_id

  # - Optional Parameters ---------------------------------------------------
  # general oci parameters
  ad_index     = var.ad_index
  label_prefix = var.label_prefix
  tags         = var.tags

  # Lab Configuration
  resource_name    = var.resource_name
  tvd_domain       = var.tvd_domain
  tvd_participants = var.tvd_participants

  # host parameters
  host_enabled          = var.host_enabled
  host_name             = var.host_name
  host_image_id         = var.host_image_id
  host_shape            = var.host_shape
  host_bootstrap        = var.host_bootstrap
  host_state            = var.host_state
  host_public_ip        = var.host_public_ip
  host_private_ip       = var.host_private_ip
  host_os               = var.host_os
  host_os_version       = var.host_os_version
  host_boot_volume_size = var.host_boot_volume_size
}

# display public IPs of hosts
output "host_public_ip" {
  description = "The public IP address of the server instances."
  value       = module.tvdlab-compute.host_public_ip
}
# --- EOF -------------------------------------------------------------------
