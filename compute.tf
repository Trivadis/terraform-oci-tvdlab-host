# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: compute.tf
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

resource "oci_core_instance" "compute" {
  count               = var.host_enabled == true ? var.numberOf_labs : 0
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.host_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.host_name}%02d", count.index)
  shape               = var.host_shape
  state               = var.host_state
  defined_tags        = var.defined_tags
  freeform_tags       = var.tags

  create_vnic_details {
    subnet_id        = var.host_subnet[count.index]
    assign_public_ip = var.host_public_ip
    private_ip       = var.host_private_ip
    display_name     = var.label_prefix == "none" ? "vnic" : "${var.label_prefix}-vnic"
    hostname_label   = var.host_name
  }
  instance_options {
    # disable the legacy (/v1) instance metadata service endpoints 
    are_legacy_imds_endpoints_disabled = true
  }
  # Whether to enable in-transit encryption for the data volume's paravirtualized attachment
  is_pv_encryption_in_transit_enabled = true
  # prevent the host from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = local.bootstrap_config
  }

  shape_config {
    memory_in_gbs = var.host_memory_in_gbs
    ocpus         = var.host_ocpus
  }

  source_details {
    source_type             = "image"
    source_id               = local.host_image_id
    boot_volume_size_in_gbs = var.host_boot_volume_size
  }

  timeouts {
    create = "60m"
  }
}
# --- EOF ----------------------------------------------------------------------
