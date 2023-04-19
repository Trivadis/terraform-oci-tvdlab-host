#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: config_oud_env.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.04.19
# Revision...: 
# Purpose....: Script to configure the OUD server after bootstrap
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------------
# - Customization --------------------------------------------------------------
ORACLE_USER=$(id -nu)
HOST=${HOST:-$(hostname)}
# - End of Customization -------------------------------------------------------

# - Default Values -------------------------------------------------------------
# source genric environment variables and functions
export SCRIPT_NAME=$(basename $0)               # script name
export SCRIPT_BIN_DIR=$(dirname $0)             # script bin directory
# define logfile and logging
export LOG_BASE=${LOG_BASE:-"$SCRIPT_BIN_DIR"}  # Use script directory as default logbase
# Define Logfile but first reset LOG_BASE if directory does not exists
if [ ! -d ${LOG_BASE} ] || [ ! -w ${LOG_BASE} ] ; then
    echo "INFO : set LOG_BASE to /tmp"
    export LOG_BASE="/tmp"
fi
TIMESTAMP=$(date "+%Y.%m.%d_%H%M%S")
readonly LOGFILE="$LOG_BASE/$(basename $SCRIPT_NAME .sh)_$TIMESTAMP.log"
# - EOF Default Values ---------------------------------------------------------

# - Initialization -------------------------------------------------------------
# Define a bunch of bash option see 
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o nounset                              # stop script after 1st cmd failed
set -o errexit                              # exit when 1st unset variable found
set -o pipefail                             # pipefail exit after 1st piped commands failed

# initialize logfile
touch $LOGFILE 2>/dev/null
exec &> >(tee -a "$LOGFILE")                # Open standard out at `$LOG_FILE` for write.  
exec 2>&1  

echo "INFO: Start post bootstrap lab environment configuration on host $(hostname) at $(date)"
# source the release specific environment variables
if [ -f "$SCRIPT_BIN_DIR/set_config_env.sh" ]; then
    echo "INFO: Source basic Oracle Environment -------------------------------------"
    . $SCRIPT_BIN_DIR/set_config_env.sh
else
    echo "WARN: could not source db environment"
fi

# create a OUD Instance
export OUD_INSTANCE=$OUD_NAME
if [ -n "$OUD_INSTANCE" ]; then 
    echo "INFO: Setup OUD Instance $OUD_INSTANCE ----------------------------------"
    export ORACLE_HOME="$ORACLE_BASE/product/$OUD_HOME_NAME"
    export INSTANCE_INIT="$SCRIPT_BIN_DIR/${OUD_INSTANCE}"
    if [ ! -d "${ORACLE_DATA}/instances/${OUD_INSTANCE}" ]; then
        /opt/oradba/bin/62_create_oud_instance.sh
        cp -r $SCRIPT_BIN_DIR/${OUD_INSTANCE}/setup ${ORACLE_DATA}/admin/${OUD_INSTANCE}/create
        # create backup
        $ORACLE_BASE/local/oudbase/bin/oud_backup.sh -v -t FULL
        # create ldif export
        $ORACLE_BASE/local/oudbase/bin/oud_export.sh -v
    else
        echo " - Re-Create Instance ${OUD_INSTANCE}" 1>&2
        $ORACLE_BASE/local/oudbase/bin/oud_start_stop.sh -v -i $OUD_INSTANCE -a stop
        sed -i "/OUD_INSTANCE/d" /u01/etc/oudtab

        rm -rf "${ORACLE_DATA}/instances/${OUD_INSTANCE}"
        /opt/oradba/bin/62_create_oud_instance.sh
        cp -r $SCRIPT_BIN_DIR/${OUD_INSTANCE}/setup ${ORACLE_DATA}/admin/${OUD_INSTANCE}/create
        
        # create backup
        $ORACLE_BASE/local/oudbase/bin/oud_backup.sh -v -t FULL
        # create ldif export
        $ORACLE_BASE/local/oudbase/bin/oud_export.sh -v
    fi
else  
    echo "INFO: Skip Setup OUD Instance -------------------------------------------"
fi

# create a OUDSM Instance
export DOMAIN_NAME=$OUDSM_NAME
if [ -n "$DOMAIN_NAME" ]; then 
    export ORACLE_HOME="$ORACLE_BASE/product/$OUDSM_HOME_NAME"
    if [ ! -d "${ORACLE_DATA}/domains/${DOMAIN_NAME}" ]; then
        /opt/oradba/bin/72_create_oudsm_domain.sh

        #disable client endpoint security check MOS Note 2463219.1
        cp ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh.orig
        sed  -i -e '/^JAVA_OPTIONS/s/"$/-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true"/' ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh
        # Start the OUDSM Domain
        $ORACLE_BASE/local/oudbase/bin/oud_start_stop.sh -v -i $DOMAIN_NAME
    else
        sed -i '/oudsm_domain/d' /u01/etc/oudtab
        rm -rf "${ORACLE_DATA}/domains/${DOMAIN_NAME}"
        /opt/oradba/bin/72_create_oudsm_domain.sh

        #disable client endpoint security check MOS Note 2463219.1
        cp ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh.orig
        sed  -i -e '/^JAVA_OPTIONS/s/"$/-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true"/' ${ORACLE_DATA}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh
        # Start the OUDSM Domain
        $ORACLE_BASE/local/oudbase/bin/oud_start_stop.sh -v -i $DOMAIN_NAME
    fi
else  
    echo "INFO: Skip Setup OUDSM Instance -----------------------------------------"
fi
echo "INFO: Finish post bootstrap lab environment configuration on host $(hostname) at $(date)"
# --- EOF ----------------------------------------------------------------------