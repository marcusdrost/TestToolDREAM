--------------------------------------------------------
--  File created - Saturday-February-01-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ADMIN_CHPWD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ADMIN_CHPWD" 
( P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  P_NEW_PWD_st IN VARCHAR2,
  P_NEW_PWD_nd IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_ADMIN_CHPWD(P_USER, P_PWD, P_NEW_PWD_st, P_NEW_PWD_nd);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ADMIN_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ADMIN_YN" 
( P_USER IN VARCHAR2,
  P_PASSWORD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_ADMIN_YN(P_USER, P_PASSWORD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ANALYSE_ISSUES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ANALYSE_ISSUES" 
(
  P_APP_NAME IN VARCHAR2,
  P_RUN_ID IN NUMBER,
  P_TYPE IN CHAR -- E=error, W=warning, I=info
) RETURN NUMBER AS
begin
  return app_cmp_test.CMP_GUI_API_ANALYSE_ISSUES(P_APP_NAME,P_RUN_ID,P_TYPE);
end;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_APP_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_APP_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_APP_FORMAT_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_APP_FORMAT_YN" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_APP_FORMAT_YN(P_APP_NAME);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_APP_LOCKED_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_APP_LOCKED_YN" (       p_app_name varchar2
                                                 ) return number as
l_check_app_locked number;
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_APP_LOCKED_YN(p_app_name);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_CHECK_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_CHECK_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_CHECK_IMPORT(P_APP_NAME, P_ACTUAL_RUN_ID, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_CLN_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_CLN_STEP" 
(
  P_APP_NAME IN VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_CLN_STEP(P_APP_NAME, P_SUFFIX_RIGHT, P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_CLR_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_CLR_STEP" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_CLR_STEP(P_APP_NAME, P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_CRT_VIEW_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_CRT_VIEW_STEP" 
(
  P_APP_NAME VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_CRT_VIEW_STEP(P_APP_NAME,P_SUFFIX_LEFT,P_SUFFIX_RIGHT,P_RUN_DESCRIPTION,P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_DEL_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_DEL_APP" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_DEL_APP(P_APP_NAME, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_DEL_SUFFIX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_DEL_SUFFIX" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX VARCHAR2
) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_DEL_SUFFIX(P_APP_NAME,P_SUFFIX);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_FIND_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_FIND_RUN_ID" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_FIND_RUN_ID(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_FORMAT_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_FORMAT_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_START_POS1 NUMBER,
  P_STOP_POS1 NUMBER,
  P_START_POS2 NUMBER,
  P_STOP_POS2 NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_FORMAT_IMPORT(P_APP_NAME,P_ACTUAL_RUN_ID,P_START_POS1,P_STOP_POS1,P_START_POS2,P_STOP_POS2);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_FREE_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_FREE_APP" (    p_app_name varchar2,
                                                   p_user varchar2
                                                 ) return number as
                                                 BEGIN
                                                   return APP_CMP_TEST.CMP_GUI_API_FREE_APP(p_app_name, p_user);
                                                 END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_GIVE_APP_USED_BY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_GIVE_APP_USED_BY" (    p_app_name varchar2
                                                 ) return VARCHAR2 as
BEGIN
  return app_cmp_test.CMP_GUI_API_GIVE_APP_USED_BY(p_app_name);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_GIVE_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_GIVE_DESCR" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
BEGIN
  return app_cmp_test.CMP_GUI_API_GIVE_DESCR(P_APP_NAME,P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_GIVE_SUFFIX_LEFT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_GIVE_SUFFIX_LEFT" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
BEGIN
  return app_cmp_test.CMP_GUI_API_GIVE_SUFFIX_LEFT(P_APP_NAME,P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_GIVE_SUFFIX_RIGHT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_GIVE_SUFFIX_RIGHT" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
BEGIN
  return app_cmp_test.CMP_GUI_API_GIVE_SUFFIX_RIGHT(P_APP_NAME,P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_GIVE_USER_ROLE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_GIVE_USER_ROLE" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2
) RETURN VARCHAR2 AS
BEGIN
  return app_cmp_test.CMP_GUI_API_GIVE_USER_ROLE(P_APP_NAME,P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_IMP_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_IMP_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER,
  p_run_description varchar2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_IMP_STEP1(P_APP_NAME, P_REL_NR, P_CYC_NR, P_DAY_NR, p_run_description, P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_IMP_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_IMP_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_IMP_STEP2(P_APP_NAME, P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_INS_ROL_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_INS_ROL_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
  ) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_INS_ROL_STEP1(P_APP_NAME, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_INS_ROL_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_INS_ROL_STEP2" 
(
  P_APP_NAME IN VARCHAR2,
  P_RUN_ID IN NUMBER,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
  ) RETURN NUMBER AS
BEGIN
  return APP_CMP_TEST.CMP_GUI_API_INS_ROL_STEP2(P_APP_NAME, P_RUN_ID, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_LAST_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_LAST_RUN_ID" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_LAST_RUN_ID(P_APP_NAME);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_LOAD_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_LOAD_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_LOAD_CONSTRAINTS(P_APP_NAME, P_ACTUAL_RUN_ID, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_LOAD_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_LOAD_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_LOAD_IMPORT(P_APP_NAME, P_ACTUAL_RUN_ID, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_LOCK_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_LOCK_APP" (       p_app_name varchar2
                                                 ) return number as
BEGIN
  return app_cmp_test.CMP_GUI_API_LOCK_APP(p_app_name);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_LOGO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_LOGO" 
 RETURN BLOB AS
l_temp blob;
BEGIN
  return app_cmp_test.CMP_GUI_API_LOGO;
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_MOD_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_MOD_CONFIG" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  p_left_suffix varchar2,
  p_right_suffix varchar2,
  p_run_description varchar2,
  p_DB_SCHEMA varchar2,
  p_prefix varchar2,
  p_tablespace varchar2,
  p_SPOOL_OUTPUT_DIR varchar2,
  p_COMPARE_BIN_DIR varchar2,
  p_COMPARE_SQL_DIR varchar2,
  p_LEFT_SUFFIX_CLEAN varchar2,
  p_RIGHT_SUFFIX_CLEAN varchar2,
  p_ORACLE_HOME varchar2,
  p_LD_LIBRARY_PATH varchar2,
  p_TEC_COL_1 varchar2,
  p_TEC_COL_2 varchar2,
  p_TEC_COL_3 varchar2,
  p_TEC_COL_4 varchar2,
  p_TEC_COL_5 varchar2,
  p_TEC_COL_6 varchar2,
  p_TEC_COL_7 varchar2,
  p_TEC_COL_8 varchar2,
  p_TEC_COL_9 varchar2,
  p_TEC_COL_10 varchar2,
  p_USER_NAME varchar2,
  p_USED_BY varchar2,
  p_LOCKED_YN number,
  p_DB_SCHEMA_PWD varchar2,
  p_DB_SID varchar2,
  p_ext_ind varchar2,
  p_src_schema varchar2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_MOD_CONFIG
  (P_APP_NAME,
  P_USER,
  P_PWD,
  p_left_suffix,
  p_right_suffix,
  p_run_description ,
  p_DB_SCHEMA,
  p_prefix,
  p_tablespace,
  p_SPOOL_OUTPUT_DIR,
  p_COMPARE_BIN_DIR,
  p_COMPARE_SQL_DIR,
  p_LEFT_SUFFIX_CLEAN,
  p_RIGHT_SUFFIX_CLEAN,
  p_ORACLE_HOME,
  p_LD_LIBRARY_PATH,
  p_TEC_COL_1,
  p_TEC_COL_2,
  p_TEC_COL_3,
  p_TEC_COL_4,
  p_TEC_COL_5,
  p_TEC_COL_6,
  p_TEC_COL_7,
  p_TEC_COL_8,
  p_TEC_COL_9,
  p_TEC_COL_10,
  p_USER_NAME,
  p_USED_BY,
  p_LOCKED_YN,
  p_DB_SCHEMA_PWD,
  p_DB_SID,
  p_ext_ind,
  p_src_schema);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_NEW_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_NEW_APP" 
(
  P_NEW_APP_NAME IN VARCHAR2,
  P_CPY_APP_NAME IN VARCHAR2,
  P_RUN_DESCRIPTION IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_NEW_APP(P_NEW_APP_NAME,P_CPY_APP_NAME,P_RUN_DESCRIPTION,P_USER,P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_NEW_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_NEW_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_NEW_STEP1(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT, P_RUN_DESCRIPTION, P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_NEW_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_NEW_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_NEW_STEP2(P_APP_NAME,P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_NEW_STEP3
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_NEW_STEP3" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_NEW_STEP3(P_APP_NAME, P_ACTUAL_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_NEW_STEP4
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_NEW_STEP4" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_NEW_STEP4(P_APP_NAME, P_ACTUAL_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_OS_CHPWD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_OS_CHPWD" 
( P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  P_NEW_PWD_st IN VARCHAR2,
  P_NEW_PWD_nd IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_OS_CHPWD(P_USER, P_PWD, P_NEW_PWD_st, P_NEW_PWD_nd);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_RE_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_RE_STEP1" 
(
  P_APP_NAME VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_RE_STEP1(P_APP_NAME,P_SUFFIX_LEFT,P_SUFFIX_RIGHT,P_RUN_DESCRIPTION,P_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_RE_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_RE_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_RE_STEP2(P_APP_NAME, P_ACTUAL_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_RECONVERT_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_RECONVERT_RUN_ID" 
(
  P_RUN_ID VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_RECONVERT_RUN_ID(P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_REUSE_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_REUSE_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_REUSE_CONSTRAINTS(P_APP_NAME, P_ACTUAL_RUN_ID, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_REUSE_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_REUSE_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_REUSE_IMPORT(P_APP_NAME, P_ACTUAL_RUN_ID, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ROLE_DEL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ROLE_DEL" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_ROLE_DEL(P_APP_NAME, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ROLE_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ROLE_NEW" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_ROLE_NEW(P_APP_NAME, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_ROLE_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_ROLE_YN" 
(
  P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_ROLE_YN(P_APP_NAME);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_RUN_ID_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_RUN_ID_EXISTS_YN" 
( P_RUN_ID IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SAVE_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SAVE_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_DESCR VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SAVE_CONSTRAINTS(P_APP_NAME,P_ACTUAL_RUN_ID,P_DESCR);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SAVE_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SAVE_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_DESCRIPTION VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SAVE_IMPORT(P_APP_NAME, P_ACTUAL_RUN_ID, P_DESCRIPTION);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SFX_BOTH_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SFX_BOTH_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_LEFT_SUFFIX VARCHAR2,
  P_RIGHT_SUFFIX VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SFX_BOTH_EXISTS_YN(P_APP_NAME,P_LEFT_SUFFIX,P_RIGHT_SUFFIX);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SFX_CONS_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SFX_CONS_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SFX_CONS_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SFX_FORMAT_SUFFIX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SFX_FORMAT_SUFFIX" 
( P_APP_NAME VARCHAR2,
  P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER
) RETURN VARCHAR2 AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SFX_FORMAT_SUFFIX(P_APP_NAME, P_REL_NR, P_CYC_NR, P_DAY_NR);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SFX_FORMAT_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SFX_FORMAT_YN" 
( P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SFX_FORMAT_YN(P_REL_NR,P_CYC_NR,P_DAY_NR);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SFX_R_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SFX_R_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME,P_SUFFIX);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SUFFIX_ORDER_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SUFFIX_ORDER_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SUFFIX_ORDER_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SWAP_BACKWARD_RUN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SWAP_BACKWARD_RUN" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) return number as
BEGIN
  return app_cmp_test.CMP_GUI_API_SWAP_BACKWARD_RUN(P_APP_NAME, P_ACTUAL_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SWAP_FORWARD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SWAP_FORWARD" 
 RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_SWAP_FORWARD;
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_SWAP_FORWARD_RUN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_SWAP_FORWARD_RUN" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) return number as
BEGIN
  return app_cmp_test.CMP_GUI_API_SWAP_FORWARD_RUN(P_APP_NAME, P_ACTUAL_RUN_ID);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_UNLOCK_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_UNLOCK_APP" (       p_app_name varchar2
                                                 ) return number as
BEGIN
  return app_cmp_test.CMP_GUI_API_UNLOCK_APP(p_app_name);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USE_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USE_APP" (    p_app_name varchar2,
                                                   p_user varchar2
                                                 ) return number as
BEGIN
  return app_cmp_test.CMP_GUI_API_USE_APP(p_app_name,p_user);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_APP_ACCESS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_APP_ACCESS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_USER_NAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER_NAME);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_ROL_CLEAN_UP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_ROL_CLEAN_UP" 
(
  P_USER VARCHAR2,
  P_PWD VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_ROL_CLEAN_UP(P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_ROL_SYNC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_ROL_SYNC" 
(
  P_USER VARCHAR2,
  P_PWD VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_ROL_SYNC(P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_ROLE_DEL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_ROLE_DEL" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_ROLE_DEL(P_APP_NAME,P_ROLE_USER,P_USER,P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_ROLE_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_ROLE_NEW" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_ROLE_NEW(P_APP_NAME, P_ROLE_USER, P_USER, P_PWD);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_ROLE_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_ROLE_YN" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_ROLE_YN(P_APP_NAME, P_ROLE_USER);
END;
/
--------------------------------------------------------
--  DDL for Function SWP_GUI_API_USER_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SWP_GUI_API_USER_YN" 
(
  P_USERNAME IN VARCHAR2
) RETURN NUMBER AS
BEGIN
  return app_cmp_test.CMP_GUI_API_USER_YN(P_USERNAME);
END;
/
