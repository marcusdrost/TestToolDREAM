--------------------------------------------------------
--  File created - Saturday-February-01-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CMP_USER_ADMINISTRATOR
--------------------------------------------------------

  CREATE TABLE "CMP_USER_ADMINISTRATOR" ("USERNAME" VARCHAR2(20), "PASSWORD" VARCHAR2(20))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CMP_ROLES
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CMP_ROLES" ("ENVIRONMENT" VARCHAR2(3 CHAR), "ROLENAME" VARCHAR2(30 CHAR), "STATUS" VARCHAR2(10 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CMP_USER_ROLES
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CMP_USER_ROLES" ("ROLENAME" VARCHAR2(30 CHAR), "USERNAME" VARCHAR2(30 CHAR), "STATUS" VARCHAR2(10 CHAR), "ENVIRONMENT" VARCHAR2(3 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CMP_USERS
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CMP_USERS" ("USERNAME" VARCHAR2(30 CHAR), "CMP_USER_YN" VARCHAR2(1 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CONSTRAINTS
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CONSTRAINTS" ("TAB" VARCHAR2(30 CHAR), "COL" VARCHAR2(30 CHAR), "UNQ_CONS" NUMBER(1,0), "TEC_UNQ_CONS" NUMBER(1,0), "FK_CONS" NUMBER(1,0), "FK_TAB" VARCHAR2(30 CHAR), "FK_COL" VARCHAR2(30 CHAR), "EXCLUDE_COL" NUMBER(1,0), "NON_STND_TEC_COL" NUMBER(1,0), "LEFT_COL_IND" NUMBER(1,0), "RIGHT_COL_IND" NUMBER(1,0), "RUN_ID" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CONSTRAINTS_ANL
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CONSTRAINTS_ANL" ("TAB" VARCHAR2(30 CHAR), "COL" VARCHAR2(30 CHAR), "POS" NUMBER(1,0), "MAXPOS" NUMBER(1,0), "UNQ_CONS" NUMBER(1,0), "UNQ_CONS_ID" VARCHAR2(20 CHAR), "TEC_UNQ_CONS" NUMBER(1,0), "TEC_UNQ_CONS_ID" VARCHAR2(20 CHAR), "FK_CONS" NUMBER(1,0), "FK_CONS_ID" VARCHAR2(20 CHAR), "FK_TAB" VARCHAR2(30 CHAR), "FK_COL" VARCHAR2(30 CHAR), "EXCLUDE_COL" NUMBER(1,0), "NON_STND_TEC_COL" NUMBER(1,0), "ANL_UNQCONS_NEXISTS_LYN" NUMBER(1,0), "ANL_UNQCONS_UNIQUE_LYN" NUMBER(1,0), "ANL_UNQCONS_NULL_LYN" NUMBER(1,0), "ANL_TECUNQ_DUBBEL_LYN" NUMBER(1,0), "ANL_TECUNQ_CONS_UNIQUE_LYN" NUMBER(1,0), "ANL_TECUNQ_CONS_INTSEC_LYN" NUMBER(1,0), "ANL_FKCONS_WITHOUT_LYN" NUMBER(1,0), "ANL_ONLYCOL_L" NUMBER(1,0), "ANL_UNQCONS_NEXISTS_RYN" NUMBER(1,0), "ANL_UNQCONS_UNIQUE_RYN" NUMBER(1,0), "ANL_UNQCONS_NULL_RYN" NUMBER(1,0), "ANL_TECUNQ_DUBBEL_RYN" NUMBER(1,0), "ANL_TECUNQ_CONS_UNIQUE_RYN" NUMBER(1,0), "ANL_TECUNQ_CONS_INTSEC_RYN" NUMBER(1,0), "ANL_FKCONS_WITHOUT_RYN" NUMBER(1,0), "ANL_ONLYCOL_R" NUMBER(1,0), "RUN_ID" VARCHAR2(200 CHAR), "ANL_DATATYPE_DIFF_LNY" NUMBER(1,0), "ANL_DATATYPE_DIFF_RNY" NUMBER(1,0), "ANL_FKCONS_WITHOUT_DATA_LYN" NUMBER(1,0), "ANL_FKCONS_WITHOUT_DATA_RYN" NUMBER(1,0), "ANL_TECUNQ_NULL_LYN" NUMBER(1,0), "ANL_TECUNQ_NULL_RYN" NUMBER(1,0))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CONSTRAINTS_LIB
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CONSTRAINTS_LIB" ("ENVIRONMENT" VARCHAR2(3 CHAR), "DB_SCHEMA" VARCHAR2(20 CHAR), "PREFIX" VARCHAR2(3 CHAR), "LEFT_SUFFIX" VARCHAR2(8 CHAR), "RIGHT_SUFFIX" VARCHAR2(8 CHAR), "TAB" VARCHAR2(30 CHAR), "COL" VARCHAR2(30 CHAR), "UNQ_CONS" NUMBER(1,0), "TEC_UNQ_CONS" NUMBER(1,0), "FK_CONS" NUMBER(1,0), "FK_TAB" VARCHAR2(30 CHAR), "FK_COL" VARCHAR2(30 CHAR), "EXCLUDE_COL" NUMBER(1,0), "NON_STND_TEC_COL" NUMBER(1,0), "DESCRIPTION" VARCHAR2(200 CHAR), "LEFT_COL_IND" NUMBER(1,0), "RIGHT_COL_IND" NUMBER(1,0))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_CONSTRAINTS_TMP
--------------------------------------------------------

  CREATE TABLE "CMP_USER_CONSTRAINTS_TMP" ("TAB" VARCHAR2(30 CHAR), "COL" VARCHAR2(30 CHAR), "POS" NUMBER(1,0), "MAXPOS" NUMBER(1,0), "UNQ_CONS" NUMBER(1,0), "UNQ_CONS_ID" VARCHAR2(20 CHAR), "TEC_UNQ_CONS" NUMBER(1,0), "TEC_UNQ_CONS_ID" VARCHAR2(20 CHAR), "FK_CONS" NUMBER(1,0), "FK_CONS_ID" VARCHAR2(20 CHAR), "FK_TAB" VARCHAR2(30 CHAR), "FK_COL" VARCHAR2(30 CHAR), "EXCLUDE_COL" NUMBER(1,0), "NON_STND_TEC_COL" NUMBER(1,0), "LEFT_COL_IND" NUMBER(1,0), "RIGHT_COL_IND" NUMBER(1,0), "RUN_ID" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_DBMS_SCHED_STATUS
--------------------------------------------------------

  CREATE TABLE "CMP_USER_DBMS_SCHED_STATUS" ("STATUS" VARCHAR2(20), "ERR_MSG" VARCHAR2(2000), "JOB_NAME" VARCHAR2(2000), "LOG_DATE" DATE)
/
--------------------------------------------------------
--  DDL for Table CMP_USER_IMPORT_TABLES
--------------------------------------------------------

  CREATE TABLE "CMP_USER_IMPORT_TABLES" ("SRC_TAB" VARCHAR2(100 CHAR), "IN_SCOPE" NUMBER(5,0) DEFAULT 0, "DST_TAB_PREFIX" VARCHAR2(3 CHAR), "DST_TAB_BODY" VARCHAR2(100 CHAR), "DST_TAB_SUFFIX" VARCHAR2(8 CHAR), "NOMATCH_YN" NUMBER(1,0), "NOT_UNIQUE_YN" NUMBER(1,0), "DST_TAB_TOO_LONG_YN" NUMBER(1,0), "RUN_ID" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_IMPORT_TABLES_LIB
--------------------------------------------------------

  CREATE TABLE "CMP_USER_IMPORT_TABLES_LIB" ("ENVIRONMENT" VARCHAR2(3 CHAR), "DB_SCHEMA" VARCHAR2(20 CHAR), "SRC_SCHEMA" VARCHAR2(20 CHAR), "SUFFIX" VARCHAR2(8 CHAR), "SRC_TAB" VARCHAR2(100 CHAR), "DST_TAB_PREFIX" VARCHAR2(3 CHAR), "DST_TAB_BODY" VARCHAR2(100 CHAR), "DST_TAB_SUFFIX" VARCHAR2(8 CHAR), "DESCRIPTION" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_LOGGING
--------------------------------------------------------

  CREATE TABLE "CMP_USER_LOGGING" ("DATETIME" DATE, "FUNCTION" VARCHAR2(30 CHAR), "MESSAGE" VARCHAR2(100 CHAR), "COUNTER" NUMBER(20,0))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_LOGO
--------------------------------------------------------

  CREATE TABLE "CMP_USER_LOGO" ("LOGO" BLOB)
/
--------------------------------------------------------
--  DDL for Table CMP_USER_PARAM_CONFIG
--------------------------------------------------------

  CREATE TABLE "CMP_USER_PARAM_CONFIG" ("RUN_DATETIME" DATE, "RUN_ID" NUMBER, "RUN_DESCRIPTION" VARCHAR2(200 CHAR), "ENVIRONMENT" VARCHAR2(3 CHAR), "DB_SCHEMA" VARCHAR2(20 CHAR), "PREFIX" VARCHAR2(3 CHAR), "TABLESPACE" VARCHAR2(2000 CHAR), "LEFT_SUFFIX" VARCHAR2(8 CHAR), "RIGHT_SUFFIX" VARCHAR2(8 CHAR), "SPOOL_OUTPUT_DIR" VARCHAR2(2000 CHAR), "COMPARE_BIN_DIR" VARCHAR2(2000 CHAR), "COMPARE_SQL_DIR" VARCHAR2(2000 CHAR), "LEFT_SUFFIX_CLEAN" VARCHAR2(8 CHAR), "RIGHT_SUFFIX_CLEAN" VARCHAR2(8 CHAR), "ORACLE_HOME" VARCHAR2(2000 CHAR), "LD_LIBRARY_PATH" VARCHAR2(2000 CHAR), "TEC_COL_1" VARCHAR2(2000 CHAR), "TEC_COL_2" VARCHAR2(2000 CHAR), "TEC_COL_3" VARCHAR2(2000 CHAR), "TEC_COL_4" VARCHAR2(2000 CHAR), "TEC_COL_5" VARCHAR2(2000 CHAR), "TEC_COL_6" VARCHAR2(2000 CHAR), "TEC_COL_7" VARCHAR2(2000 CHAR), "TEC_COL_8" VARCHAR2(2000 CHAR), "TEC_COL_9" VARCHAR2(2000 CHAR), "TEC_COL_10" VARCHAR2(2000 CHAR), "LOCKED_YN" NUMBER(1,0), "DB_SCHEMA_PWD" VARCHAR2(50), "DB_SID" VARCHAR2(100), "SRC_SCHEMA" VARCHAR2(100 CHAR), "USER_NAME" VARCHAR2(30 CHAR), "USED_BY" VARCHAR2(30 CHAR), "EXT_IND" VARCHAR2(1 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_SELECTION_TABLES
--------------------------------------------------------

  CREATE TABLE "CMP_USER_SELECTION_TABLES" ("TAB" VARCHAR2(100 CHAR), "IN_SCOPE" NUMBER(5,0) DEFAULT 0, "ORDER_ASCENDING" NUMBER(6,0) DEFAULT 100, "RUN_ID" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table CMP_USER_SELECTION_TABLES_TMP
--------------------------------------------------------

  CREATE TABLE "CMP_USER_SELECTION_TABLES_TMP" ("TAB" VARCHAR2(100 CHAR), "IN_SCOPE" NUMBER(5,0) DEFAULT 0, "ORDER_ASCENDING" NUMBER(6,0) DEFAULT 100, "RUN_ID" VARCHAR2(200 CHAR))
/
--------------------------------------------------------
--  DDL for Table UNIX_OS_MODE
--------------------------------------------------------

  CREATE TABLE "UNIX_OS_MODE" ("OS_MODE" VARCHAR2(10 CHAR))
/
--------------------------------------------------------
--  DDL for Table UNIX_SH_FILE
--------------------------------------------------------

  CREATE TABLE "UNIX_SH_FILE" ("FILE_NAME" VARCHAR2(200 CHAR), "STEP_NR" NUMBER(20,0), "SQL_FILE_NAME" VARCHAR2(100 CHAR), "SH_FILE_NAME" VARCHAR2(100 CHAR), "SQL_FILE_NAME_DIR" VARCHAR2(5), "RUN_ID" VARCHAR2(100 CHAR))
/
--------------------------------------------------------
--  DDL for Table UNIX_SPOOL_FILE
--------------------------------------------------------

  CREATE TABLE "UNIX_SPOOL_FILE" ("RUN_ID" VARCHAR2(200 CHAR), "FILE_NAME" VARCHAR2(200 CHAR), "ROW_NR" NUMBER(20,0), "ROW_CONTENT" VARCHAR2(4000 CHAR), "FILE_TYPE" VARCHAR2(10 CHAR), "COUNTER" NUMBER(20,0), "DATETIME" DATE, "ERROR" CHAR(1 CHAR), "STATEMENT_NR" NUMBER(20,0))
/
--------------------------------------------------------
--  DDL for Table UNIX_SQL_FILE
--------------------------------------------------------

  CREATE TABLE "UNIX_SQL_FILE" ("FILE_NAME" VARCHAR2(200 CHAR), "STATEMENT_NR" NUMBER(20,0), "STATEMENT_TYPE" VARCHAR2(10 CHAR), "STATEMENT_CONTENT_1" VARCHAR2(4000 CHAR), "STATEMENT_CONTENT_2" VARCHAR2(4000 CHAR), "STATEMENT_CONTENT_3" VARCHAR2(4000 CHAR), "STATEMENT_CONTENT_4" VARCHAR2(4000 CHAR), "STATEMENT_CONTENT_5" VARCHAR2(4000 CHAR), "SPOOL_FILE_NAME" VARCHAR2(200 CHAR), "SPOOL_FILE_TYPE" VARCHAR2(10 CHAR), "RUN_ID" VARCHAR2(100 CHAR), "TEMPLATE_IND" NUMBER(1,0))
/
--------------------------------------------------------
--  DDL for Table UNIX_SQL_PARAMS
--------------------------------------------------------

  CREATE TABLE "UNIX_SQL_PARAMS" ("PARAM_NAME" VARCHAR2(100 CHAR), "PARAM_VALUE" VARCHAR2(100 CHAR), "RUN_ID" VARCHAR2(100 CHAR))
/
--------------------------------------------------------
--  DDL for Index UNIQUE_RUN_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "UNIQUE_RUN_ID" ON "CMP_USER_PARAM_CONFIG" ("RUN_ID")
/
--------------------------------------------------------
--  Constraints for Table CMP_USER_PARAM_CONFIG
--------------------------------------------------------

  ALTER TABLE "CMP_USER_PARAM_CONFIG" ADD CONSTRAINT "UNIQUE_RUN_ID" UNIQUE ("RUN_ID") ENABLE
/
