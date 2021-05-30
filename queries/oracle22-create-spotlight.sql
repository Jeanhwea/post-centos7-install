-- =============================================================================
-- Part A: Create user spotlight
-- =============================================================================
--
CREATE USER spotlight
  IDENTIFIED BY spotlight
  DEFAULT TABLESPACE TBS_SPOT_PART_01
  TEMPORARY TABLESPACE TBS_SPOT_TEMP_01
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

-- =============================================================================
-- Part B: Grant roles and privileges to spotlight
-- =============================================================================
--
GRANT CONNECT TO spotlight;
GRANT DBA TO spotlight;
ALTER USER spotlight DEFAULT ROLE ALL;

GRANT SELECT ANY DICTIONARY TO spotlight;
GRANT SELECT ANY SEQUENCE TO spotlight;
GRANT SELECT ANY TABLE TO spotlight;
GRANT SELECT ANY TRANSACTION TO spotlight;
GRANT UNLIMITED TABLESPACE TO spotlight;

