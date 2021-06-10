# TDB00 Setup Files

This folder contains all files executed after the single tenant database
instance is initially created. Currently only bash scripts (.sh) SQL files
(.sql) are supported.

- [00_config_db.sql](00_config_db.sql) Configure database parameter.
- [01_run_datapatch.sh](01_run_datapatch.sh) Run datapatch for regular DB, CDB
  and JVM.
- [03_create_scott.sql](03_create_scott.sql) Script to create the SCOTT schema.
- [04_create_tvd_hr.sql](04_create_tvd_hr.sql) Script to create the TVD_HR
  schema.
- [06_config_audit.sql](06_config_audit.sql) Initialize Audit trails
