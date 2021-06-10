# TCDB00 Setup Files

This folder contains all files executed after the single tenant database
instance is initially created. Currently only bash scripts (.sh) SQL files
(.sql) are supported.

- [00_config_db.sql](00_config_db.sql) Configure database parameter.
- [01_run_datapatch.sh](00_run_datapatch.sh) Run datapatch for regular DB, CDB
  and JVM.
- [03_create_scott_pdb1.sql](02_create_scott_pdb1.sql) Script to create the
  *SCOTT* schema in *PDB1*
- [04_create_tvd_hr_pdb1.sql](03_create_tvd_hr_pdb1.sql) Script to create the
  *TVD_HR* schema in *PDB1*
- [05_config_audit_cdb.sql](05_config_audit_cdb.sql) Initialize Audit trails
  in *CDB*
- [05_config_audit_pdb1.sql](05_config_audit_pdb1.sql) Initialize Audit trails
  in *PDB1*
- [07_clone_pdb1_pdb2.sql](07_clone_pdb1_pdb2.sql) Script to clone PDB1 to PDB2
