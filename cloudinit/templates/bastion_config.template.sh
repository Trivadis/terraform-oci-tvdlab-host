#!/bin/bash
# ------------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Transactional Data Platform
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ------------------------------------------------------------------------------
# Name.......: bastion_config.template.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2023.04.19
# Revision...: 
# Purpose....: Script to configure the bastion host after bootstrap
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ------------------------------------------------------------------------------
# - Customization --------------------------------------------------------------
HOST=${HOST:-$(hostname)}
export DOMAINNAME="${lab_domain}"               # domain name used in this environment
export LAB_OS_USER="${lab_os_user}"             # LAB OS User used 
export LAB_NAME="${lab_name}"                   # LAB_NAME Name
export LAB_REPO="${lab_source_url}"             # pre-authenticated URL for lab source
export HOST_SETUP_FOLDER="${host_setup_folder}" # Host setup folder name used to untar cloudinit stuff
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

echo "INFO: Start post bootstrap bastion configuration on host $(hostname) at $(date)"

cat << EOF >/etc/profile.d/login-info.sh
#! /usr/bin/env bash

# Basic info
HOSTNAME=\$(uname -n)
ROOT=\$(df -Ph | grep root| awk '{print \$4}' | tr -d '\n')

# System load
MEMORY1=\$(free -t -m | grep Total | awk '{print \$3" MB";}')
MEMORY2=\$(free -t -m | grep "Mem" | awk '{print \$2" MB";}')
LOAD1=\$(cat /proc/loadavg | awk {'print \$1'})
LOAD5=\$(cat /proc/loadavg | awk {'print \$2'})
LOAD15=\$(cat /proc/loadavg | awk {'print \$3'})
PUBLIC_IP=\$(dig +short myip.opendns.com @resolver1.opendns.com)
export PRIVATE_IP=\$(hostname -I |cut -d' ' -f1)
BOOTSTRAP_STATUS1=\$((sudo cloud-init status 2>/dev/null|| echo "n/a")|cut -d' ' -f2|sed 's/ //g')
BOOTSTRAP_STATUS2=\$(cat /etc/boostrap_config_status 2>/dev/null|| echo "n/a")

echo "
===============================================================================
- Welcome to the OCI based lab environment for $LAB_NAME
-------------------------------------------------------------------------------
- Hostname..........: \$HOSTNAME.$DOMAINNAME
- Public IP.........: \$PUBLIC_IP
- Private IP........: \$PRIVATE_IP
-------------------------------------------------------------------------------
- Disk Space........: \$ROOT remaining
- CPU usage.........: \$LOAD1, \$LOAD5, \$LOAD15 (1, 5, 15 min)
- Memory used.......: \$MEMORY1 / \$MEMORY2
- Swap in use.......: \$(free -m | tail -n 1 | awk '{print \$3}') MB
-------------------------------------------------------------------------------
- Bootstrap Status..: \$BOOTSTRAP_STATUS1
- Config Status.....: \$BOOTSTRAP_STATUS2
===============================================================================
"
EOF

# workaround to fix bash completion issues and cockpit infos
rm -vf /etc/issue.d/cockpit.issue /etc/motd.d/cockpit
rm -vf /etc/bash_completion.d/docker-compose

# download lab source
echo "INFO: Download LAB source from $LAB_REPO"
curl -Lsf $LAB_REPO -o /tmp/$LAB_NAME.zip

# extract lab source
echo "INFO: Unpack cloudinit stuff from LAB source"
bsdtar --strip-components=1 -xvf /tmp/$LAB_NAME.zip -C /home/$LAB_OS_USER \
    -s /$(basename $HOST_SETUP_FOLDER)/cloudinit/ "oci/$(basename $HOST_SETUP_FOLDER)/*" 'oci/cloudinit/*'

# Fix permissions
echo "INFO: fix permissions for cloudinit stuff"
chown -R $LAB_OS_USER:$LAB_OS_USER /home/$LAB_OS_USER/.ssh
chown -R $LAB_OS_USER:$LAB_OS_USER /home/$LAB_OS_USER/cloudinit

# Initiate custom bootstrap script
if [ -f "/home/$LAB_OS_USER/cloudinit/bootstrap_linux_host.sh" ]; then
    echo "INFO: Initiate custom bootstap script /home/$LAB_OS_USER/cloudinit/bootstrap_linux_host.sh"
    nohup /home/$LAB_OS_USER/cloudinit/bootstrap_linux_host.sh > /home/$LAB_OS_USER/cloudinit/bootstrap_linux_host.log 2>&1 & 
    echo "running" >/etc/boostrap_config_status
else
    echo "INFO: Skip custom bootstap script /home/$LAB_OS_USER/cloudinit/bootstrap_linux_host.sh"
    echo "n/a" >/etc/boostrap_config_status
fi

echo "INFO: Finish post bootstrap bastion configuration on host $(hostname) at $(date)"
# --- EOF ----------------------------------------------------------------------