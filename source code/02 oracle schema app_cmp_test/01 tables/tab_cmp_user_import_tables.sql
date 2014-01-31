--------------------------------------------------------
--  File created - Friday-January-31-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CMP_USER_IMPORT_TABLES
--------------------------------------------------------

  CREATE TABLE "CMP_USER_IMPORT_TABLES" ("SRC_TAB" VARCHAR2(100 CHAR), "IN_SCOPE" NUMBER(5,0) DEFAULT 0, "DST_TAB_PREFIX" VARCHAR2(3 CHAR), "DST_TAB_BODY" VARCHAR2(100 CHAR), "DST_TAB_SUFFIX" VARCHAR2(8 CHAR), "NOMATCH_YN" NUMBER(1,0), "NOT_UNIQUE_YN" NUMBER(1,0), "DST_TAB_TOO_LONG_YN" NUMBER(1,0), "RUN_ID" VARCHAR2(200 CHAR))
/
