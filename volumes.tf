# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: volumes.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.03.10
# Revision...: 
# Purpose....: Define volumes for the terraform module tvdlab host.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------

# define the block volume
resource "oci_core_volume" "CreateVolume" {
  count               = var.host_volume_enabled == true ? var.numberOf_labs : 0
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.host_name}%02d-volume", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.host_name}%02d-volume", count.index)
  size_in_gbs         = var.host_volume_size
  freeform_tags       = var.tags

  dynamic "source_details" {
    for_each = var.host_volume_source == "" ? [] : [1]
    content {
      id   = var.host_volume_source
      type = "volume"
    }
  }
}

# Create a volume attachement
resource "oci_core_volume_attachment" "CreateVolumeAttachment" {
  count           = var.host_volume_enabled == true ? var.numberOf_labs : 0
  attachment_type = var.host_volume_attachment_type
  instance_id     = oci_core_instance.compute[count.index].id
  volume_id       = oci_core_volume.CreateVolume[count.index].id
}

# --- EOF ----------------------------------------------------------------------
