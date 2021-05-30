--------------------------------------------------------------------------------
-- sysplus / as sysdba
--------------------------------------------------------------------------------
alter system set processes = 1500 scope = spfile;
alter system set sessions = 2272 scope = spfile;
alter system set transactions = 1650 scope = spfile;

alter system set deferred_segment_creation = false scope = both;


--------------------------------------------------------------------------------
-- profiles
--------------------------------------------------------------------------------
-- select * from dba_profiles;
alter profile default limit failed_login_attempts unlimited;
alter profile default limit password_life_time unlimited;


--------------------------------------------------------------------------------
-- enable archivelog & flashback
--------------------------------------------------------------------------------
-- startup mount;
-- alter database archivelog;
-- alter database flashback on;
-- alter database open;


--------------------------------------------------------------------------------
-- check status
--------------------------------------------------------------------------------
-- select flashback_on from v$database;
-- archive log list
