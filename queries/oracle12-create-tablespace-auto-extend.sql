-- =============================================================================
-- Part A: Permanent tablespaces
-- =============================================================================
--
--------------------------------------------------------------------------------
-- TBS_MES_PART_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_PART_01
  DATAFILE '/u01/app/oracle/oradata/mes/part01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_PART_02
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_PART_02
  DATAFILE '/u01/app/oracle/oradata/mes/part02.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_SPOT_PART_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_SPOT_PART_01
  DATAFILE '/u01/app/oracle/oradata/spot/part01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_BLOB_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_BLOB_01
  DATAFILE '/u01/app/oracle/oradata/mes/blob01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_LOG_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_LOG_01
  DATAFILE '/u01/app/oracle/oradata/mes/log01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_LOG_02
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_LOG_02
  DATAFILE '/u01/app/oracle/oradata/mes/log02.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_MSG_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_MSG_01
  DATAFILE '/u01/app/oracle/oradata/mes/msg01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

--------------------------------------------------------------------------------
-- TBS_MES_REPT_01
--------------------------------------------------------------------------------
CREATE TABLESPACE TBS_MES_REPT_01
  DATAFILE '/u01/app/oracle/oradata/mes/rept01.dbf'
  SIZE 1024M AUTOEXTEND ON
  ONLINE
  LOGGING
  PERMANENT
  FLASHBACK ON
  BLOCKSIZE 8K
  SEGMENT SPACE MANAGEMENT AUTO
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

-- =============================================================================
-- Part B: Temporary tablespaces
-- =============================================================================
--
--------------------------------------------------------------------------------
-- TBS_MES_TEMP_01
--------------------------------------------------------------------------------
CREATE TEMPORARY TABLESPACE TBS_MES_TEMP_01
  TEMPFILE '/u01/app/oracle/oradata/mes/temp01.dbf'
  SIZE 1024M AUTOEXTEND ON
  TABLESPACE GROUP ''
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

--------------------------------------------------------------------------------
-- TBS_SPOT_TEMP_01
--------------------------------------------------------------------------------
CREATE TEMPORARY TABLESPACE TBS_SPOT_TEMP_01
  TEMPFILE '/u01/app/oracle/oradata/spot/temp01.dbf'
  SIZE 1024M AUTOEXTEND ON
  TABLESPACE GROUP ''
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;
