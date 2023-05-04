# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: locals.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.05.04
# Revision...: 3.0.12
# Purpose....: Local variables for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

locals {
  availability_domain             = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad_index - 1].name
  resource_name                   = var.resource_name == "" ? data.oci_identity_compartment.compartment.name : var.resource_name
  resource_shortname              = lower(replace(local.resource_name, "-", ""))
  host_image_id                   = var.host_image_id == "OEL" ? data.oci_core_images.oracle_images.images[0].id : var.host_image_id
  hosts_file                      = var.hosts_file == "" ? "${path.module}/etc/hosts.template" : var.hosts_file
  host_setup_folder               = var.host_setup_folder == "" ? "${path.module}/cloudinit/" : var.host_setup_folder
  default_bootstrap_template_name = var.host_os_version == "9" ? "linux_host_ol9.yaml" : var.host_os_version == "8" ? "linux_host_ol8.yaml" : "linux_host_ol7.yaml"
  bootstrap_config_template       = var.bootstrap_config_template == "" ? "${path.module}/cloudinit/templates/${local.default_bootstrap_template_name}" : var.bootstrap_config_template
  post_bootstrap_config_template  = var.post_bootstrap_config_template == "" ? "${path.module}/cloudinit/templates/bastion_config.template.sh" : var.post_bootstrap_config_template
  bootstrap_config = base64encode(templatefile(local.bootstrap_config_template, {
    lab_os_user     = var.lab_os_user
    authorized_keys = base64gzip(var.ssh_authorized_keys)
    etc_hosts       = base64gzip(local.hosts_file)
    post_bootstrap_config = base64gzip(templatefile(local.post_bootstrap_config_template, {
      lab_os_user       = var.lab_os_user
      lab_name          = var.resource_name
      lab_domain        = var.lab_domain
      lab_source_url    = var.lab_source_url
      lab_def_password  = var.lab_def_password
      host_setup_folder = local.host_setup_folder
    }))
  }))
}
# --- EOF ----------------------------------------------------------------------
