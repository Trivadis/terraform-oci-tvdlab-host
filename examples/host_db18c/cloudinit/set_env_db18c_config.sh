#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: set_env_db_config.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.06
# Revision...: 
# Purpose....: Script to config the environement for 18c setup.
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------------
# - Customization -------------------------------------------------------------
# Oracle releases
export ORACLE_HOME_NAME="18.0.0.0"              # Oracle Home Name
export ORACLE_EDITION="EE"                      # Oracle edition EE or SE2
export ORACLE_MAJOR_RELEASE="180"               # Oracle major release
export ORACLE_PWD=""                            # Default Oracle password
export PORT_LIST="1521 5500 5501 5502"          # list of firewall ports to configure

# enable tasks to run during bootstrap
export task_disk_config=true        # configure additional volume
export task_os_setup=true           # enable / disable os setup
export task_sw_download=true        # enable / disable software download
export task_java_install=false      # enable / disable java installation
export task_db_install=true         # enable / disable DB software installation
export task_wls_install=false       # enable / disable WLS software installation
export task_oud_install=false       # enable / disable OUD software installation
export task_basenv_install=true     # enable / disable basenv installation
export task_oudbase_install=false   # enable / disable oudbase installation
export task_firewall_config=true    # enable / disable firewall configuration
export task_lab_config=true         # enable / disable Training configuration

# Scripts and Folder configuration
export ORACLE_HOME="$ORACLE_BASE/product/$ORACLE_HOME_NAME"
export CONFIG_ENV="config_db_env.sh"
export POST_CONFIG_ENV="post_config_db_env.sh"

# regular software packages customization
export DB_BASE_PKG="LINUX.X64_180000_db_home.zip"
export DB_PATCH_PKG="p32524155_180000_Linux-x86-64.zip"
export DB_OJVM_PKG="p32552752_180000_Linux-x86-64.zip"
export DB_OPATCH_PKG="p6880880_180000_Linux-x86-64.zip"
export DB_JDKPATCH_PKG="p32494267_180000_Linux-x86-64.zip"
export DB_PERLPATCH_PKG="p31858032_180000_Linux-x86-64.zip"
export BASENV_PKG="basenv-21.05.final.a.zip"
export BACKUP_PKG="tvdbackup-se-20.11.final.a.tar.gz"

# CPU specific software packages
export CPU_REMOVE_PKG=""
export CPU_DB_PATCH_PKG=""
export CPU_DB_OJVM_PKG=""
export CPU_DB_OPATCH_PKG=""
export CPU_DB_JDKPATCH_PKG=""
export CPU_DB_PERLPATCH_PKG=""

# Target DB Name
export DB1_TARGET="TDB01"              # Name of the first DB
export DB2_TARGET="TDB02"              # Name of the second DB

# Source for DB Clone
export DB1_MASTER="master_TDB180.tgz"  # source for single tenant DB
export DB2_MASTER="master_TCDB180.tgz" # source for multitenant DB

# Create a list of software to download based on environment variables ending 
# with _PKG, _PKGS, or _MASTER
SOFTWARE_LIST=""                        # initial values of SOFTWARE_LIST
for i in $(env|cut -d= -f1|grep '_PKG$\|_PKGS$\|_MASTER$'); do
    # check if environment variable is not empty and value not yet part of SOFTWARE_LIST
    if [ -n "${!i}" ] && [[ $SOFTWARE_LIST != *"${!i}"* ]]; then
        SOFTWARE_LIST+="${!i};"
    fi
done
export SOFTWARE_LIST=$(echo $SOFTWARE_LIST|sed 's/.$//')
# - End of Customization ------------------------------------------------------

# --- EOF ---------------------------------------------------------------------


