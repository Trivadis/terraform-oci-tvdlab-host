#!/bin/bash
# -----------------------------------------------------------------------
# Trivadis AG, Business Development & Support (BDS)
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------
# Name.......: 05_config_eus_realm.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.06.30
# Revision...: --
# Purpose....: Script to configure EUS realm to the OUD proxy instance.
# Notes......: BaseDN in 05_config_eus_realm.ldif will be updated before
#              it is loaded using ldapmodify.
# Reference..: https://github.com/oehrlis/oudbase
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at https://oss.oracle.com/licenses/upl.
# -----------------------------------------------------------------------
# Modified...:
# see git revision history with git log for more information on changes
# -----------------------------------------------------------------------

# - load instance environment -------------------------------------------
. "$(dirname $0)/00_init_environment"
LDIFFILE="$(dirname $0)/$(basename $0 .sh).ldif"      # LDIF file based on script name
LDIFFILE_CUSTOM="$(dirname $0)/$(basename $0 .sh).ldif_${BASEDN_STRING}"
# - configure instance --------------------------------------------------
echo "Configure OUD instance ${OUD_INSTANCE} using:"
echo "  BASEDN            : ${BASEDN}"
echo "  BASEDN_STRING     : ${BASEDN_STRING}"
echo "  GROUP_OU          : ${GROUP_OU}"
echo "  USER_OU           : ${USER_OU}"
echo "  LDIFFILE          : ${LDIFFILE}"
echo "  LDIFFILE_CUSTOM   : ${LDIFFILE_CUSTOM}"
echo ""

# - configure instance --------------------------------------------------
# Update baseDN in LDIF file if required
if [ -f ${LDIFFILE} ]; then
  cp -v ${LDIFFILE} ${LDIFFILE_CUSTOM}
else
  echo "- skip $(basename $0), missing ${LDIFFILE}"
  exit
fi

echo "- Update LDIF file to match ${BASEDN} and other variables"
sed -i "s/BASEDN/${BASEDN}/g" ${LDIFFILE_CUSTOM}
sed -i "s/USER_OU/${USER_OU}/g" ${LDIFFILE_CUSTOM}
sed -i "s/GROUP_OU/${GROUP_OU}/g" ${LDIFFILE_CUSTOM}

echo "- Update EUS Realm configuration"
${OUD_INSTANCE_HOME}/OUD/bin/ldapmodify \
  --hostname ${HOST} \
  --port ${PORT} \
  --bindDN "${DIRMAN}" \
  --bindPasswordFile "${PWD_FILE}" \
  --defaultAdd \
  --filename "${LDIFFILE_CUSTOM}"
# - EOF -----------------------------------------------------------------
