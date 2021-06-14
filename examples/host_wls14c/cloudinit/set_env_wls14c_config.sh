#!/bin/bash
# ------------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: set_env_wls14c_config.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.11
# Revision...: 
# Purpose....: Script to config the environement for WLS 14c setup.
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------
# - Customization --------------------------------------------------------------
# Oracle releases
export WLS_HOME_NAME="wls14.1.1.0.0"            # Oracle Home Name
export BE_ALIAS="wls1411"                       # BasEnv Alias name
export ORACLE_PWD=""                            # Default Oracle password
export PORT_LIST="7001 5556 7002"               # list of firewall ports to configure

# Source for WLS Config
export DOMAIN_NAME="cpu_domain"
export DOMAIN_HOME="/u01/domains/$DOMAIN_NAME"
export DOMAIN_MODE="dev"
export PORT_NM="5556"
export PORT="7001"
export PORT_SSL="7002"
export ADMIN_USER="weblogic"
export JAVA_HOME=$(dirname $(dirname $(find $ORACLE_BASE/product/jdk* -name javac 2>/dev/null|sort|tail -1)))

# define the defaults for software, download etc
USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom"
OPENDS_JAVA_ARGS="-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true"

# enable tasks to run during bootstrap
export task_disk_config=true        # configure additional volume
export task_os_setup=true           # enable / disable os setup
export task_sw_download=true        # enable / disable software download
export task_java_install=true       # enable / disable java installation
export task_db_install=false        # enable / disable DB software installation
export task_wls_install=true        # enable / disable WLS software installation
export task_oud_install=false       # enable / disable OUD software installation
export task_basenv_install=true     # enable / disable basenv installation
export task_oudbase_install=false   # enable / disable oudbase installation
export task_firewall_config=true    # enable / disable firewall configuration
export task_lab_config=true         # enable / disable Training configuration

# Scripts and Folder configuration
export ORACLE_HOME="$ORACLE_BASE/product/$WLS_HOME_NAME"
export CONFIG_ENV="config_wls_env.sh"
export POST_CONFIG_ENV=""

# regular software packages customization
# regular WLS Software Packages
export BASENV_PKG="basenv-20.11.final.a.zip"
export TVDPERL_PKG="tvdperl-Linux-x86-64-02.12.00-05.30.02.A.tar.gz"

export JAVA_PKG="p32464056_180291_Linux-x86-64.zip"
export FMW_BASE_PKG="fmw_14.1.1.0.0_wls_lite_Disk1_1of1.zip"
export WLS_OPATCH_PKG="p28186730_139425_Generic.zip"
export FMW_PATCH_PKG="p32247800_141100_Generic.zip"
export COHERENCE_PATCH_PKG="p32124447_141100_Generic.zip"
export WLS_ONEOFF_PKGS=""
export OUI_PATCH_PKG=""

# CPU specific software packages
export CPU_REMOVE_PKG=""
export CPU_WLS_OPATCH_PKG="p28186730_139425_Generic.zip"
export CPU_FMW_PATCH_PKG="p32697788_141100_Generic.zip"
export CPU_COHERENCE_PATCH_PKG="p32581868_141100_Generic.zip"
export CPU_WLS_ONEOFF_PKGS=""
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
# - End of Customization -------------------------------------------------------

# --- EOF ----------------------------------------------------------------------
