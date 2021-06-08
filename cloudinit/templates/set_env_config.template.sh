#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: set_env_config.template.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.08
# Revision...: 
# Purpose....: Template script to config the environement.
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------------
# - Customization -------------------------------------------------------------
export ORACLE_PWD=""                            # Default Oracle password
export PORT_LIST="1521 5500 5501 5502"          # list of firewall ports to configure

# enable tasks to run during bootstrap
export task_disk_config=true        # configure additional volume
export task_os_setup=true           # enable / disable os setup
export task_sw_download=false       # enable / disable software download
export task_java_install=false      # enable / disable java installation
export task_db_install=false        # enable / disable DB software installation
export task_wls_install=false       # enable / disable WLS software installation
export task_oud_install=false       # enable / disable OUD software installation
export task_basenv_install=false    # enable / disable basenv installation
export task_oudbase_install=false   # enable / disable oudbase installation
export task_firewall_config=true    # enable / disable firewall configuration
export task_lab_config=false        # enable / disable Training configuration

# list of software to download
export SOFTWARE_LIST=""
# - End of Customization ------------------------------------------------------

# --- EOF ---------------------------------------------------------------------