#!/bin/bash
# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: config_wls_env.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.16
# Revision...: 
# Purpose....: Script to configure the WLS server after bootstrap
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------
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

${ORACLE_HOME}/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning \
    $SCRIPT_BIN_DIR/create_domain.py 

nohup $DOMAIN_HOME/startWebLogic.sh >> ${DOMAIN_HOME}/$DOMAIN_NAME.log 2>&1 &

echo "INFO: Finish post bootstrap lab environment configuration on host $(hostname) at $(date)"
# --- EOF ----------------------------------------------------------------------