# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: locals.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.08
# Revision...: 
# Purpose....: Local variables for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

locals {
  availability_domain     = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad_index - 1].name
  resource_name           = var.resource_name == "" ? data.oci_identity_compartment.compartment.name : var.resource_name
  resource_shortname      = lower(replace(local.resource_name, "-", ""))
  host_image_id           = var.host_image_id == "OEL" ? data.oci_core_images.oracle_images.images[0].id : var.host_image_id
  hosts_file              = var.hosts_file == "" ? "${path.module}/etc/hosts.template" : var.hosts_file
  host_env_config         = var.host_env_config == "" ? "${path.module}/cloudinit/templates/set_config_env.template.sh" : var.host_env_config
  host_setup_folder       = var.host_setup_folder == "" ? "${path.module}/cloudinit/" : var.host_setup_folder
  host_cloudinit_template = var.host_cloudinit_template == "" ? "${path.module}/cloudinit/templates/linux_host.yaml" : var.host_cloudinit_template
  host_bootstrap_template = var.host_bootstrap_template == "" ? "${path.module}/cloudinit/templates/bootstrap_host.template.sh" : var.host_bootstrap_template
  host_bootstrap = base64encode(templatefile(local.host_cloudinit_template, {
    yum_upgrade       = true
    os_user           = var.tvd_os_user
    authorized_keys   = base64gzip(var.ssh_authorized_keys)
    env_conf_script   = base64gzip(file(local.host_env_config))
    etc_hosts         = base64gzip(local.hosts_file)
    lab_name          = local.resource_name
    lab_source_url    = var.lab_source_url
    host_setup_folder = local.host_setup_folder
    bootstrap_script = base64gzip(templatefile(local.host_bootstrap_template, {
      os_user           = var.tvd_os_user
      tvd_def_password  = var.tvd_def_password
      lab_name          = var.resource_name
      tvd_domain        = var.tvd_domain
      software_repo     = var.software_repo
      software_user     = var.software_user
      software_password = var.software_password
      lab_source_url    = var.lab_source_url
      ORACLE_ROOT       = var.host_ORACLE_ROOT
      ORACLE_DATA       = var.host_ORACLE_DATA
      ORACLE_ARCH       = var.host_ORACLE_ARCH
    }))
  }))
}
# --- EOF ----------------------------------------------------------------------
