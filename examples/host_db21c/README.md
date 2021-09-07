# Database 21c configuration

This directory contains terraform configuration and cloud-init user data files
to setup and bootstrap the a Database 21c environment. The `*.tf` files and the
`cloudinit` folder in this folder must be placed in the corresponding location
of you terraform configuration.

- [host_db21c.tf](host_db21c.tf) Terraform configuration to call the module
  `tvdlab-host` as basis to setup the Database 21c environment
- [host_db21c.auto.tfvars](host_db21c.auto.tfvars) Terraform variable file to
  configure the Database 21c terraform configuration.
- [cloudinit](cloudinit) folder with the configuration files.

## Prerequisites

To use the module, a few requirements must be met:

- Define the mandatory parameter for
  - *region* the OCI region where resources will be created
  - *compartment_ocid* OCID of the compartment where to create all resources
  - *tenancy_ocid* tenancy id where to create the resources
  - *host_subnet* List of subnets for the host hosts
  - *tvd_def_password* Default password for windows administrator, oracle, directory and more
  - *lab_source_url* preauthenticated URL to the LAB source ZIP file.
  - *ssh_authorized_keys* SSH authorized keys to access the resource.
  - *ssh_private_key* SSH private key used to access the internal hosts for file upload.
- provide a URL for software download to make sure Oracle binaries will be
  downloaded
  - *software_repo* software repository URL to OCI object store swift API
  - *software_user* default OCI user to access the software repository
  - *software_password* default OCI password to access the software repository

## Using the Module for Database 21c

To use the module on a Database 21c server, the following procedure should be
followed.

- Create a corresponding folder for the Database 21c configuration in the root
  of the terraform project

```bash
mkdir $TERRAFORM_ROOT/host_db21c
```

- Copy the configuration files to the new folder

```bash
cp -r cloudinit $TERRAFORM_ROOT/host_db21c
```

- Copy the terraform configuration files to the root of the terraform project

```bash
cp host_db21c.tf $TERRAFORM_ROOT
cp host_db21c.auto.tfvars $TERRAFORM_ROOT
```

- Adjust the `host_db21c.auto.tfvars` file to match the environment
- Adjust the `set_env_db21c_config.sh` file e.g. software packages and other
  environment variables.

## Create new Master DB

For deploying DBs using RMAN clones requires to create corresponding DBs with
RMAN backups.

- prepare the response files

```bash
cp /opt/oradba/rsp/dbca21.0.0.rsp.tmpl /home/oracle
cp /opt/oradba/rsp/dbca21.0.0.dbc.tmpl /home/oracle
cp /opt/oradba/rsp/custom_dbca21.0.0.dbc.tmpl /home/oracle/
```

### Regular Master Image

- Create a DB with the default response file. Adjust the mount points if necessary.

```bash
ORACLE_SID="TCDB210" \
DEFAULT_DOMAIN="trivadislabs.com" \
ORACLE_ROOT="/u01" \
ORACLE_DATA="/u02" \
ORACLE_ARCH="/u04" \
ORACLE_PWD="LAB01-Schulung" \
CONTAINER=TRUE \
CUSTOM_RSP="/home/oracle" \
ORADBA_DBC_FILE="dbca21.0.0.dbc.tmpl" \
ORADBA_RSP_FILE="dbca21.0.0.rsp.tmpl" \
/opt/oradba/bin/52_create_database.sh
```

- Create a RMAN backup

```bash
. /u01/app/oracle/local/dba/bin/oraenv.ksh TCDB210
mkdir $cda/log $cda/backup
rm -rf $cda/backup/*
rman_exec.ksh -t TCDB210 -s bck_inc0
```

- Create Pfile and Controlfile backup

```SQL
CREATE PFILE='/u01/app/oracle/admin/TCDB210/backup/init_TCDB210.ora' FROM SPFILE;
ALTER DATABASE BACKUP CONTROLFILE TO '/u01/app/oracle/admin/TCDB210/backup/controlfile_TCDB210.dbf';
```

- Pack the RMAN backup

```bash
cd $cda
mv $cda/backup $cda/TCDB210
tar zcvf master_TCDB210.tgz TCDB210
```

### Small Master Image

- Create a DB with the custom response file. Adjust the mount points if necessary.

```bash
ORACLE_SID="TCDB210" \
DEFAULT_DOMAIN="trivadislabs.com" \
ORACLE_ROOT="/u01" \
ORACLE_DATA="/u02" \
ORACLE_ARCH="/u04" \
ORACLE_PWD="LAB01-Schulung" \
CONTAINER=TRUE \
CUSTOM_RSP="/home/oracle" \
ORADBA_DBC_FILE="custom_dbca21.0.0.dbc.tmpl" \
ORADBA_RSP_FILE="dbca21.0.0.rsp.tmpl" \
/opt/oradba/bin/52_create_database.sh
```

- Create a RMAN backup

```bash
. /u01/app/oracle/local/dba/bin/oraenv.ksh TCDB210
mkdir $cda/log $cda/backup
rm -rf $cda/backup/*
rman_exec.ksh -t TCDB210 -s bck_inc0
```

- Create Pfile and Controlfile backup

```SQL
CREATE PFILE='/u01/app/oracle/admin/TCDB210/backup/init_TCDB210.ora' FROM SPFILE;
ALTER DATABASE BACKUP CONTROLFILE TO '/u01/app/oracle/admin/TCDB210/backup/controlfile_TCDB210.dbf';
```

- Pack the RMAN backup

```bash
cd $cda
mv $cda/backup $cda/TCDB210
tar zcvf master_TCDB210_small.tgz TCDB210
```

### Upload Images to OCI Bucket

Upload the images respectively master TAR files to the OCI Bucket.
  
```bash
cd $cda
SOFTWARE_USER="quordlepleen"
SOFTWARE_PASSWORD="i2T2Tq[])w>5IttMaQwn"
SOFTWARE_BUCKET="orarepo"
SOFTWARE_REPO="https://swiftobjectstorage.eu-zurich-1.oraclecloud.com/v1/trivadisbdsxsp/$SOFTWARE_BUCKET"

for i in master_*.tgz; do
  curl -X PUT  \
  -u "$SOFTWARE_USER:$SOFTWARE_PASSWORD"  \
  --upload-file $i \
  $SOFTWARE_REPO/$i
done
```
