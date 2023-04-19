#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis - Part of Accenture, Platform Factory - Data Platforms
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: bootstrap_host.template.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2021.06.08
# Revision...: 
# Purpose....: Script to bootstrap a DB, OUD or WLS server. Configuration of the
#              script is done via set_config_env.sh script as well terraform 
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------------
# - Terraform Customization ---------------------------------------------------
# Variable values provided by terraform template file
export ORACLE_USER="${os_user}"                 # OS User used 
export DOMAINNAME="${lab_domain}"               # domain name used in this environment
export ORACLE_PWD="${lab_def_password}"         # default password used to configure different stuff
export LAB_NAME="${lab_name}"                   # LAB_NAME Name
export SOFTWARE_REPO="${software_repo}"         # URL of the software repository in OCI
export SOFTWARE_REPO=$(echo $SOFTWARE_REPO|sed 's/\/*$//g') # remove trailing backslash
export SOFTWARE_USER="${software_user}"         # OCI User to access the software repository
export SOFTWARE_PASSWORD="${software_password}" # API Token to access the software repository
export LAB_REPO="${lab_source_url}"             # pre-authenticated URL for lab source
export ORACLE_ROOT=${ORACLE_ROOT}               # default Oracle root / software folder 
export ORACLE_DATA=${ORACLE_DATA}               # default Oracle data folder used to store datafiles
export ORACLE_ARCH=${ORACLE_ARCH}               # default Oracle arch folder used to store archive logs and backups
# - End of Terraform Customization --------------------------------------------

# - Customization -------------------------------------------------------------
export BE_ALIAS=""
export CONFIG_ENV=""
export POST_CONFIG_ENV=""
export EMAIL="MAILADDRESS"
export BE_DIR_NAME="local"                      # Name of the TVD-BasEnv folder either local oder tvdtoolbox
# - End of Customization ------------------------------------------------------

# - Default Values ------------------------------------------------------------
# define logfile and logging
export SCRIPT_NAME=$(basename $0)               # script name
export SCRIPT_BIN_DIR=$(dirname $0)             # script bin directory
export ORACLE_BASE="$ORACLE_ROOT/app/oracle"    # Oracle base directory
export OPT_DIR="/opt"                           # opt folder to store the oradba init scripts
export ORADBA_BIN="$OPT_DIR/oradba/bin"         # bin foder of oradba init 
export SOFTWARE="$OPT_DIR/stage"                # local software stage folder
export DOWNLOAD="/tmp/download"                 # temporary download location
export LAB_NAME_LOWER=$(echo $LAB_NAME| tr '[:upper:]' '[:lower:]')                 # lower case LAB name
export LAB_BASE="$ORACLE_BASE/$BE_DIR_NAME/$(echo $LAB_NAME_LOWER| sed 's/-//g')"   # local LAB base folder
export PRIVATE_IP="$(hostname -I |cut -d' ' -f1)"  # IP address for the compute instance
export LOG_BASE="/var/log"                      # Use script directory as default logbase
TIMESTAMP=$(date "+%Y.%m.%d_%H%M%S")            # timestamp used for the log file
readonly LOGFILE="$LOG_BASE/$(basename $SCRIPT_NAME .sh)_$TIMESTAMP.log" # absolute logfile name

# check if bootstrap is necessary based on existing bootstrap logfile
if [ -n "$(find $LOG_BASE -name "$(basename $SCRIPT_NAME .sh)*" 2>/dev/null)" ]; then 
    system_initilized=true
else
    system_initilized=false
fi

# define the oradba url and package name
export GITHUB_URL="https://raw.githubusercontent.com/oehrlis/oradba_init/master"

# OraDBA init, setup an configuration scripts
export SETUP_INIT="00_setup_oradba_init.sh"             # main init script
export SETUP_OS="01_setup_os_db.sh"                     # script to configure the OS for a DB server
export CONFIG_DISK="02_setup_oracle_volume.sh"          # script to configure additional volumes
export SETUP_DB="10_setup_db.sh"                        # script to install the DB binaries
export SETUP_JAVA="01_setup_os_java.sh"                 # script to install java
export SETUP_OUD="10_setup_oud.sh"                      # script to install the OUD binaries
export SETUP_WLS="10_setup_wls.sh"                      # script to install the WLS binaries
export SETUP_OUDBASE="20_setup_oudbase.sh"              # script to install OUDBase environment
export SETUP_BASENV="20_setup_basenv.sh"                # TVD-BasEnv setup script
export CONFIG_ENV="config_env.sh"                       # script to configure environment
export SETUP_ENV="$(basename $SCRIPT_NAME .sh)_init.sh" # file name to store the environment variables

# enable tasks to run during bootstrap
export task_disk_config=true                            # configure additional volume
export task_os_setup=true                               # enable / disable os setup
export task_sw_download=false                           # enable / disable software download
export task_java_install=false                          # enable / disable java installation
export task_db_install=false                            # enable / disable DB software installation
export task_wls_install=false                           # enable / disable WLS software installation
export task_oud_install=false                           # enable / disable OUD software installation
export task_basenv_install=false                        # enable / disable basenv installation
export task_oudbase_install=false                       # enable / disable oudbase installation
export task_firewall_config=true                        # enable / disable firewall configuration
export task_lab_config=true                             # enable / disable Training configuration
# - EOF Default Values --------------------------------------------------------

# - Initialization ------------------------------------------------------------
# Define a bunch of bash option see 
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o nounset                              # stop script after 1st cmd failed
set -o errexit                              # exit when 1st unset variable found
set -o pipefail                             # pipefail exit after 1st piped commands failed

# initialize logfile
touch $LOGFILE 2>/dev/null
exec &> >(tee -a "$LOGFILE")                # Open standard out at `$LOG_FILE` for write.  
exec 2>&1                                   # forward standard err to `$LOG_FILE`  

echo "INFO: Start the bootstrap process on host $(hostname) at $(date)"

# source the release specific environment variables
if [ -f "$SCRIPT_BIN_DIR/set_config_env.sh" ]; then
    # add ORACLE_PASSWORD to the file
    echo "INFO: update a few variables in $SCRIPT_BIN_DIR/set_config_env.sh"
    if [ -n "$ORACLE_PWD" ]; then
        sed -i "s|\(.*ORACLE_PWD=\)\"\"|\1\"$ORACLE_PWD\"|" $SCRIPT_BIN_DIR/set_config_env.sh
    fi
    if [ -n "$ORACLE_ROOT" ]; then
        sed -i "s|\(.*ORACLE_ROOT=\)\"\"|\1\"$ORACLE_ROOT\"|" $SCRIPT_BIN_DIR/set_config_env.sh
    fi
    if [ -n "$ORACLE_DATA" ]; then
        sed -i "s|\(.*ORACLE_DATA=\)\"\"|\1\"$ORACLE_DATA\"|" $SCRIPT_BIN_DIR/set_config_env.sh
    fi
    if [ -n "$ORACLE_ARCH" ]; then
        sed -i "s|\(.*ORACLE_ARCH=\)\"\"|\1\"$ORACLE_ARCH\"|" $SCRIPT_BIN_DIR/set_config_env.sh
    fi
    if [ -n "$ORACLE_BASE" ]; then
        sed -i "s|\(.*ORACLE_BASE=\)\"\"|\1\"$ORACLE_BASE\"|" $SCRIPT_BIN_DIR/set_config_env.sh
    fi
    echo "INFO: source DB env from $SCRIPT_BIN_DIR/set_config_env.sh"
    . $SCRIPT_BIN_DIR/set_config_env.sh
else
    echo "WARN: could not source db env $SCRIPT_BIN_DIR/set_config_env.sh"
fi

if [ "$system_initilized" = true ] ; then
    echo "INFO: System already initialized. Fallback to minimal initialisation."
    task_disk_config=true       # configure additional volume
    task_os_setup=false         # enable / disable os setup
    task_sw_download=false      # enable / disable software download
    task_java_install=false     # enable / disable java installation
    task_db_install=false       # enable / disable DB software installation
    task_wls_install=false      # enable / disable WLS software installation
    task_oud_install=false      # enable / disable OUD software installation
    task_basenv_install=false   # enable / disable basenv installation
    task_oudbase_install=false  # enable / disable oudbase installation
    task_firewall_config=true   # enable / disable firewall configuration
    task_lab_config=true        # enable / disable Training configuration
else
    echo "INFO: Regular initialisation."
fi

# copy default bash files from skel
[ -f /etc/skel/.bashrc ]        && cp --verbose --update /etc/skel/.bashrc /home/$ORACLE_USER
[ -f /etc/skel/.bash_profile ]  && cp --verbose --update /etc/skel/.bash_profile /home/$ORACLE_USER
[ -f /etc/skel/.bash_logout ]   && cp --verbose --update /etc/skel/.bash_logout /home/$ORACLE_USER

# update user password
echo "INFO: reset password for $ORACLE_USER to default value"
sed -i 's/^ocredit.*/ocredit = 0/g' /etc/security/pwquality.conf
echo $ORACLE_PWD |passwd --stdin $ORACLE_USER || echo "WARN: unable to reset password for $ORACLE_USER"

# adjust permissions
chown -vR $ORACLE_USER:$ORACLE_USER /home/$ORACLE_USER 

echo "### Generic host configuration ###########################################"

# disable dev repo
if [ $(grep -ic "7." /etc/redhat-release) -eq 1 ]; then 
    yum repolist
    echo "INFO: Disable some repo in OEL 7 -------------------------------------"
    yum-config-manager --disable oci-included-ol7   || echo "WARN: cannot disable the repo oci-included-ol7"
    yum-config-manager --disable ol7_oci_included   || echo "WARN: cannot disable the repo ol7_oci_included"
    yum-config-manager --disable ol7_ksplice        || echo "WARN: cannot disable the repo ol7_ksplice"
    yum-config-manager --disable ol7_addons         || echo "WARN: cannot disable the repo ol7_addons"
    yum-config-manager --disable ol7_MySQL80        || echo "WARN: cannot disable the repo ol7_MySQL80"
    yum-config-manager --disable ol7_MySQL80_connectors_community   || echo "WARN: cannot disable the repo ol7_MySQL80_connectors_community"
    yum-config-manager --disable ol7_MySQL80_tools_community        || echo "WARN: cannot disable the repo ol7_MySQL80_tools_community"

    yum install -y xauth  || echo "WARN: cannot install xauth"
    yum install -y xclock || echo "WARN: cannot install xclock"
elif [ $(grep -ic "8\." /etc/redhat-release) -eq 1 ]; then 
    dnf config-manager --enable ol8_codeready_builder || echo "WARN: cannot enable the repo ol8_codeready_builder"
    dnf install -y xorg-x11-apps || echo "cannot install xorg-x11-apps packages"
fi

# config SSH for X11 forwarding
sed -i 's/.*X11Forwarding.*/X11Forwarding yes/g'    /etc/ssh/sshd_config
sed -i 's/.*X11UseLocalhost.*/X11UseLocalhost no/g' /etc/ssh/sshd_config

# accenture ssh config
cat << EOF >/etc/ssh/Banner

This system is the property of Accenture, and is to be used in accordance with
applicable Accenture Policies.Unauthorized access or activity is a violation of
Accenture Policies and may be a violation of law. Use of this system constitutes
consent to monitoring or unauthorized use, in accordance with Accenture Policies,
local laws, and regulations. Unauthorized use may result in penalties including,
but not limited to, reprimand, dismissal, financial penalties, and legal action

EOF
sed -i 's/.*MaxAuthTries.*/MaxAuthTries 5/g' /etc/ssh/sshd_config
sed -i 's/.*HostBasedAuthentication.*/HostBasedAuthentication no/gi' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's|.*Banner.*|Banner /etc/ssh/Banner|g' /etc/ssh/sshd_config
systemctl reload sshd

echo "INFO: Set timezone -------------------------------------------------------"
timedatectl set-timezone Europe/Zurich
timedatectl

echo "INFO: Update hosts file --------------------------------------------------"
if [ $(grep -ic $(hostname) /etc/hosts) -eq 0 ]; then 
    echo $(hostname -i) $(hostname -f) $(hostname -a) >> /etc/hosts
    chattr +i /etc/hosts        # set hosts file immutable
else
    chattr +i /etc/hosts        # set hosts file immutable
fi
lsattr /etc/hosts

echo "INFO: define OCI network config ------------------------------------------"
# set PRESERVE_HOSTINFO information to 2
sed -i 's/PRESERVE_HOSTINFO.*/PRESERVE_HOSTINFO=2/' /etc/oci-hostname.conf

# configure a system wide login banner
echo "### Configure login banner ##############################################"
cp -v /etc/motd /etc/motd.orig
cat << EOF >/etc/motd
-------------------------------------------------------------------------------
-
- Welcome to the OCI based lab environment for $LAB_NAME
- hostname          :   $HOSTNAME.$DOMAINNAME
- Public IP         :   $(dig +short myip.opendns.com @resolver1.opendns.com)
- Private IP        :   $PRIVATE_IP

EOF

# Setup the OraDBA initialisation scripts
echo "### Prepare OraDBA Init Setup ##########################################"
mkdir -p $DOWNLOAD                          # prepare a download directory

# get the latest install script for OraDBA init from GitHub repository
curl -Lsf $GITHUB_URL/bin/$SETUP_INIT -o $DOWNLOAD/$SETUP_INIT

chmod 755 $DOWNLOAD/$SETUP_INIT
$DOWNLOAD/$SETUP_INIT                       # install the OraDBA init scripts
rm -rf $OPT_DIR/oradba/oradba_init-master   # remove the old master folder

# Define save current environment variable for later use
export -p |grep -v "root" >/tmp/$SETUP_ENV
chmod 755 /tmp/$SETUP_ENV

# start to setup OS
if [ "$task_os_setup" = true ]; then
    echo "### Setup OS ###########################################################"
    $ORADBA_BIN/$SETUP_OS                   # setup OS
    touch /home/$ORACLE_USER/.bash_profile  # prepare profile
    chown -vR $ORACLE_USER:$ORACLE_USER /home/$ORACLE_USER # adjust user home folder
    yum install -y git                      # install GIT
else
    echo "### Skip setup OS ######################################################"
fi

# start to volume group
if
    [ "$task_disk_config" = true ]
then
    echo "### Disk Config #########################################################"
    if [ -f "$ORADBA_BIN/$CONFIG_DISK" ]; then
        $ORADBA_BIN/$CONFIG_DISK                # configure a volume group and lvs for oracle
        
        for i in $ORACLE_ROOT $ORACLE_DATA $ORACLE_ARCH; do
            if [ -d "$i" ]; then
                chown -v $ORACLE_USER:$ORACLE_USER $i
            fi
        done
    else
        echo "WARN: Could not find $ORADBA_BIN/$CONFIG_DISK"
    fi
else
    echo "### Skip disk config ####################################################"
fi

# start firewall configuration
if 
    [ "$task_firewall_config" = true ]
then
    # Configure firewall deamon
    echo "### Configure firewalld ################################################"
    yum install firewalld -y                # install the firewall configuration
    if [ -n "$PORT_LIST" ]; then            # check if ports is defined
        for port in $PORT_LIST; do          # loop through list of ports
            firewall-offline-cmd --add-port=$port/tcp # enabled dedicated port
        done
    fi
    firewall-offline-cmd --add-service=ssh  # add ssh service to firewall
    firewall-offline-cmd --list-all         # list all defined rules
    systemctl enable firewalld              # enable firewall deamon
    systemctl restart firewalld             # restart firewall deamon
    systemctl status firewalld              # check current status
else
    echo "### Skip firewalld configuration #######################################"
fi

# Start software download if repo is defined
pids=""
if
    [ "$task_sw_download" = true ] &&
    [ -n "$SOFTWARE_REPO" ]
then
    echo "### Download software ##################################################"
    mkdir -vp $SOFTWARE                     # Create download folder

    # Define option for curle e.g. credentials
    if [ -n "$SOFTWARE_USER" ] && [ -n $SOFTWARE_PASSWORD ]; then 
        echo "INFO: set curl credentials to -u $SOFTWARE_USER:xxx"
        curl_opt="-u $SOFTWARE_USER:$SOFTWARE_PASSWORD"
        # check if the URL is a swift 
        if [[ $SOFTWARE_REPO == *"swiftobjectstorage"* ]]; then
            echo "INFO: set curl options to -X GET -u $SOFTWARE_USER:xxx"
            curl_opt="-X GET -u $SOFTWARE_USER:$SOFTWARE_PASSWORD"
        else
            echo "INFO: set curl options to -u $SOFTWARE_USER:xxx"
            curl_opt="-u $SOFTWARE_USER:$SOFTWARE_PASSWORD"
        fi
    else
        echo "INFO: Using plain curl without credentials"
        curl_opt=""                            
    fi
    if [ -n "$SOFTWARE_LIST" ]; then        # check if list of software is defined
        for file in $(echo $SOFTWARE_LIST | sed "s/;/ /g"); do
            echo "INFO: get $file from $SOFTWARE_REPO"
            # get software from software repository via OCI swift API
            curl  $curl_opt -Lsf $SOFTWARE_REPO/$file -o $SOFTWARE/$file & # download the software
            pids+="$! "
        done
        echo "INFO: wait for downloads to finish"
        for pid in $pids; do                # loop through pid
            wait $pid                       # wait until the curl jobs are finished
            if [ $? -eq 0 ]; then
                echo "INFO: Job $pid successfully exited with status $?"
            else
                echo "WARN: Job $pid failed and exited with status $?"
            fi
        done
    else
        echo "INFO: no software package specified"
    fi
else
    echo "### Skip software download ##############################################"
fi

# Start java software installation
if 
    [ "$task_java_install"  = true ] &&
    [ "$task_sw_download"   = true ] &&
    [ -n "$SOFTWARE_REPO" ]
then
    echo "### Install Java #######################################################"
    su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; $ORADBA_BIN/$SETUP_JAVA"
else
    echo "### Skip Java installation #############################################"
fi

# Start OUDBase installation
if 
    [ "$task_oudbase_install"   = true ] &&
    [ "$task_java_install"      = true ] &&
    [ -n "$SOFTWARE_REPO" ]
then
    echo "### Install OUDBase ####################################################"
    su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; $ORADBA_BIN/$SETUP_OUDBASE"

    echo "### Configure Start Scripts ############################################"
    cp -v $ORACLE_BASE/$BE_DIR_NAME/oudbase/templates/etc/oracle_oud_all /etc/init.d
    chkconfig --add oracle_oud_all
    chkconfig --list

    echo "### Config $ORACLE_USER crontab ##############################################"
    su -l $ORACLE_USER -c "cp $ORACLE_BASE/$BE_DIR_NAME/oudbase/templates/etc/oud.crontab $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "sed -i \"s|OUD_BASE|$ORACLE_BASE/$BE_DIR_NAME/oudbase|g\" $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "sed -i \"s|MAILADDRESS|$EMAIL|g\" $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "sed -i '/^#.*oud_backup.sh/s/^#//' $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "sed -i '/^#.*oud_export.sh/s/^#//' $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "crontab $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"

    echo "### Config $ORACLE_USER housekeeping #########################################"
    su -l $ORACLE_USER -c "crontab -l >$ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "sed -i '/^#.*housekeeping.conf/s/^#//' $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
    su -l $ORACLE_USER -c "crontab $ORACLE_BASE/$BE_DIR_NAME/oudbase/etc/oud.crontab"
else
    echo "### Skip OUDBase installation ##########################################"
fi

# Start software installation
if
    [ "$task_sw_download"   = true ] &&
    [ -n "$SOFTWARE_REPO" ]
then
    echo "### Install binaries ###################################################"
    if [ "$task_db_install" = true ]; then
        echo "### Install DB binaries ################################################"
        export CV_ASSUME_DISTID=OEL7.8
        if [ -f "$ORADBA_BIN/$SETUP_DB" ]; then
            su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; $ORADBA_BIN/$SETUP_DB"
            echo "### Relink Unified Audit ###############################################"
            su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; cd \$ORACLE_HOME/rdbms/lib; make -f ins_rdbms.mk uniaud_on ioracle"

            # run the Oracle root scripts
            $ORACLE_ROOT/app/oraInventory/orainstRoot.sh
            $ORACLE_BASE/product/$ORACLE_HOME_NAME/root.sh
        else
            echo "WARN: Could not find $ORADBA_BIN/$SETUP_DB"
        fi
    else
        echo "### Skip DB binary installation ########################################"
    fi
    if [ "$task_wls_install" = true ]; then
        echo "### Install WLS binaries ###############################################"
        if [ -f "$ORADBA_BIN/$SETUP_WLS" ]; then
            if [ -n "$WLS_HOME_NAME" ]; then
                echo "INFO: Install WLS into $WLS_HOME_NAME"
                su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; ORACLE_HOME=$ORACLE_BASE/product/$WLS_HOME_NAME \
                $ORADBA_BIN/$SETUP_WLS"
            fi
        else
            echo "WARN: Could not find $ORADBA_BIN/$SETUP_WLS"
        fi
            echo "### Install WLS binaries ###############################################"
    else
        echo "### Skip WLS binary installation #######################################"
    fi
    if [ "$task_oud_install" = true ]; then
        echo "### Install OUD binaries ###############################################"
        if [ -f "$ORADBA_BIN/$SETUP_OUD" ]; then
            if [ -n "$OUD_HOME_NAME" ]; then
                echo "INFO: Install OUD into $OUD_HOME_NAME"
                su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; ORACLE_HOME=$ORACLE_BASE/product/$OUD_HOME_NAME \
                OUD_TYPE=OUD12 \
                $ORADBA_BIN/$SETUP_OUD"
            fi
        
            if [ -n "$OUDSM_HOME_NAME" ]; then
                echo "INFO: Install OUDSM into $OUDSM_HOME_NAME"
                su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; ORACLE_HOME=$ORACLE_BASE/product/$OUDSM_HOME_NAME \
                OUD_TYPE=OUDSM12 \
                $ORADBA_BIN/$SETUP_OUD"
            fi
        else
            echo "WARN: Could not find $ORADBA_BIN/$SETUP_OUD"
        fi
    else
        echo "### Skip OUD binary installation #######################################"
    fi
else
    echo "### Skip binary installation ###########################################"
fi

# Start BasEnv installation enabled and software available
if
    [ "$task_basenv_install" = true ] && 
    [ "$task_sw_download"    = true ] && 
    [ -n "$SOFTWARE_REPO" ]
then
    echo "### Install BasEnv #####################################################"
    if [ -f "$ORADBA_BIN/$SETUP_BASENV" ]; then
        # create a softlink for oratab
        mkdir -p $ORACLE_BASE/$BE_DIR_NAME/dba 
        touch $ORACLE_BASE/$BE_DIR_NAME/dba/oratab
        ln -sfv $ORACLE_BASE/$BE_DIR_NAME/dba/oratab /etc/oratab
        chown -Rv $ORACLE_USER:$ORACLE_USER $ORACLE_BASE/$BE_DIR_NAME
        su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; $ORADBA_BIN/$SETUP_BASENV"
        if [ -n "$BE_ALIAS" ]; then
            echo "$BE_ALIAS:$ORACLE_HOME:D" >$ORACLE_BASE/$BE_DIR_NAME/dba/oratab
        fi
    else
        echo "WARN: Could not find $ORADBA_BIN/$SETUP_BASENV"
    fi
else
    echo "### Skip BasEnv installation ###########################################"
fi

# add oradata folders to all u0? mountpoints / folder
for i in $ORACLE_ROOT $ORACLE_DATA $ORACLE_ARCH; do
    if [ -d "$i" ]; then
        mkdir -pv $i/oradata
        chown -vR $ORACLE_USER:$ORACLE_USER $i/oradata
    fi
done

# add fast_recovery_area folder to all ora? mountpoints / folder
mkdir -vp $ORACLE_ARCH/fast_recovery_area
chown -R $ORACLE_USER:$ORACLE_USER $ORACLE_ARCH/fast_recovery_area
mkdir -vp $ORACLE_DATA/fast_recovery_area
chown -R $ORACLE_USER:$ORACLE_USER $ORACLE_DATA/fast_recovery_area

# Start task config the lab
if [ "$task_lab_config" = true ]; then
    CONFIG_BASE=$SCRIPT_BIN_DIR
    echo "### Config LAB environment ########################################"
    if [ -n "$LAB_REPO" ] && [ -n "$LAB_BASE" ]; then
        CONFIG_BASE=$LAB_BASE
        echo "INFO: Download and deploy LAB configuration"
        mkdir -vp $(dirname $LAB_BASE)
        chown -vR $ORACLE_USER:$ORACLE_USER $(dirname $LAB_BASE)
        curl -Lf $LAB_REPO -o "$ORACLE_BASE/$BE_DIR_NAME/$LAB_NAME.zip"
        # check if we have a lab ZIP
        if [ -f "$ORACLE_BASE/$BE_DIR_NAME/$LAB_NAME.zip" ]; then
            echo "INFO: Deploy LAB environment"
            rm -rf $LAB_BASE
            unzip "$ORACLE_BASE/$BE_DIR_NAME/$LAB_NAME.zip" -d $LAB_BASE
            rm -rf $LAB_BASE/oci
            rm -rf $LAB_BASE/etc
            rm -rf $LAB_BASE/.build
            chown -vR $ORACLE_USER:$ORACLE_USER $LAB_BASE
            rm -rf $ORACLE_BASE/$BE_DIR_NAME/$LAB_NAME.zip
        else
            echo "WARN: could not deploy LAB environment"
        fi
    else
        echo "INFO: Skip deploy LAB configuration"
    fi

    # copy a predefined bash profile
    if [ -f "$CONFIG_BASE/bash_profile" ]; then 
        echo "INFO: Copy bash profile from $CONFIG_BASE/bash_profile"
        if [ -f "/home/$ORACLE_USER/.bash_profile" ]; then
            cp -v $CONFIG_BASE/bash_profile /home/$ORACLE_USER/.bash_profile.orig
        fi
        cp -v $CONFIG_BASE/bash_profile /home/$ORACLE_USER/.bash_profile
        chown -vR $ORACLE_USER:$ORACLE_USER /home/$ORACLE_USER/.bash_profile
    else
        echo "INFO: Skip copy bash profile ($CONFIG_BASE/bash_profile)"
    fi
    
    # change permissions of bash scripts
    echo "INFO: Adjust permision of files uploaded with provisioner"
    find $SCRIPT_BIN_DIR  -name '*.sh' -type f -exec chmod -v 755 {} \;

    if [ "$system_initilized" = false ] ; then
        # start post config
        if [ -f "$SCRIPT_BIN_DIR/$CONFIG_ENV" ]; then
            echo "INFO: initiate lab configuration in background $SCRIPT_BIN_DIR/$CONFIG_ENV"
            su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; nohup $SCRIPT_BIN_DIR/$CONFIG_ENV > $SCRIPT_BIN_DIR/$(basename $CONFIG_ENV .sh).log 2>&1 &"
        fi
    elif [ "$system_initilized" = true ] ; then
        # start post config for initialized system
        if [ -f "$SCRIPT_BIN_DIR/$POST_CONFIG_ENV" ]; then
            echo "INFO: initiate lab post configuration in background $SCRIPT_BIN_DIR/$POST_CONFIG_ENV"
            su -l $ORACLE_USER -c ". /tmp/$SETUP_ENV; nohup $SCRIPT_BIN_DIR/$POST_CONFIG_ENV > $SCRIPT_BIN_DIR/$(basename $POST_CONFIG_ENV .sh).log 2>&1 &"
        fi
    fi

    # Update basenv.conf and add the lab

    if [ "$task_basenv_install" = true ] ; then
        if [ -f $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf ]; then
            echo "INFO: update basenv.conf with lab information"
            echo "LAB_BASE=$LAB_BASE"                 >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf
            echo "alias lab='cd \"\$LAB_BASE/lab\"'"  >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf
            for i in $LAB_BASE/lab/*; do
                if [ -d $i ]; then
                    lab_dir=$(basename $i)
                    echo "alias $lab_dir='cd \"\$LAB_BASE/lab/$lab_dir\"'" >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf
                fi
            done
            echo "alias demo='cd \"\$LAB_BASE/demo\"'" >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf
            for i in $LAB_BASE/demo/*; do
                if [ -d $i ]; then
                demo_dir=$(basename $i)
                echo "alias $demo_dir='cd \"\$LAB_BASE/demo/$demo_dir\"'" >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/basenv.conf
                fi
            done
        else
            echo "INFO: skip basenv.conf for lab environment"
        fi
        echo "PATH + . A" >> $ORACLE_BASE/$BE_DIR_NAME/dba/etc/sid._DEFAULT_.conf
    else
        echo "INFO: update bash_profile with lab information"
        echo "export LAB_BASE=$LAB_BASE"                 >> /home/$ORACLE_USER/.bash_profile
        echo "alias lab='cd \"\$LAB_BASE/lab\"'"  >> /home/$ORACLE_USER/.bash_profile
        for i in $LAB_BASE/lab/*; do
            if [ -d $i ]; then
                lab_dir=$(basename $i)
                echo "alias $lab_dir='cd \"\$LAB_BASE/lab/$lab_dir\"'" >> /home/$ORACLE_USER/.bash_profile
            fi
        done
        echo "alias demo='cd \"\$LAB_BASE/demo\"'" >> /home/$ORACLE_USER/.bash_profile
        for i in $ORACLE_BASE/local/obr/demo/demo??; do
            if [ -d $i ]; then
                demo_dir=$(basename $i)
                echo "alias $demo_dir='cd \"\$LAB_BASE/demo/$demo_dir\"'" >> /home/$ORACLE_USER/.bash_profile
            fi
        done   
        echo "export PATH=\$PATH:\$LAB_BASE:$LAB_BASE/bin:." >> /home/$ORACLE_USER/.bash_profile
    fi
else
    echo "### Skip config LAB_NAME environment ###################################"
fi

# adjust permissions
chown -R $ORACLE_USER:$ORACLE_USER /home/$ORACLE_USER 
echo "INFO: Finish the bootstrap process on host $(hostname) at $(date)"
# --- EOF ---------------------------------------------------------------------