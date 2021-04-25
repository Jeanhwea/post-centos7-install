-- =============================================================================
-- Part A: Create user bamtri_mes
-- =============================================================================
--
CREATE USER bamtri_mes
  IDENTIFIED BY bamtri_mes
  DEFAULT TABLESPACE TBS_MES_PART_01
  TEMPORARY TABLESPACE TBS_MES_TEMP_01
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

-- =============================================================================
-- Part B: Grant roles and privileges to bamtri_mes
-- =============================================================================
--
GRANT CONNECT, RESOURCE, DBA TO bamtri_mes;
ALTER USER bamtri_mes DEFAULT ROLE ALL;
