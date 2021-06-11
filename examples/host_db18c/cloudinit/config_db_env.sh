#!/bin/bash
# ------------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: config_db_env.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.11
# Revision...: 
# Purpose....: Script to configure the db server after bootstrap
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
export LOG_BASE=${LOG_BASE:-"/tmp"}                          # Use script directory as default logbase
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

USAGE=$(find /u0?/app/oracle/*/tvdbackup/lib/TVD -name Usage.pm 2>/dev/null |head -1)
if [ -n "$USAGE" ]; then
    echo "INFO: Workaround TVD-Backup ---------------------------------------------"
    # remove Pod::Find as this is not available as of Perl 5.32.x
    sed -i -e "s|^\(use Pod::Find.*\)|#\1|g" $USAGE
fi

echo "INFO: Listener Environment ------------------------------------------------"
echo "" >${TNS_ADMIN}/tnsnames.ora
# update listener.ora in general just for the Docker listener.ora
sed -i -e "s|<HOSTNAME>|${HOST}|g" ${TNS_ADMIN}/listener.ora

# Start LISTENER and run DBCA
$ORACLE_HOME/bin/lsnrctl status > /dev/null 2>&1 || $ORACLE_HOME/bin/lsnrctl start

# create a multi tenant DB if specified
if [ -n "$DB1_TARGET" ]; then 
    echo "INFO: Setup DB $DB1_TARGET ----------------------------------------------"
    export INSTANCE_INIT="$SCRIPT_BIN_DIR/$DB1_TARGET"
    /opt/oradba/bin/56_clone_database.sh $DB1_TARGET $DB1_MASTER;
else  
    echo "INFO: Skip setup of single Tenant DB $DB1_TARGET ------------------------"
fi

# create a multi tenant DB if specified
if [ -n "$DB2_TARGET" ]; then 
    echo "INFO: Setup DB $DB2_TARGET ----------------------------------------------"
    export INSTANCE_INIT="$SCRIPT_BIN_DIR/$DB2_TARGET"
    /opt/oradba/bin/56_clone_database.sh $DB2_TARGET $DB2_MASTER;
else  
    echo "INFO: Skip setup of single Tenant DB $DB2_TARGET ------------------------"
fi

if [ -f "${ORACLE_BASE}/local/dba/etc/oracle.service" ]; then
    echo "INFO: Configure Oracle Service -------------------------------------------"
    sudo cp ${ORACLE_BASE}/local/dba/etc/oracle.service /usr/lib/systemd/system/
    sudo systemctl --system daemon-reload
    sudo systemctl enable oracle
else
    echo "INFO: Skip Configure Oracle Service --------------------------------------"
fi

if [ -f "$SCRIPT_BIN_DIR/housekeep_work.conf" ]; then 
    echo "INFO: Configure Housekeeping ---------------------------------------------"
    mkdir -p $ORACLE_BASE/local/dba/log/archive
    mkdir -p ${ORACLE_BASE}/network/log/archive
    cp $SCRIPT_BIN_DIR/housekeep_work.conf $ORACLE_BASE/local/dba/etc/housekeep_work.conf
else  
    echo "INFO: Skip Configure Housekeeping ----------------------------------------"
fi

if [ -f "$SCRIPT_BIN_DIR/crontab" ]; then 
    echo "INFO: Configure Crontab --------------------------------------------------"
    # uncomment DB1_TARGET
    if [ -n "$DB1_TARGET" ]; then
        sed -i '/^#.*DB1_TARGET.sh/s/^#//' $SCRIPT_BIN_DIR/crontab
        sed -i "s|DB1_TARGET|$DB1_TARGET|g" $SCRIPT_BIN_DIR/crontab
    fi
    # uncomment DB2_TARGET
    if [ -n "$DB2_TARGET" ]; then
        sed -i '/^#.*DB2_TARGET.sh/s/^#//' $SCRIPT_BIN_DIR/crontab
        sed -i "s|DB2_TARGET|$DB2_TARGET|g" $SCRIPT_BIN_DIR/crontab
    fi
    # load crontab
    crontab $SCRIPT_BIN_DIR/crontab
    crontab -l 
else  
    echo "INFO: Skip Configure Crontab ---------------------------------------------"
fi
echo "INFO: Finish post bootstrap lab environment configuration on host $(hostname) at $(date)"
# --- EOF ----------------------------------------------------------------------