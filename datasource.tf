# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: datasource.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.05.04
# Revision...: 3.0.12
# Purpose....: Compute Instance for the terraform module tvdlab host.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

# get list of availability domains
data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.tenancy_ocid
}

# get compartment information
data "oci_identity_compartment" "compartment" {
  id = var.compartment_ocid
}

# define the Oracle linux image
data "oci_core_images" "oracle_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.host_os
  operating_system_version = var.host_os_version
  shape                    = var.host_shape
  sort_by                  = "TIMECREATED"
}
# --- EOF ----------------------------------------------------------------------
