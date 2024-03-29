----------------------------------------------------------------------------
--  Trivadis AG, Infrastructure Managed Services
--  Saegereistrasse 29, 8152 Glattbrugg, Switzerland
----------------------------------------------------------------------------
--  Name......: 07_clone_pdb1_pdb2.sql
--  Author....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
--  Editor....: Stefan Oehrli
--  Date......: 2021.01.11
--  Revision..:  
--  Purpose...: Script to clone PDB1 to PDB2
--  Notes.....:  
--  Reference.: SYS (or grant manually to a DBA)
--  License...: Apache License Version 2.0, January 2004 as shown
--              at http://www.apache.org/licenses/
----------------------------------------------------------------------------
--  Modified..:
--  see git revision history for more information on changes/updates
----------------------------------------------------------------------------
-- set the current
--ALTER PLUGGABLE DATABASE pdb1 CLOSE;
COLUMN pdb_path NEW_VALUE pdb_path NOPRINT
SELECT substr(file_name, 1, instr(file_name, '/', -1, 1)-1) pdb_path FROM dba_data_files WHERE file_id=1;
CREATE PLUGGABLE DATABASE pdb2 FROM pdb1
  FILE_NAME_CONVERT=('&pdb_path/PDB1/','&pdb_path/PDB2/');

--ALTER PLUGGABLE DATABASE pdb1 OPEN READ WRITE;
ALTER PLUGGABLE DATABASE pdb2 OPEN READ WRITE;

--ALTER PLUGGABLE DATABASE pdb1 SAVE STATE;
ALTER PLUGGABLE DATABASE pdb2 SAVE STATE;
-- EOF ---------------------------------------------------------------------