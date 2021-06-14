#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: set_env_oud12c_config.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.06
# Revision...: 
# Purpose....: Script to config the environement for OUD 12c setup.
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------------
# - Customization -------------------------------------------------------------
# Oracle releases
export OUD_HOME_NAME="oud12.2.1.4.0"        # Oracle Unified Home Name
export OUDSM_HOME_NAME="fmw12.2.1.4.0"      # OUDSM home name
export BASEDN='dc=trivadislabs,dc=com'      # Default directory base DN
export SAMPLE_DATA='FALSE'                  # Flag to load sample data
export OUD_PROXY='FALSE'                    # Flag to create proxy instance
export OUD_CUSTOM='TRUE'                    # Flag to create custom instance
export PORT_REST_ADMIN=8444
export PORT_REST_HTTP=1080
export PORT_REST_HTTPS=1081
export ORACLE_PWD=""                        # Default Oracle password
export ADMIN_PASSWORD=$ORACLE_PWD           # Default directory admin password
export PORT_LIST="1389 1636 4444 8989 8444 1080 1081 7001 7002" # list of firewall ports to configure

# enable tasks to run during bootstrap
export task_disk_config=true        # configure additional volume
export task_os_setup=true           # enable / disable os setup
export task_sw_download=true        # enable / disable software download
export task_java_install=true       # enable / disable java installation
export task_db_install=false        # enable / disable DB software installation
export task_wls_install=false       # enable / disable WLS software installation
export task_oud_install=true        # enable / disable OUD software installation
export task_basenv_install=false    # enable / disable basenv installation
export task_oudbase_install=true    # enable / disable oudbase installation
export task_firewall_config=true    # enable / disable firewall configuration
export task_lab_config=true         # enable / disable Training configuration

# Source for OUD Config
export OUD_NAME="oud_tvdlab"        # OUD instance names
export OUDSM_NAME="oudsm_domain"    # OUDSM domain name

# define the defaults for software, download etc
USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom"
OPENDS_JAVA_ARGS="-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true"

# Scripts and Folder configuration
export ORACLE_HOME="$ORACLE_BASE/product/$OUD_HOME_NAME"
export CONFIG_ENV="config_oud_env.sh"
export POST_CONFIG_ENV=""

# regular software packages customization
# regular OUD Software Packages
export JAVA_PKG="p32464056_180291_Linux-x86-64.zip"
export OUD_BASE_PKG="p30188352_122140_Generic.zip"
export FMW_BASE_PKG="fmw_12.2.1.4.0_infrastructure_Disk1_1of1.zip"
export OUD_PATCH_PKG="p32730494_122140_Generic.zip"
export FMW_PATCH_PKG="p32698246_122140_Generic.zip"
export COHERENCE_PATCH_PKG="p32581859_122140_Generic.zip"
export OUD_OPATCH_PKG="p28186730_139425_Generic.zip"
export OUD_ONEOFF_PKGS=""
export OUI_PATCH_PKG=""

# - CPU specific software packages ---------------------------------------------
export CPU_REMOVE_PKG=""
export CPU_JAVA_PKG=""
export CPU_OUD_PATCH_PKG=""
export CPU_FMW_PATCH_PKG=""
export CPU_COHERENCE_PATCH_PKG=""
export CPU_OUD_OPATCH_PKG=""
export CPU_OUD_ONEOFF_PKGS=""
export CPU_OUI_PATCH_PKG=""

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


