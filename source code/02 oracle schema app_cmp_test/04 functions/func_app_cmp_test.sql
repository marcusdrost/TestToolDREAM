--------------------------------------------------------
--  File created - Saturday-February-01-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ADMIN_CHPWD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ADMIN_CHPWD" 
( P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  P_NEW_PWD_st IN VARCHAR2,
  P_NEW_PWD_nd IN VARCHAR2
) RETURN NUMBER AS
l_check_admin number;
  -- Function in order to change the administrator password
  --
  -- IN: user/password
  -- 2 times the new pasword
  --
  -- return  0 = password has been changed
  -- return -1 = user is no administrator
  -- return -2 = new_pwd+st and new_pwd_nd are diffrent
BEGIN
  p_cmp_user_logging(sysdate,'cmp_gui_api_admin_chpwd ','-u:'||P_USER||' p:'||P_PWD||' pn1:'||P_NEW_PWD_st||' pn2:'||P_NEW_PWD_ND);
  if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -1;
  else begin
    p_cmp_user_logging(sysdate,'cmp_gui_api_admin_chpwd ','YES ADMIN');
    if (p_new_pwd_st!=p_new_pwd_nd) then return -2;
    else begin
      return f_cmp_admin_chpwd(p_user, p_pwd, p_new_pwd_st, p_new_pwd_nd);
    end; end if;
  end; end if;

END CMP_GUI_API_ADMIN_CHPWD;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ADMIN_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ADMIN_YN" 
( P_USER IN VARCHAR2,
  P_PASSWORD IN VARCHAR2
) RETURN NUMBER AS
l_check_admin number;
  -- Function in order to change the administrator password
  --
  -- IN: user/password
  -- password
  --
  -- return  0 = user is administrator
  -- return -1 = user is no administrator
BEGIN
  p_cmp_user_logging(sysdate,'cmp_gui_api_admin_yn user','-'||P_USER||' password:'||P_PASSWORD);
  return F_CMP_ADMIN_YN(P_USER, P_PASSWORD);
END CMP_GUI_API_ADMIN_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ANALYSE_ISSUES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ANALYSE_ISSUES" 
(
  P_APP_NAME IN VARCHAR2,
  P_RUN_ID IN NUMBER,
  P_TYPE IN CHAR -- E=error, W=warning, I=info
) RETURN NUMBER AS
-- Second step of the 'from-scratch'-compare is the preperation of constraints for the user
--
-- IN: P_APP_NAME
-- P_RUN_ID = current run_id
--
-- return 0 = analysis succesfull
-- return >0 = not successfull number of issues
-- return -1 = the application does not exist
-- return -2 = rund id does not exist
-- return -3 = type does not exist

    l_check_exist_app number;
    l_result number;
    l_result_temp number;
    l_analyse_cnt number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return -2;
    else begin
      if upper(p_type) not in ('E','W','I') then return -3;
      else begin
        p_cmp_user_logging(sysdate, 'cmp_gui_api_analyse_okay_yn', to_char(P_RUN_ID,'999999999999999999')||'_p1');

        select count(*)
        into l_analyse_cnt
        from CMP_USER_CONSTRAINTS_ANL
        where P_RUN_ID=CMP_GUI_API_RECONVERT_RUN_ID(run_id)
              and
              ((upper(p_type)='E' and nvl(ANL_UNQCONS_NEXISTS_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_UNQCONS_UNIQUE_LYN,0)=1) or
               (upper(p_type)='W' and nvl(ANL_UNQCONS_NULL_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_DUBBEL_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_CONS_UNIQUE_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_CONS_INTSEC_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_FKCONS_WITHOUT_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_ONLYCOL_L,0)=1) or
               (upper(p_type)='E' and nvl(ANL_UNQCONS_NEXISTS_RYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_UNQCONS_UNIQUE_RYN,0)=1) or
               (upper(p_type)='W' and nvl(ANL_UNQCONS_NULL_RYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_DUBBEL_RYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_CONS_UNIQUE_RYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_TECUNQ_CONS_INTSEC_RYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_FKCONS_WITHOUT_RYN,0)=1) or
               (upper(p_type)='I' and nvl(ANL_ONLYCOL_R,0)=1) or
               (upper(p_type)='E' and nvl(ANL_DATATYPE_DIFF_LNY,0)=1) or
               (upper(p_type)='E' and nvl(ANL_DATATYPE_DIFF_RNY,0)=1) or
               (upper(p_type)='E' and nvl(ANL_FKCONS_WITHOUT_DATA_LYN,0)=1) or
               (upper(p_type)='E' and nvl(ANL_FKCONS_WITHOUT_DATA_RYN,0)=1) or
               (upper(p_type)='W' and nvl(ANL_TECUNQ_NULL_LYN,0)=1) or
               (upper(p_type)='W' and nvl(ANL_TECUNQ_NULL_RYN,0)=1));

       return  l_analyse_cnt;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_ANALYSE_ISSUES;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_APP_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_APP_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
l_check_exist_app number;
--
-- Function in order to check if an given applicaiton exists
--
-- IN: P_APP_NAME
--
-- return  0 = APP exists
-- return -1 = APP does not exist
BEGIN
  select count(*)
  into l_check_exist_app
  from cmp_user_param_config
  where upper(environment)=upper(P_APP_NAME);
  if (l_check_exist_app=0) then return -1; else return 0; end if;

END CMP_GUI_API_APP_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_APP_FORMAT_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_APP_FORMAT_YN" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
-- Function in order to check the format an an application
--
-- IN: P_APP_NAME
--
-- return  0 = format is okay
-- return -1 = format is not okay
l_check_exist_app number;
BEGIN
 if length(P_APP_NAME)=3 then
   if (ascii(upper(substr(P_APP_NAME,2,1)))>=65 and ascii(upper(substr(P_APP_NAME,2,1)))<=90) then
     if (ascii(upper(substr(P_APP_NAME,3,1)))>=65 and ascii(upper(substr(P_APP_NAME,3,1)))<=90) then
       return 0;
     end if;
   end if;
 end if;
 return -1;

END CMP_GUI_API_APP_FORMAT_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_APP_LOCKED_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_APP_LOCKED_YN" (       p_app_name varchar2
                                                 ) return number as
l_check_app_locked number;
--
-- Function in order to check if the application is locked
--
-- IN: P_APP_NAME
--
-- return 0   - application is not locked
-- return -1  - application is locked
begin
  select count(*)
  into l_check_app_locked
  from cmp_user_param_config
  where upper(environment)=upper(P_APP_NAME)
        and
        nvl(locked_yn,0)=1;
  if (l_check_app_locked>0) then return -1;
  else return 0;
  end if;
END CMP_GUI_API_APP_LOCKED_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_CHECK_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_CHECK_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_ACTUAL_RUN_ID =  run id
-- P_SUFFIX_RIGHT = baseline to be referenced or NULL when no baseline selected
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist
-- return -3 = suffix right does not exist in param_config
-- return -4 = suffix right does not exist in library
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0)
         and
         (P_SUFFIX_RIGHT IS NOT NULL) then return -3;
      else begin
        if (CMP_GUI_API_SFX_IMP_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0)
           and
           (P_SUFFIX_RIGHT IS NOT NULL)
           then return -4;
        else begin
          l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
          p_cmp_user_logging(sysdate,'cmp_gui_api_check_import',P_APP_NAME||to_char(P_ACTUAL_RUN_ID,'999999'));
          P_CMP_USER_SELECTION_IMP_CHECK(f_cmp_convert_run_id(P_ACTUAL_RUN_ID),P_SUFFIX_RIGHT);
          l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
          return P_ACTUAL_RUN_ID;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_CHECK_IMPORT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_CLN_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_CLN_STEP" 
(
  P_APP_NAME IN VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
-- Function in order to clean a compare baseline
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_RIGHT =  suffix for an existing new side
-- P_USER = initiating user
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = application already locked
-- return -3 = suffix right does not exist
-- return -4 = user not authorized for application
-- return -5 = TOP_CLN script not succesfull acording to cmp_user_dbms_sched_status
-- return -6 = STEP1 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config_rs(p_c_environment VARCHAR2, p_c_right_suffix VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          upper(p_c_right_suffix)=upper(right_suffix)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment)
                                 and
                                 upper(p_c_right_suffix)=upper(right_suffix));
    r_last_run_of_param_config_rs c_last_run_of_param_config_rs%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -3;
      else begin
        if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -4;
        else begin
          l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
          open c_last_run_of_param_config_rs(P_APP_NAME,P_SUFFIX_RIGHT);
          fetch c_last_run_of_param_config_rs into r_last_run_of_param_config_rs;
          close c_last_run_of_param_config_rs;
          l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_rs.run_id,null,null,null,'cleaning up',P_USER, 'EMPTY', 'EMPTY');

          P_CMP_MAIN_CLN_TOP(l_new_run_id);
          p_cmp_user_logging(sysdate, 'cmp_gui_api_cln_step', to_char(l_new_run_id,'999999999999999999')||'_p1');
          l_result := F_CMP_MAIN_CLN_TOP_LOG(l_new_run_id);
          p_cmp_user_logging(sysdate, 'cmp_gui_api_cln_step', to_char(l_result,'999999999999999999')||'_p2');

          if l_result<0 then return -5;
          else begin
            P_CMP_DWH_MAIN_CLN_PART1(l_new_run_id);
            l_result := F_CMP_DWH_MAIN_CLN_PART1_LOG(l_new_run_id);
            if l_result<0 then return -6;
            else begin
              p_cmp_user_logging(sysdate, 'cmp_gui_api_cln_step','user:'||P_USER||' '||' removed suffix:'||P_SUFFIX_RIGHT||' '||' from application:'||P_APP_NAME);
              l_result_temp :=CMP_GUI_API_DEL_SUFFIX(P_APP_NAME, P_SUFFIX_RIGHT);
              l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
              l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
              return l_new_run_id;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_CLN_STEP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_CLR_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_CLR_STEP" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
-- Function in order to clean the result set of an application
--
-- IN: P_APP_NAME = name of the application
-- P_USER = initiating user
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = application already locked
-- return -3 = user not authorized for application
-- return -4 = TOP_CLR script not succesfull acording to cmp_user_dbms_sched_status
-- return -5 = STEP1 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config_rs(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_last_run_of_param_config_rs c_last_run_of_param_config_rs%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -3;
      else begin
        l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
        open c_last_run_of_param_config_rs(P_APP_NAME);
        fetch c_last_run_of_param_config_rs into r_last_run_of_param_config_rs;
        close c_last_run_of_param_config_rs;
        l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_rs.run_id,null,'EMPTY','EMPTY','cleaning up results',P_USER,'EMPTY','EMPTY');
        P_CMP_MAIN_CLR_TOP(l_new_run_id);
        p_cmp_user_logging(sysdate, 'cmp_gui_api_CLR_step', to_char(l_new_run_id,'999999999999999999')||'_p1');
        l_result := F_CMP_MAIN_CLR_TOP_LOG(l_new_run_id);
        p_cmp_user_logging(sysdate, 'cmp_gui_api_CLR_step', to_char(l_result,'999999999999999999')||'_p2');
        if l_result<0 then return -4;
        else begin
          P_CMP_DWH_MAIN_CLR_PART1(l_new_run_id);
          l_result := F_CMP_DWH_MAIN_CLR_PART1_LOG(l_new_run_id);
          if l_result<0 then return -5;
          else begin
            l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
            return l_new_run_id;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_CLR_STEP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_CRT_VIEW_STEP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_CRT_VIEW_STEP" 
(
  P_APP_NAME VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
-- Creation of views for users
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old sid
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = application already locked
-- return -3 = suffix left does not exist
-- return -4 = suffix right does not exist
-- return -5 = combination suffix left and suffix right does not exist
-- return -6 = user is not authorized for the application
-- return -7 = TOP_CRT_VIEW script not succesfull acording to cmp_user_dbms_sched_status
-- return -8 = CRT_VIEW1 script not succesfull acording to cmp_user_dbms_sched_status
-- return -9 = CRT_VIEW2 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_old_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_parconf_usrsel_sf(p_c_environment VARCHAR2, p_c_left_suffix VARCHAR2, p_c_right_suffix VARCHAR2) is
    select *
    from cmp_user_param_config upc
    where upper(p_c_environment)=upper(environment)
          and
          upper(p_c_left_suffix)=upper(left_suffix)
          and
          upper(p_c_right_suffix)=upper(right_suffix)
          and exists (select 1
                       from cmp_user_selection_tables cus
                       where upc.run_id=F_CMP_RECONVERT_RUN_ID(cus.run_id))
           order by run_datetime desc;
    r_last_run_parconf_usrsel_sf c_last_run_parconf_usrsel_sf%rowtype;
    cursor c_last_run_of_param_config_sf(p_c_environment VARCHAR2, p_c_left_suffix VARCHAR2, p_c_right_suffix VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          upper(p_c_left_suffix)=upper(left_suffix)
          and
          upper(p_c_right_suffix)=upper(right_suffix)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment)
                                 and
                                 upper(p_c_left_suffix)=upper(left_suffix)
                                 and
                                 upper(p_c_right_suffix)=upper(right_suffix));
    r_last_run_of_param_config_sf c_last_run_of_param_config_sf%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0) then return -3;
      else begin
        if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -4;
        else begin
          if (CMP_GUI_API_SFX_BOTH_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT)!=0) then return -5;
          else begin
            if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -6;
            else begin
              open c_last_run_parconf_usrsel_sf(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
              fetch c_last_run_parconf_usrsel_sf into r_last_run_parconf_usrsel_sf;
              close c_last_run_parconf_usrsel_sf;
              l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
              l_old_run_id :=r_last_run_parconf_usrsel_sf.run_id;
              --open c_last_run_of_param_config_sf(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
              --fetch c_last_run_of_param_config_sf into r_last_run_of_param_config_sf;
              --close c_last_run_of_param_config_sf;
              l_new_run_id :=0; -- F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_sf.run_id,P_APP_NAME,null,null,P_SUFFIX_LEFT||' '||P_SUFFIX_RIGHT,p_user,'EMPTY','EMPTY');
              p_cmp_user_logging(sysdate, 'cmp_gui_api_crt_view', to_char(l_old_run_id,'999999999999999999')||'_old_run_id');
              P_CMP_MAIN_CRT_VIEW_TOP(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_crt_view', to_char(l_new_run_id,'999999999999999999')||'_new_run_id');
              l_result := F_CMP_MAIN_CRT_VIEW_TOP_LOG(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_crt_view', to_char(l_result,'999999999999999999')||'_p2');
              if l_result<0 then return -7;
              else begin
                insert into cmp_user_logging values (sysdate,to_char(l_old_run_id),null,null); commit;
                P_CMP_DWH_MAIN_CRT_VIEW_PART1(l_new_run_id, nvl(l_old_run_id,0));
                l_result :=0; -- F_CMP_DWH_MAIN_CRT_VIEW_1_LOG(l_new_run_id);
                if l_result<0 then return -8;
                else begin
                  P_CMP_DWH_MAIN_CRT_VIEW_PART2(l_new_run_id, nvl(l_old_run_id,0));
                  l_result :=0; -- F_CMP_DWH_MAIN_CRT_VIEW_2_LOG(l_new_run_id);
                  if l_result<0 then return -9;
                  else begin
                     l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
                     l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
                     return l_new_run_id;
                  end; end if;
                end; end if;
              end; end if;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;
END CMP_GUI_API_CRT_VIEW_STEP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_DEL_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_DEL_APP" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
-- Function in order to clean up an application
--
-- P_APP_NAME = name of the application
-- P_USER = initiating user; has to be an administrator
--
-- return 0 = successfull
-- return -1 = application does not exist
-- return -2 = application is motherapplication
-- return -3 = application already locked
-- return -4 = user is not administrator
-- return -5 = application still has roles
-- return -6 = application still gas user roles
-- return -7 = application still has run-baselines with data
    l_new_run_id number;
    l_cnt_roles number;
    l_cnt_user_roles number;
    l_cnt_run_baselines number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if upper(P_APP_NAME)=upper('MMA') then return -2;
    else begin
      if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -3;
      else begin
        if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -4;
        else begin
          select count(*)
          into l_cnt_roles
          from cmp_user_cmp_roles
          where upper(environment)=upper(p_app_name);
          p_cmp_user_logging(sysdate, 'cmp_gui_api_del_app', to_char(l_cnt_roles,'999999999999999999')||'_cnt_roles');
          if l_cnt_roles > 0 then return -5;
          else begin
            select count(*)
            into l_cnt_user_roles
            from cmp_user_cmp_user_roles
            where upper(environment)=upper(p_app_name);
            if l_cnt_user_roles > 0 then return -6;
            else begin
              select count(*)
              into l_cnt_run_baselines
              from cmp_user_param_config
              where upper(environment)=upper(p_app_name)
                    and
                    upper(right_suffix) != upper('EMPTY');
              if l_cnt_run_baselines > 0 then return -7;
              else begin
                l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
                delete from cmp_user_param_config
                where upper(environment)=upper(p_app_name);
                commit;
                l_result_temp :=CMP_GUI_API_CLR_STEP(P_APP_NAME, P_USER);
                l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
                return 0;
              end; end if;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_DEL_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_DEL_SUFFIX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_DEL_SUFFIX" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX VARCHAR2
) RETURN NUMBER AS
-- Function in order to delete all occurences of an applicaiton and suffix
--
-- IN: P_APP_NAME
-- P_SUFFIX
--
-- return 0, after execution
--
  cursor c_found_run_of_param_config_sf(P_C_APP_NAME VARCHAR2, P_C_SUFFIX VARCHAR2) is
  select run_id
  from cmp_user_param_config
  where upper(P_C_APP_NAME)=upper(environment)
        and
        (upper(P_C_SUFFIX)=upper(right_suffix)
        or
        upper(P_C_SUFFIX)=upper(left_suffix));
  r_found_run_of_param_config_sf c_found_run_of_param_config_sf%rowtype;
  l_result number(1,0);
BEGIN
  open c_found_run_of_param_config_sf(P_APP_NAME, P_SUFFIX);
  loop
    fetch c_found_run_of_param_config_sf into r_found_run_of_param_config_sf;
    exit when c_found_run_of_param_config_sf%notfound;

    delete from cmp_user_param_config where run_id=r_found_run_of_param_config_sf.run_id;

    delete from cmp_user_selection_tables_tmp where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;
    delete from cmp_user_selection_tables where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;
    delete from cmp_user_import_tables where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;
    delete from cmp_user_constraints_tmp where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;
    delete from cmp_user_constraints_anl where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;
    delete from cmp_user_constraints where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=r_found_run_of_param_config_sf.run_id;

    delete from cmp_user_import_tables_lib where upper(suffix)=upper(P_SUFFIX) and upper(environment)=upper(p_app_name);

    delete from cmp_user_constraints_lib
    where (upper(left_suffix)=upper(P_SUFFIX) and upper(environment)=upper(p_app_name))
          or
          (upper(right_suffix)=upper(P_SUFFIX) and upper(environment)=upper(p_app_name));

    l_result :=UNIX_CLEAN_RUN_ID(F_CMP_CONVERT_RUN_ID(r_found_run_of_param_config_sf.run_id));
  end loop;
  close c_found_run_of_param_config_sf;
  commit;
  return 0;
END CMP_GUI_API_DEL_SUFFIX;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_FIND_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_FIND_RUN_ID" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function in order to find a run-id for a given applicaiton as well as left and right suffix
--
-- IN: P_APP_NAME
-- P_SUFFIX_LEFT
-- P_SUFFIX_RIGHT
--
-- return  0 = SUFFIXES do exist
-- return -1 = SUFFIXES do not exist or there is more than one

l_check_exist_run_id number;
l_run_id number;
cursor c_last_run_of_param_config(p_c_environment VARCHAR2, P_C_SUFFIX_LEFT VARCHAR2, P_C_SUFFIX_RIGHT VARCHAR2) is
select run_id
from cmp_user_param_config
where UPPER(p_c_environment)=UPPER(environment)
      and
      UPPER(P_C_SUFFIX_LEFT)=UPPER(LEFT_SUFFIX)
      and
      UPPER(P_C_SUFFIX_RIGHT)=UPPER(RIGHT_SUFFIX)
      and
      run_datetime = (select max(run_datetime)
                      from cmp_user_param_config
                      where UPPER(p_c_environment)=UPPER(environment)
                            and
                            UPPER(P_C_SUFFIX_LEFT)=UPPER(LEFT_SUFFIX)
                            and
                            UPPER(P_C_SUFFIX_RIGHT)=UPPER(RIGHT_SUFFIX));
r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN

  open c_last_run_of_param_config(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
  if c_last_run_of_param_config%NOTFOUND then return -1;
  else begin
    fetch c_last_run_of_param_config into r_user_param_config;
    close c_last_run_of_param_config;
    p_cmp_user_logging(sysdate, 'cmp_gui_api_find_run_id', to_char(r_user_param_config.run_id,'999999999999999999')||'_p1');
    return r_user_param_config.run_id;
  end; end if;

END CMP_GUI_API_FIND_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_FORMAT_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_FORMAT_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_START_POS1 NUMBER,
  P_STOP_POS1 NUMBER,
  P_START_POS2 NUMBER,
  P_STOP_POS2 NUMBER
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_ACTUAL_RUN_ID =  run id
-- P_START_POS1 = start point first part of table name
-- P_STOP_POS1 = stop point first part of table name
-- P_START_POS2 = start point first part of table name
-- P_STOP_POS2 = stop point first part of table name
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = run id does not exist
-- return -3 = start_pos 1 is 0
-- return -4 = start_pos1 > stop_pos1
-- return -5 = start_pos2 > 0 and start_pos2 > stop_pos2
-- return -6 = start_pos2 > 0 and stop_pos1 >= start_pos2

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      if nvl(P_START_POS1,0)=0 then return -3;
      else begin
        if nvl(P_START_POS1,0)>nvl(P_STOP_POS1,0) then return -4;
        else begin
          if (nvl(P_START_POS2,0) > 0) and (nvl(P_START_POS2,0)>nvl(P_STOP_POS2,0)) then return -5;
          else begin
            if (nvl(P_START_POS2,0) > 0) and (nvl(P_STOP_POS1,0)>=nvl(P_START_POS2,0)) then return -6;
            else begin
              l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
              p_cmp_user_logging(sysdate,'cmp_gui_api_format_import',P_APP_NAME||' '||to_char(P_ACTUAL_RUN_ID,'999999')||' '||to_char(P_START_POS1,'999999')||' '||to_char(P_STOP_POS1,'999999')||' '||to_char(P_START_POS2,'999999')||' '||to_char(P_STOP_POS2,'999999'));
              P_CMP_USER_SELECTION_IMP_FMT(f_cmp_convert_run_id(P_ACTUAL_RUN_ID),P_START_POS1,P_STOP_POS1,P_START_POS2,P_STOP_POS2);
              l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
              return P_ACTUAL_RUN_ID;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_FORMAT_IMPORT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_FREE_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_FREE_APP" (    p_app_name varchar2,
                                                   p_user varchar2
                                                 ) return number as
l_free_run_id number;
-- Function in order to indicate an application as not anymore 'used by'
--
-- IN: P_APP_NAME
--
-- return 0 = after execution
-- return -1 = application does not exist
-- return -2 = user has no authorization voor application
-- return -3 = application is not used by given user
begin
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -2;
    else begin
      update cmp_user_param_config
      set used_by=null
      where upper(ENVIRONMENT)=upper(p_app_name);
      commit;
      return 0;
    end; end if;
  end; end if;
END CMP_GUI_API_FREE_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_GIVE_APP_USED_BY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_GIVE_APP_USED_BY" (    p_app_name varchar2
                                                 ) return VARCHAR2 as
l_free_run_id number;
-- Function in order to indicate an application as 'used by'
--
-- IN: P_APP_NAME
--
-- return NOBODY = free
-- return USERNAME = application is used by user
l_cnt_user number;
l_used_by varchar2(30);
begin
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    select count(*)
    into l_cnt_user
    from cmp_user_param_config
    where (upper(nvl(used_by,'EMPTY')) != 'EMPTY')
          and
          upper(ENVIRONMENT)=upper(p_app_name);
    if (l_cnt_user=0) then return 'NOBODY';
    else begin
      select distinct used_by
      into l_used_by
      from cmp_user_param_config
      where upper(nvl(used_by,'EMPTY')) != 'EMPTY'
            and
            upper(ENVIRONMENT)=upper(p_app_name);
      return l_used_by;
      end; end if;
    end; end if;
END CMP_GUI_API_GIVE_APP_USED_BY;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_GIVE_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_GIVE_DESCR" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
l_description varchar2(2000);
BEGIN
-- Function in order to check if a right suffix exists
--
-- IN: P_APP_NAME
-- RUN_ID a RUN ID
--
-- return  description als okay
-- return "-1" = application does not exist
-- return "-2" = run id does not exist

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return '-1' ;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return '-2';
    else begin
      select run_description
      into l_description
      from cmp_user_param_config
      where upper(run_id)=upper(P_RUN_ID)
        and
        upper(environment)=upper(P_APP_NAME);
    end; end if;
  end; end if;

  return l_description;

END CMP_GUI_API_GIVE_DESCR;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_GIVE_SUFFIX_LEFT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_GIVE_SUFFIX_LEFT" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
l_suffix_left varchar2(8);
BEGIN
-- Function in order to check if a right suffix exists
--
-- IN: P_APP_NAME
-- RUN_ID a RUN ID
--
-- return  left suffix als okay
-- return "-1" = application does not exist
-- return "-2" = run id does not exist

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return '-1' ;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return '-2';
    else begin
      select left_suffix
      into l_suffix_left
      from cmp_user_param_config
      where upper(run_id)=upper(P_RUN_ID)
        and
        upper(environment)=upper(P_APP_NAME);
    end; end if;
  end; end if;

  return l_suffix_left;

END CMP_GUI_API_GIVE_SUFFIX_LEFT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_GIVE_SUFFIX_RIGHT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_GIVE_SUFFIX_RIGHT" 
( P_APP_NAME IN VARCHAR2,
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
l_suffix_right varchar2(8);
BEGIN
-- Function in order to check if a right suffix exists
--
-- IN: P_APP_NAME
-- RUN_ID a RUN ID
--
-- return  right suffix als okay
-- return "-1" = application does not exist
-- return "-2" = run id does not exist

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return '-1' ;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return '-2';
    else begin
      select right_suffix
      into l_suffix_right
      from cmp_user_param_config
      where upper(run_id)=upper(P_RUN_ID)
        and
        upper(environment)=upper(P_APP_NAME);
    end; end if;
  end; end if;

  return l_suffix_right;

END CMP_GUI_API_GIVE_SUFFIX_RIGHT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_GIVE_USER_ROLE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_GIVE_USER_ROLE" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2
) RETURN VARCHAR2 AS
-- Function gives the rolename of combination user and environment
--
-- IN: P_APP_NAME application name
-- P_USER         user name
--
-- if okay, return rolename
-- return -1 = application does not exist
-- return -2 = user does not exist
-- return -3 = user/role does not exist

    l_last_run_id number;
    l_found_role varchar2(30);
    l_cnt_role number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return '-1';
  else begin
    if (CMP_GUI_API_USER_YN(p_user)!=0) then return '-2';
    else begin
      select count(*)
      into l_cnt_role
      from cmp_user_cmp_user_roles
      where upper(username)=upper(P_USER)
            and
            upper(ENVIRONMENT)=upper(P_APP_NAME);
      if l_cnt_role=0 then return '-3';
      else begin
        select rolename
        into l_found_role
        from cmp_user_cmp_user_roles
        where upper(username)=upper(P_USER)
              and
              upper(ENVIRONMENT)=upper(P_APP_NAME);
        return l_found_role;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_GIVE_USER_ROLE;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_IMP_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_IMP_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER,
  p_run_description varchar2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
-- First step in order to prepare selection for importing baselines from source schema's
--
-- IN: P_APP_NAME = name of the application
-- P_REL_NRLL = number of the release (left)
-- P_CYC_NR_L = number of the testcycle (left)
-- P_DAY_NR_L = number of the day (left)
-- P_REL_NRLL = number of the release (right)
-- P_CYC_NR_L = number of the testcycle (right)
-- P_DAY_NR_L = number of the day (right)
-- P_RUN_DESCRIPTION = description of run
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = format rel/ cyc/ day number is not 99 99 9
-- return -3 = rel/ cyc/ day already exists
-- return -4 = application already locked
-- return -6 = TOP_IMP script not succesfull acording to cmp_user_dbms_sched_status
-- return -7 = IMP1 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN
     if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
     else begin
       if (CMP_GUI_API_SFX_FORMAT_YN(P_REL_NR, P_CYC_NR, P_DAY_NR)!=0)
       then return -2;
        else begin
         l_check_exist_app_suffix :=CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, F_FORMAT_SUFFIX(P_APP_NAME,P_REL_NR,P_CYC_NR,P_DAY_NR));
         if (l_check_exist_app_suffix=0) then return -3;
         else begin
           if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -4;
            else begin
              if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -5;
              else begin
                l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
                open c_last_run_of_param_config(P_APP_NAME);
                fetch c_last_run_of_param_config into r_user_param_config;
                close c_last_run_of_param_config;
                l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_user_param_config.run_id,P_APP_NAME,'EMPTY',UPPER(F_FORMAT_SUFFIX(P_APP_NAME,P_REL_NR,P_CYC_NR,P_DAY_NR)),p_run_description, P_USER,'EMPTY','EMPTY');

                P_CMP_MAIN_IMP_TOP(l_new_run_id);
                p_cmp_user_logging(sysdate, 'cmp_gui_api_imp_step1', to_char(l_new_run_id,'999999999999999999')||'_p1');
                l_result := F_CMP_MAIN_IMP_TOP_LOG(l_new_run_id);
                p_cmp_user_logging(sysdate, 'cmp_gui_api_imp_step1', to_char(l_result,'999999999999999999')||'_p2');

                if l_result<0 then return -6;
                else begin
                  P_CMP_DWH_MAIN_IMP_PART1(l_new_run_id);
                  l_result := F_CMP_DWH_MAIN_IMP_PART1_LOG(l_new_run_id);
                  if l_result<0 then return -7;
                  else begin
                    l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
                    return l_new_run_id;
                  end; end if;
                end; end if;
             end; end if;
           end; end if;
         end; end if;
       end; end if;
     end; end if;
END CMP_GUI_API_IMP_STEP1;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_IMP_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_IMP_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_RUN_ID IN NUMBER
) RETURN NUMBER AS
-- Second step (execution) of importing baselines from source schema
--
-- IN: P_APP_NAME
-- P_RUN_ID = run_id uit import STEP1
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = RUN ID does not exist
-- return -3 = STEP2 not successfull according to cmp_user_dbms_sched_status

    l_result number;
    l_result_temp number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(p_run_id);
      P_CMP_DWH_MAIN_IMP_PART2(P_RUN_ID);
      l_result := F_CMP_DWH_MAIN_IMP_PART2_LOG(P_RUN_ID);
      if l_result <0 then return -3;
      else begin
        l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_RUN_ID);
        l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
        return P_RUN_ID;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_IMP_STEP2;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_INS_ROL_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_INS_ROL_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
  ) RETURN NUMBER AS
-- Function for preparing execution of authorizations by users, roles and user-roles
--
-- IN: P_APP_NAME = name of the application
-- P_USER/ P_PWD = has to be the administator
--
-- return run_id = successfull
-- return -1 = application is not mother application
-- return -2 = application already locked
-- return -3 = user is not administrator
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config_rs(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_last_run_of_param_config_rs c_last_run_of_param_config_rs%rowtype;
BEGIN
  if (UPPER(P_APP_NAME)!='MMA') then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
        open c_last_run_of_param_config_rs(P_APP_NAME);
        fetch c_last_run_of_param_config_rs into r_last_run_of_param_config_rs;
        close c_last_run_of_param_config_rs;
        l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_rs.run_id,null,null,null,'adapting authorizations',P_USER,'EMPTY','EMPTY');
        P_CMP_USER_CMP_USERS_SYNC;
        P_CMP_USER_CMP_ROLES_SYNC;
        P_CMP_USER_CMP_USER_ROLES_SYNC;
        l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
        return l_new_run_id;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_INS_ROL_STEP1;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_INS_ROL_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_INS_ROL_STEP2" 
(
  P_APP_NAME IN VARCHAR2,
  P_RUN_ID IN NUMBER,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
  ) RETURN NUMBER AS
-- Function in order to execute authoriations which are specified by first step
-- IN: P_APP_NAME = name of the application
-- P_RUN_ID = run id from first step
-- P_USER/ P_PWD = has to be the administrator
--
-- return run_id = successfull
-- return -1 = application is not mother application
-- return -2 = RUN ID does not exist
-- return -3 = user not administrator
-- return -4 = TOP_INS_ROL script not succesfull acording to cmp_user_dbms_sched_status
-- return -5 = INS_ROL script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config_rs(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_last_run_of_param_config_rs c_last_run_of_param_config_rs%rowtype;
BEGIN
  if (UPPER(P_APP_NAME)!='MMA') then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_RUN_ID);
        open c_last_run_of_param_config_rs(P_APP_NAME);
        fetch c_last_run_of_param_config_rs into r_last_run_of_param_config_rs;
        close c_last_run_of_param_config_rs;
        l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_rs.run_id,null,null,null,'adapting autorizations',P_USER,'EMPTY','EMPTY');
        P_CMP_MAIN_INS_ROL_TOP(l_new_run_id, p_user, p_pwd);
        p_cmp_user_logging(sysdate, 'cmp_gui_api_ins_rol_step', to_char(l_new_run_id,'999999999999999999')||'_p1');
        l_result := F_CMP_MAIN_INS_ROL_TOP_LOG(l_new_run_id);
        p_cmp_user_logging(sysdate, 'cmp_gui_api_ins_rol_step', to_char(l_result,'999999999999999999')||'_p2');
        if l_result<0 then return -4;
        else begin
          P_CMP_DWH_MAIN_INS_ROL(l_new_run_id, p_user, p_pwd);
          l_result := F_CMP_DWH_MAIN_INS_ROL_LOG(l_new_run_id);
          if l_result<0 then return -5;
          else begin
            P_CMP_USER_CMP_USERS_SYNC;
            P_CMP_USER_CMP_ROLES_SYNC;
            P_CMP_USER_CMP_USER_ROLES_SYNC;
            l_result_temp:=CMP_GUI_API_USER_ROL_CLEAN_UP(P_USER, P_PWD);
            l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_RUN_ID);
            l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
            return l_new_run_id;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_INS_ROL_STEP2;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_LAST_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_LAST_RUN_ID" 
( P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
-- Function used for computing the most recent runid of an applicaiton
--
-- IN: P_APP_NAME
--
-- return  0 = run_id does exist
-- return -1 = run_id does not exist or there is more than one

l_check_exist_run_id number;
l_run_id number;
cursor c_last_run_of_param_config(p_c_environment VARCHAR2) is
select run_id
from cmp_user_param_config
where UPPER(p_c_environment)=UPPER(environment)
      and
      run_datetime = (select max(run_datetime)
                      from cmp_user_param_config
                      where UPPER(p_c_environment)=UPPER(environment));
r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN
  open c_last_run_of_param_config(P_APP_NAME);
  if c_last_run_of_param_config%NOTFOUND then
  begin
    close c_last_run_of_param_config;
    return -1;
  end;
  else begin
    fetch c_last_run_of_param_config into r_user_param_config;
    close c_last_run_of_param_config;
    return r_user_param_config.run_id;
  end; end if;

END CMP_GUI_API_LAST_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_LOAD_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_LOAD_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function in order to load constraints
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old sid
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = suffix left does not exist in config_param
-- return -3 = suffix right does not exist in config_param
-- return -4 = combination of suffix left, suffix right does not exist in constraints_lib
-- return -5 = no run_id for combination of suffix left, suffix right
-- return -6 = run id does not exist

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -3;
      else begin
         if (CMP_GUI_API_SFX_CONS_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT)!=0) then return -4;
         else begin
            l_found_run_id :=CMP_GUI_API_FIND_RUN_ID(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
            if (l_found_run_id<0) then return -5;
            else begin
              if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -6;
              else begin
                p_cmp_user_logging(sysdate,'cmp_gui_api_load_constraints',to_char(l_found_run_id,'9999')||' and '||to_char(P_ACTUAL_RUN_ID,'9999'));
                P_CMP_USER_CONSTRAINTS_LOAD(f_cmp_convert_run_id(l_found_run_id),f_cmp_convert_run_id(P_ACTUAL_RUN_ID));
                l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
                return P_ACTUAL_RUN_ID;
              end; end if;
            end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_LOAD_CONSTRAINTS;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_LOAD_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_LOAD_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_ACTUAL_RUN_ID =  run id
-- P_SUFFIX_RIGHT = suffux to LOAD
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = suffix right does not exist in config_param
-- return -3 = suffix right does not exist in import_lib
-- return -4 = no run_id for suffix right

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_IMP_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -3;
      else begin
        l_found_run_id :=CMP_GUI_API_FIND_RUN_ID(P_APP_NAME, 'EMPTY', P_SUFFIX_RIGHT);
        if (l_found_run_id<0) then return -4;
        else begin
          l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
          p_cmp_user_logging(sysdate,'cmp_gui_api_load_import',to_char(l_found_run_id,'999999')||' and '||to_char(P_ACTUAL_RUN_ID,'999999'));
          P_CMP_USER_SELECTION_IMP_LOAD(f_cmp_convert_run_id(l_found_run_id),f_cmp_convert_run_id(P_ACTUAL_RUN_ID));
          l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
          return P_ACTUAL_RUN_ID;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_LOAD_IMPORT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_LOCK_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_LOCK_APP" (       p_app_name varchar2
                                                 ) return number as
l_free_run_id number;
-- Function in order to lock an application
--
-- IN: P_APP_NAME
--
-- return 0 = after execution
begin
    update cmp_user_param_config
    set LOCKED_YN=1
    where upper(ENVIRONMENT)=upper(p_app_name);
  commit;
  return 0;
END CMP_GUI_API_LOCK_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_LOGO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_LOGO" 
 RETURN BLOB AS
l_temp blob;
BEGIN
  select logo
  into l_temp
  from cmp_user_logo
  where rownum<2;
  return l_temp;
END;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_MOD_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_MOD_CONFIG" 
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
  -- Function used for chaging parameters of an application
  --
  -- IN: P_APP_NAME = name of the application
  -- list of paramters of config table

  -- return run id = successfull
  -- return -1 = application does not exist
  -- return -2 = application already locked
  -- return -3 = user is not administrator
    l_new_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
        l_new_run_id := F_CMP_USER_PARAM_CONFIG_FCOPY(
                                  p_in_run_id => CMP_GUI_API_LAST_RUN_ID (P_APP_NAME),
                                  p_new_app_name => p_app_name,
                                  p_left_suffix => p_left_suffix,
                                  p_right_suffix =>  p_right_suffix,
                                  p_run_description => p_run_description,
                                  p_DB_SCHEMA => p_DB_SCHEMA,
                                  p_prefix => p_prefix,
                                  p_tablespace => p_tablespace,
                                  p_SPOOL_OUTPUT_DIR => p_SPOOL_OUTPUT_DIR,
                                  p_COMPARE_BIN_DIR => p_COMPARE_BIN_DIR,
                                  p_COMPARE_SQL_DIR => p_COMPARE_SQL_DIR,
                                  p_LEFT_SUFFIX_CLEAN => p_LEFT_SUFFIX_CLEAN,
                                  p_RIGHT_SUFFIX_CLEAN => p_RIGHT_SUFFIX_CLEAN,
                                  p_ORACLE_HOME => p_ORACLE_HOME,
                                  p_LD_LIBRARY_PATH => p_LD_LIBRARY_PATH,
                                  p_TEC_COL_1 => p_TEC_COL_1,
                                  p_TEC_COL_2 => p_TEC_COL_2,
                                  p_TEC_COL_3 => p_TEC_COL_3,
                                  p_TEC_COL_4 => p_TEC_COL_4,
                                  p_TEC_COL_5 => p_TEC_COL_5,
                                  p_TEC_COL_6 => p_TEC_COL_6,
                                  p_TEC_COL_7 => p_TEC_COL_7,
                                  p_TEC_COL_8 => p_TEC_COL_8,
                                  p_TEC_COL_9 => p_TEC_COL_9,
                                  p_TEC_COL_10 => p_TEC_COL_10,
                                  p_USER_NAME => p_USER_NAME,
                                  p_USED_BY => p_USED_BY,
                                  p_LOCKED_YN => p_LOCKED_YN,
                                  p_DB_SCHEMA_PWD => p_DB_SCHEMA_PWD,
                                  p_DB_SID => p_DB_SID,
                                  p_ext_ind => p_ext_ind,
                                  p_src_schema => p_src_schema);
        l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
        return l_new_run_id;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_MOD_CONFIG;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_NEW_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_NEW_APP" 
(
  P_NEW_APP_NAME IN VARCHAR2,
  P_CPY_APP_NAME IN VARCHAR2,
  P_RUN_DESCRIPTION IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
  -- Function for creating a new application. Default this is a copy of the mother application
  --
  -- IN: P_NEW_APP_NAME = name of the new application
  -- CPY_APP_NAME = name of an existing application, used as example
  -- P_RUN_DESCRIPTION = description of run
  -- P_USER/ P_PWD = user has to be the administrator
  --
  -- return run_id = new application has been create
  -- return -1 = new application already exists
  -- return -2 = cpy application does not exist
  -- return -3 = format of app-name is not correct
  -- return -4 = user is not administrator
    l_new_run_id number;
    l_check_exist_new_app number;
    l_check_exist_cpy_app number;
    cursor c_user_param_config(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_user_param_config c_user_param_config%rowtype;
BEGIN
     if (CMP_GUI_API_APP_EXISTS_YN(P_NEW_APP_NAME)=0) then return -1;
     else begin
      if (CMP_GUI_API_APP_EXISTS_YN(P_CPY_APP_NAME)!=0) then return -2;
       else begin
         if (CMP_GUI_API_APP_FORMAT_YN(P_NEW_APP_NAME)!=0) then return -3;
         else begin
           if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -4;
           else begin
             open c_user_param_config(P_CPY_APP_NAME);
             fetch c_user_param_config into r_user_param_config;
             close c_user_param_config;
             l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_user_param_config.run_id,upper(P_NEW_APP_NAME),'EMPTY','EMPTY',p_run_description, p_user,'EMPTY','EMPTY');
             return l_new_run_id;
           end; end if;
         end; end if;
       end; end if;
     end; end if;

END CMP_GUI_API_NEW_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_NEW_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_NEW_STEP1" 
(
  P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER IN VARCHAR2
) RETURN NUMBER AS
-- Function for executing a compare from scratch. This first step is for preparing the user selection tables.
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old sid
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = application already locked
-- return -3 = suffix left does not exist
-- return -4 = suffix right does not exist
-- return -5 = user is not authorized for the application
-- return -6 = suffix left is younger than suffix right
-- return -7 = TOP_NEW script not succesfull acording to cmp_user_dbms_sched_status
-- return -8 = STEP1 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0) then return -3;
      else begin
        if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -4;
        else begin
          if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -5;
          else begin
            if (CMP_GUI_API_SUFFIX_ORDER_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT)!=0) then return -6;
            else begin
              l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
              open c_last_run_of_param_config(P_APP_NAME);
              fetch c_last_run_of_param_config into r_user_param_config;
              close c_last_run_of_param_config;
              l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_user_param_config.run_id,P_APP_NAME,P_SUFFIX_LEFT,P_SUFFIX_RIGHT,p_run_description, P_USER,P_SUFFIX_LEFT,P_SUFFIX_RIGHT);

              P_CMP_MAIN_NEW_TOP(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step1', to_char(l_new_run_id,'999999999999999999')||'_p1');
              l_result := F_CMP_MAIN_NEW_TOP_LOG(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step1', to_char(l_result,'999999999999999999')||'_p2');

              if l_result<0 then return -7;
              else begin
                P_CMP_DWH_MAIN_NEW_PART1(l_new_run_id);
                l_result := F_CMP_DWH_MAIN_NEW_PART1_LOG(l_new_run_id);
                if l_result<0 then return -8;
                else begin
                  l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
                  return l_new_run_id;
                end; end if;
              end; end if;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_NEW_STEP1;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_NEW_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_NEW_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_RUN_ID IN NUMBER
) RETURN NUMBER AS
-- Second step of the 'from-scratch'-compare is the preperation of constraints for the user
--
-- IN: P_APP_NAME
-- P_RUN_ID = run_id from STEP1
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
-- return -3 = TOP_CON script not succesfull acording to cmp_user_dbms_sched_status
-- return -4 = CON1 script not succesfull acording to cmp_user_dbms_sched_status
    l_check_exist_app number;
    l_result number;
    l_result_temp number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_RUN_ID);
      P_CMP_MAIN_CON_TOP(P_RUN_ID);
      p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step2', to_char(P_RUN_ID,'999999999999999999')||'_p1');
      l_result := F_CMP_MAIN_CON_TOP_LOG(P_RUN_ID);
      p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step2', to_char(P_RUN_ID,'999999999999999999')||'_p2');

      if l_result<0 then return -3;
      else begin
        P_CMP_DWH_MAIN_CON_PART1(P_RUN_ID);
        l_result := F_CMP_DWH_MAIN_CON_PART1_LOG(P_RUN_ID);
       if l_result<0 then return -4;
        else begin
          l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_RUN_ID);
          return p_run_id;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_NEW_STEP2;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_NEW_STEP3
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_NEW_STEP3" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
-- The third step of the 'from-scratch' compare comprises the analysis function
--
-- IN: P_APP_NAME
-- P_RUN_ID = run_id uit NEW STEP2
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
-- return -3 = CON2 script not succesfull acording to cmp_user_dbms_sched_status
-- return -4 = TOP_CON_ANL script not succesfull acording to cmp_user_dbms_sched_status
-- return -5 = CON_ANL script not succesfull acording to cmp_user_dbms_sched_status

    l_check_exist_app number;
    l_result number;
    l_result_temp number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(p_actual_RUN_ID);
      p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step3', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_calc_fk_cols');
      P_CMP_USER_CONSTRAINTS_FK_COLS(F_CMP_CONVERT_RUN_ID(P_ACTUAL_RUN_ID));
      p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step3', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p1');
      P_CMP_DWH_MAIN_CON_PART2(P_ACTUAL_RUN_ID);
      l_result := F_CMP_DWH_MAIN_CON_PART2_LOG(P_ACTUAL_RUN_ID);
      if l_result<0 then return -3;
      else begin
        P_CMP_MAIN_CON_ANL_TOP(P_ACTUAL_RUN_ID);
        p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step3', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p2');
        l_result := F_CMP_MAIN_CON_ANL_TOP_LOG(P_ACTUAL_RUN_ID);
        if l_result<0 then return -4;
        else begin
          p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step3', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p3');
          P_CMP_DWH_MAIN_CON_ANL(P_ACTUAL_RUN_ID);
          l_result := F_CMP_DWH_MAIN_CON_ANL_LOG(P_ACTUAL_RUN_ID);
          if l_result<0 then
            return -5;
          else
            l_result_temp :=F_CMP_DATA_SWAP_FORWARD(p_actual_run_id);
            p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step3', to_char(l_result_temp,'999999999999999999')||'_p4');
            return p_actual_run_id;
          end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_NEW_STEP3;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_NEW_STEP4
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_NEW_STEP4" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
-- Function in order to execute the 'from-scratch' compare
--
-- IN: P_APP_NAME
-- P_RUN_ID = run_id from STEP3
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
-- return -3 = CON3 script not succesfull acording to cmp_user_dbms_sched_status
-- return -4 = NEW2 script not succesfull acording to cmp_user_dbms_sched_status

    l_check_exist_app number;
    l_result number;
    l_result_temp number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
      p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step4', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p1');
      P_CMP_DWH_MAIN_CON_PART3(P_ACTUAL_RUN_ID);
      l_result := F_CMP_DWH_MAIN_CON_PART3_LOG(P_ACTUAL_RUN_ID);
      if l_result<0 then return -3;
      else begin
        p_cmp_user_logging(sysdate, 'cmp_gui_api_new_step4', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p3');
        P_CMP_DWH_MAIN_NEW_PART2(P_ACTUAL_RUN_ID);
        l_result := F_CMP_DWH_MAIN_NEW_PART2_LOG(P_ACTUAL_RUN_ID);
        if l_result<0 then
          return -4;
        else
          l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
          l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
          return p_actual_run_id;
        end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_NEW_STEP4;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_OS_CHPWD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_OS_CHPWD" 
( P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  P_NEW_PWD_st IN VARCHAR2,
  P_NEW_PWD_nd IN VARCHAR2
) RETURN NUMBER AS
l_check_admin number;
  -- Function in order to change the administrator password
  --
  -- IN: user/password
  -- 2 times the new pasword
  --
  -- return  0 = password has been changed
  -- return -1 = user is no administrator
  -- return -2 = new_pwd+st and new_pwd_nd are diffrent
BEGIN
  p_cmp_user_logging(sysdate,'cmp_gui_api_os_chpwd ','-u:'||P_USER||' p:'||P_PWD||' pn1:'||P_NEW_PWD_st||' pn2:'||P_NEW_PWD_ND);
  if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -1;
  else begin
    p_cmp_user_logging(sysdate,'cmp_gui_api_os_chpwd ','YES ADMIN');
    if (p_new_pwd_st!=p_new_pwd_nd) then return -2;
    else begin
      P_CMP_CREDENTIAL(P_NEW_PWD_st);
      return 0;
    end; end if;
  end; end if;

END CMP_GUI_API_OS_CHPWD;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_RE_STEP1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_RE_STEP1" 
(
  P_APP_NAME VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2,
  P_RUN_DESCRIPTION VARCHAR2,
  P_USER VARCHAR2
) RETURN NUMBER AS
-- Prepation of user-selection for re-execution the compare based on the cmp-tables
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old sid
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = application already locked
-- return -3 = suffix left does not exist
-- return -4 = suffix right does not exist
-- return -5 = combination suffix left and suffix right does not exist
-- return -6 = user is not authorized for the application
-- return -7 = TOP_RE script not succesfull acording to cmp_user_dbms_sched_status
-- return -8 = RE STEP1 script not succesfull acording to cmp_user_dbms_sched_status
    l_new_run_id number;
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_check_app_locked number;
    l_result number;
    l_result_temp number;
    cursor c_last_run_of_param_config_sf(p_c_environment VARCHAR2, p_c_left_suffix VARCHAR2, p_c_right_suffix VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          upper(p_c_left_suffix)=upper(left_suffix)
          and
          upper(p_c_right_suffix)=upper(right_suffix)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment)
                                 and
                                 upper(p_c_left_suffix)=upper(left_suffix)
                                 and
                                 upper(p_c_right_suffix)=upper(right_suffix));
    r_last_run_of_param_config_sf c_last_run_of_param_config_sf%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_LOCKED_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0) then return -3;
      else begin
        if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -4;
        else begin
          if (CMP_GUI_API_SFX_BOTH_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT)!=0) then return -5;
          else begin
            if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -6;
            else begin
              open c_last_run_of_param_config_sf(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
              fetch c_last_run_of_param_config_sf into r_last_run_of_param_config_sf;
              close c_last_run_of_param_config_sf;
              l_result_temp :=CMP_GUI_API_LOCK_APP(P_APP_NAME);
              l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(r_last_run_of_param_config_sf.run_id,P_APP_NAME,null,null,p_run_description,p_user,'EMPTY','EMPTY');
              p_cmp_user_logging(sysdate, 'cmp_gui_api_re_step1', to_char(r_last_run_of_param_config_sf.run_id,'999999999999999999')||'_p0');
              P_CMP_MAIN_RE_TOP(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_re_step1', to_char(l_new_run_id,'999999999999999999')||'_p1');
              l_result := F_CMP_MAIN_RE_TOP_LOG(l_new_run_id);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_re_step1', to_char(l_result,'999999999999999999')||'_p2');
              if l_result<0 then return -7;
              else begin
                P_CMP_DWH_MAIN_RE_PART1(l_new_run_id);
                l_result := F_CMP_DWH_MAIN_RE_PART1_LOG(l_new_run_id);
                if l_result<0 then return -8;
                else begin
                  l_result_temp :=F_CMP_DATA_SWAP_FORWARD(l_new_run_id);
                  return l_new_run_id;
                end; end if;
              end; end if;
            end; end if;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;
END CMP_GUI_API_RE_STEP1;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_RE_STEP2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_RE_STEP2" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) RETURN NUMBER AS
-- Execution of re-compare of the cmp-tables
--
-- IN: P_APP_NAME
-- P_RUN_ID = run_id uit RE STEP1
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
-- return -3 = RE2 STEP 2 script not succesfull acording to cmp_user_dbms_sched_status

    l_check_exist_app number;
    l_result number;
    l_result_temp number;
BEGIN

  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
      p_cmp_user_logging(sysdate, 'cmp_gui_api_re_step2', to_char(P_ACTUAL_RUN_ID,'999999999999999999')||'_p1');
      P_CMP_DWH_MAIN_RE_PART2(P_ACTUAL_RUN_ID);
      l_result := F_CMP_DWH_MAIN_RE_PART2_LOG(P_ACTUAL_RUN_ID);
      if l_result<0 then
        return -3;
      else
        l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
        l_result_temp :=CMP_GUI_API_UNLOCK_APP(P_APP_NAME);
        return p_actual_run_id;
      end if;
    end; end if;
 end; end if;


END CMP_GUI_API_RE_STEP2;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_RECONVERT_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_RECONVERT_RUN_ID" 
(
  P_RUN_ID VARCHAR2
) RETURN NUMBER AS
-- Function for convert run-id from alfa to numeric
--
-- IN: P_RUN_ID
--
-- return run_id = in a numeric notation
BEGIN
  return F_CMP_RECONVERT_RUN_ID(P_RUN_ID);
END CMP_GUI_API_RECONVERT_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_REUSE_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_REUSE_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old id
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = suffix left does not exist in config_param
-- return -3 = suffix right does not exist in config_param
-- return -4 = combination of suffix left, suffix right does not exist in constraints_lib
-- return -5 = no run_id for combination of suffix left, suffix right

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -3;
      else begin
         if (CMP_GUI_API_SFX_CONS_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT)!=0) then return -4;
         else begin
            l_found_run_id :=CMP_GUI_API_FIND_RUN_ID(P_APP_NAME, P_SUFFIX_LEFT, P_SUFFIX_RIGHT);
            if (l_found_run_id<0) then return -5;
            else begin
              p_cmp_user_logging(sysdate,'cmp_gui_api_reuse_constraints',to_char(l_found_run_id,'9999')||' and '||to_char(P_ACTUAL_RUN_ID,'9999'));
              P_CMP_USER_CONSTRAINTS_REUSE(f_cmp_convert_run_id(l_found_run_id),f_cmp_convert_run_id(P_ACTUAL_RUN_ID));
              l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
              return P_ACTUAL_RUN_ID;
            end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_REUSE_CONSTRAINTS;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_REUSE_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_REUSE_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_ACTUAL_RUN_ID =  run id
-- P_SUFFIX_RIGHT = suffux to reuse
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = suffix right does not exist in config_param
-- return -3 = suffix right does not exist in import_lib
-- return -4 = no run_id for suffix right

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_IMP_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0) then return -3;
      else begin
        l_found_run_id :=CMP_GUI_API_FIND_RUN_ID(P_APP_NAME, 'EMPTY', P_SUFFIX_RIGHT);
        if (l_found_run_id<0) then return -4;
        else begin
          l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
          p_cmp_user_logging(sysdate,'cmp_gui_api_reuse_import',to_char(l_found_run_id,'999999')||' and '||to_char(P_ACTUAL_RUN_ID,'999999'));
          P_CMP_USER_SELECTION_IMP_REUSE(f_cmp_convert_run_id(l_found_run_id),f_cmp_convert_run_id(P_ACTUAL_RUN_ID));
          l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
          return P_ACTUAL_RUN_ID;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_REUSE_IMPORT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ROLE_DEL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ROLE_DEL" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
-- Function for deleting the app-specific role of an application
--
-- IN: P_APP_NAME = name of the application
-- P_USER/ P_PWD = user/pwd of the administrator
--
-- return 0 = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist
-- return -3 = user is not administrator
-- return -4 = role does not exist

    l_last_run_id number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    l_last_run_id :=CMP_GUI_API_LAST_RUN_ID(P_APP_NAME);
    if l_last_run_id <0 then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        if (CMP_GUI_API_ROLE_YN(P_APP_NAME)!=0) then return -4;
        else begin
          P_CMP_USER_CMP_ROLES_DEL(l_last_run_id);
          return 0;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_ROLE_DEL;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ROLE_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ROLE_NEW" 
(
  P_APP_NAME IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
-- Function for creation of a user specific role
--
-- IN: P_APP_NAME = name of the application
-- P_USER/P_PWD = usr/pwd of administrator
--
-- return 0 = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist
-- return -3 = user is not administrator
-- return -4 = role does already exist

    l_last_run_id number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    l_last_run_id :=CMP_GUI_API_LAST_RUN_ID(P_APP_NAME);
    if l_last_run_id <0 then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        if (CMP_GUI_API_ROLE_YN(P_APP_NAME)=0) then return -4;
        else begin
          P_CMP_USER_CMP_ROLES_NEW(l_last_run_id);
          return 0;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_ROLE_NEW;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_ROLE_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_ROLE_YN" 
(
  P_APP_NAME IN VARCHAR2
) RETURN NUMBER AS
-- Function in order to compute if application specific role exists
--
-- IN: P_APP_NAME = name of the application
--
-- return 0 = user/role does exist
-- return -1 = application does not exist
-- return -2 = user/role does not exist
    l_role_ind number;
    cursor c_last_run_of_param_config(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    open c_last_run_of_param_config(P_APP_NAME);
    fetch c_last_run_of_param_config into r_user_param_config;
    close c_last_run_of_param_config;

    select count(*)
    into l_role_ind
    from cmp_user_cmp_roles
    where upper(rolename) = upper(r_user_param_config.prefix||'_'||r_user_param_config.environment||'_TESTER');
    if l_role_ind=1 then return 0;
    else return -2;
    end if;
  end; end if;
END CMP_GUI_API_ROLE_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_RUN_ID_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_RUN_ID_EXISTS_YN" 
( P_RUN_ID IN NUMBER
) RETURN NUMBER AS
l_check_exist_run_id number;
BEGIN
-- Function in order to check of a sepcific run_id exists
--
-- IN: P_RUN_ID
--
-- return  0 = APP exists
-- return -1 = APP does not exist

  select count(*)
  into l_check_exist_run_id
  from cmp_user_param_config
  where run_id=P_RUN_ID;
  if (l_check_exist_run_id=0) then return -1; else return 0; end if;

END CMP_GUI_API_RUN_ID_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SAVE_CONSTRAINTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SAVE_CONSTRAINTS" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_DESCR VARCHAR2
) RETURN NUMBER AS
-- Function in order to save constraint definitions
--
-- IN: P_APP_NAME = name of the application
-- P_SUFFIX_LEFT = suffix for old sid
-- P_SUFFIX_RIGHT =  suffix for new side
-- P_RUN_DESCRIPTION = description of run
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = run id does not exist
    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
      P_CMP_USER_CONSTRAINTS_SAVE(f_cmp_convert_run_id(P_ACTUAL_RUN_ID), substr(P_DESCR,1,200));
      l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
      return P_ACTUAL_RUN_ID;
    end; end if;
  end; end if;

END CMP_GUI_API_SAVE_CONSTRAINTS;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SAVE_IMPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SAVE_IMPORT" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID NUMBER,
  P_DESCRIPTION VARCHAR2
) RETURN NUMBER AS
-- Function for reusing constraints from the constraint-library. The actual constraint-set will be updated but not extended.
--
-- IN: P_APP_NAME = name of the application
-- P_ACUTAL_RUN_ID =  run id
-- P_DESCRIPTION = description of run
--
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist in config_param

    l_check_exist_app number;
    l_check_exist_app_suffix number;
    l_found_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
      l_result_temp :=F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
      p_cmp_user_logging(sysdate,'cmp_gui_api_save_import',to_char(l_found_run_id,'9999')||' and '||to_char(P_ACTUAL_RUN_ID,'9999'));
      P_CMP_USER_SELECTION_IMP_SAVE(f_cmp_convert_run_id(P_ACTUAL_RUN_ID), P_DESCRIPTION);
      l_result_temp :=F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
      return P_ACTUAL_RUN_ID;
    end; end if;
  end; end if;

END CMP_GUI_API_SAVE_IMPORT;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_BOTH_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_BOTH_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_LEFT_SUFFIX VARCHAR2,
  P_RIGHT_SUFFIX VARCHAR2
) RETURN NUMBER AS
l_check_exist_suffix number;
BEGIN
-- Function in order to check if a run_id of given left_suffix and right_suffix exists
--
-- IN: P_APP_NAME = application
-- P_LEFT_SUFFIX
-- P_RIGHT_SUFFIX
--
-- return  0 = SUFFIX exists
-- return -1 = SUFFIX does not exist

  select count(*)
  into l_check_exist_suffix
  from cmp_user_param_config
  where upper(environment)=upper(P_APP_NAME)
        and
        upper(left_suffix)=upper(p_left_suffix)
        and
        upper(right_suffix)=upper(p_right_suffix);
  if (l_check_exist_suffix=0) then return -1; else return 0; end if;

END CMP_GUI_API_SFX_BOTH_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_CONS_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_CONS_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
l_check_exist_suffix number;
BEGIN
-- Function in order to check if a constraint set in the constraint library of a spefific left and right suffixes exists
--
-- IN: P_APP_NAME
-- P_SUFFIX_LEFT
-- P_SUFFIX_RIGHT
--
-- return  0 = SUFFIXES do exist
-- return -1 = SUFFIXES do not exist

  select count(*)
  into l_check_exist_suffix
  from cmp_user_constraints_lib
  where upper(p_suffix_left)=upper(left_suffix)
        and
        upper(p_suffix_right)=upper(right_suffix)
        and
        upper(P_APP_NAME)=upper(environment);
  if (l_check_exist_suffix=0) then return -1; else return 0; end if;

END CMP_GUI_API_SFX_CONS_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_FORMAT_SUFFIX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_FORMAT_SUFFIX" 
( P_APP_NAME VARCHAR2,
  P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER
) RETURN VARCHAR2 AS

BEGIN
-- Function in order to format a suffix
--
-- IN: P_APP_NAME = name of the application
-- P_REL_NR = number of release
-- P_CYC_NR = number of cycle
-- P_DAY_NR = number of day
--
-- return  0 = okay
-- return -1 = format of application name not okay
-- return -2 = application does not exist
-- return -3 = format rel/ cyc/ day number is not 99 99 9

  if (CMP_GUI_API_APP_FORMAT_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -2;
    else begin
      if (CMP_GUI_API_SFX_FORMAT_YN(P_REL_NR, P_CYC_NR, P_DAY_NR)!=0) then return -3;
      else begin
        return F_FORMAT_SUFFIX(P_APP_NAME,P_REL_NR, P_CYC_NR, P_DAY_NR);
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_SFX_FORMAT_SUFFIX;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_FORMAT_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_FORMAT_YN" 
( P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER
) RETURN NUMBER AS

BEGIN
-- Function in order to check if suffix has a valid format
--
-- IN: P_REL_NR = number of release
-- P_CYC_NR = number of cycle
-- P_DAY_NR = number of day
--
-- return  0 = format is okay
-- return -1 = format rel/ cyc/ day number is not 99 99 9

     if not ((P_REL_NR>=0) and (P_REL_NR<100) and
             (P_CYC_NR>=0) and (P_CYC_NR<100) and
             (P_DAY_NR>=0) and (P_DAY_NR<10))
     then return -1;
     else return 0;
     end if;

END CMP_GUI_API_SFX_FORMAT_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_IMP_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_IMP_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
l_check_exist_suffix number;
BEGIN
-- Function in order to check if a constraint set in the constraint library of a spefific left and right suffixes exists
--
-- IN: P_APP_NAME
-- P_SUFFIX_RIGHT
--
-- return  0 = SUFFIXES do exist
-- return -1 = SUFFIXES do not exist

  select count(*)
  into l_check_exist_suffix
  from cmp_user_import_tables_lib
  where upper(p_suffix_right)=upper(suffix)
        and
        upper(P_APP_NAME)=upper(environment);
  if (l_check_exist_suffix=0) then return -1; else return 0; end if;

END CMP_GUI_API_SFX_IMP_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SFX_R_EXISTS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SFX_R_EXISTS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX VARCHAR2
) RETURN NUMBER AS
l_check_exist_suffix number;
BEGIN
-- Function in order to check if a right suffix exists
--
-- IN: P_APP_NAME
-- P_SUFFIX
--
-- return  0 = SUFFIX exists
-- return -1 = SUFFIX does not exist

  select count(*)
  into l_check_exist_suffix
  from cmp_user_param_config
  where upper(environment)=upper(P_APP_NAME)
        and
        upper(p_suffix)=right_suffix;
  if (l_check_exist_suffix=0) then return -1; else return 0; end if;

END CMP_GUI_API_SFX_R_EXISTS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SUFFIX_ORDER_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SUFFIX_ORDER_YN" 
( P_APP_NAME IN VARCHAR2,
  P_SUFFIX_LEFT VARCHAR2,
  P_SUFFIX_RIGHT VARCHAR2
) RETURN NUMBER AS
-- Function checks if suffix left is older dan suffix right
--
-- IN: P_APP_NAME
-- P_SUFFIX_LEFT
-- P_SUFFIX_RIGHT
--
-- return  0 = SUFFIX LEFT is older than SUFFIX right
-- return -1 = application does not exist
-- return -2 = SUFFIX_LEFT does not exist
-- return -3 = SUFFIX_RIGHT does not exist
-- return -4 = SUFFIX_LEFT is younger (or equal) dan SUFFIX RIGHT

l_left_run_datetime date;
l_right_run_datetime date;
cursor c_first_run_of_param_config(p_c_environment VARCHAR2, P_C_SUFFIX_RIGHT VARCHAR2) is
select run_datetime
from cmp_user_param_config
where UPPER(p_c_environment)=UPPER(environment)
      and
      UPPER('EMPTY')=UPPER(LEFT_SUFFIX)
      and
      UPPER(P_C_SUFFIX_RIGHT)=UPPER(RIGHT_SUFFIX)
      and
      run_datetime = (select max(run_datetime)
                      from cmp_user_param_config
                      where UPPER(p_c_environment)=UPPER(environment)
                            and
                            UPPER('EMPTY')=UPPER(LEFT_SUFFIX)
                            and
                            UPPER(P_C_SUFFIX_RIGHT)=UPPER(RIGHT_SUFFIX));
r_user_param_config_left c_first_run_of_param_config%rowtype;
r_user_param_config_right c_first_run_of_param_config%rowtype;
BEGIN
  if CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0 then return -1;
  else begin
    if CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_LEFT)!=0 then return -2;
    else begin
      if CMP_GUI_API_SFX_R_EXISTS_YN(P_APP_NAME, P_SUFFIX_RIGHT)!=0 then return -3;
      else begin
        open c_first_run_of_param_config(P_APP_NAME, P_SUFFIX_LEFT);
        fetch c_first_run_of_param_config into r_user_param_config_left;
        close c_first_run_of_param_config;
        open c_first_run_of_param_config(P_APP_NAME, P_SUFFIX_RIGHT);
        fetch c_first_run_of_param_config into r_user_param_config_right;
        close c_first_run_of_param_config;
        if (r_user_param_config_left.run_datetime < r_user_param_config_right.run_datetime) then
          return 0;
        else
          return -4;
        end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_SUFFIX_ORDER_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SWAP_BACKWARD_RUN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SWAP_BACKWARD_RUN" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) return number as
-- Function in order to refresh the non-run-id specific situation
--
-- IN: P_APP_NAME = application
-- P_RUN_ID = actual run ID
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
begin
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
         return F_CMP_DATA_SWAP_BACKWARD(P_ACTUAL_RUN_ID);
    end; end if;
  end; end if;

END CMP_GUI_API_SWAP_BACKWARD_RUN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SWAP_FORWARD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SWAP_FORWARD" return number as
-- Function in order to refresh the non-run-id specific situation
--
-- IN: no arguments
--
-- return 0 = after execution
begin
  return F_CMP_DATA_SWAP_FORWARD(0);
END CMP_GUI_API_SWAP_FORWARD;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_SWAP_FORWARD_RUN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_SWAP_FORWARD_RUN" 
(
  P_APP_NAME VARCHAR2,
  P_ACTUAL_RUN_ID IN NUMBER
) return number as
-- Function in order to refresh the non-run-id specific situation
--
-- IN: P_APP_NAME = application
-- P_RUN_ID = actual run ID
--
-- return run_id = successfull
-- return -1 = APP does not exist
-- return -2 = run id does not exist
begin
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_RUN_ID_EXISTS_YN(P_ACTUAL_RUN_ID)!=0) then return -2;
    else begin
         return F_CMP_DATA_SWAP_FORWARD(P_ACTUAL_RUN_ID);
    end; end if;
  end; end if;

END CMP_GUI_API_SWAP_FORWARD_RUN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_UNLOCK_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_UNLOCK_APP" (       p_app_name varchar2
                                                 ) return number as
-- Function in order to unlock an application
--
-- IN: P_APP_NAME
--
-- return 0 = after execution
l_free_run_id number;
begin
    update cmp_user_param_config
    set LOCKED_YN=0
    where upper(ENVIRONMENT)=upper(p_app_name);
  commit;
  return 0;
END CMP_GUI_API_UNLOCK_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USE_APP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USE_APP" (    p_app_name varchar2,
                                                   p_user varchar2
                                                 ) return number as
l_free_run_id number;
-- Function in order to indicate an application as 'used by'
--
-- IN: P_APP_NAME
--
-- return 0 = after execution
-- return -1 = application does not exist
-- return -2 = user has no authorization for application
begin
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    if (CMP_GUI_API_USER_APP_ACCESS_YN(P_APP_NAME, P_USER)!=0) then return -2;
    else begin
      update cmp_user_param_config
      set used_by=upper(p_user)
      where upper(ENVIRONMENT)=upper(p_app_name);
      commit;
      return 0;
    end; end if;
  end; end if;
END CMP_GUI_API_USE_APP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_APP_ACCESS_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_APP_ACCESS_YN" 
( P_APP_NAME IN VARCHAR2,
  P_USER_NAME IN VARCHAR2
) RETURN NUMBER AS
l_app_user_access number;
BEGIN
-- Function in order to check if a user has access to an application
--
-- IN: P_APP_NAME
-- P_USER_NAME
--
-- return  0 = user has access to app
-- return -1 = user has no access to app

  select count(*)
  into l_app_user_access
  from cmp_user_cmp_user_roles
  where upper(environment)=upper(P_APP_NAME)
        and
        upper(username)=upper(P_USER_NAME);
  if (l_app_user_access=0) then return -1; else return 0; end if;

END CMP_GUI_API_USER_APP_ACCESS_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_ROL_CLEAN_UP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_ROL_CLEAN_UP" 
(
  P_USER VARCHAR2,
  P_PWD VARCHAR2
) RETURN NUMBER AS
-- Function in order to clean up rows and user-roles which already have the status DELETED
--
-- IN: P_USER/P_PWD = username/ password administrator
--
-- return 0 = okay
-- return -1 = user is not administrator
BEGIN

  if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -1;
  else begin
    P_CMP_USER_CMP_ROLES_RM(P_USER, P_PWD);
    P_CMP_USER_CMP_USER_ROLES_RM(P_USER, P_PWD);
    return 0;
  end; end if;

END CMP_GUI_API_USER_ROL_CLEAN_UP;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_ROL_SYNC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_ROL_SYNC" 
(
  P_USER VARCHAR2,
  P_PWD VARCHAR2
) RETURN NUMBER AS
-- Function for synchronisme the CMP meta-data of users and roles with the actual database
--
-- IN: P_USER/ P_PWD = username/ password administrator
--
-- return 0 = okay
-- return -1 = user is not administrator

BEGIN

  if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -1;
  else begin
    P_CMP_USER_CMP_USERS_SYNC;
    P_CMP_USER_CMP_ROLES_SYNC;
    P_CMP_USER_CMP_USER_ROLES_SYNC;
    return 0;
  end; end if;

END CMP_GUI_API_USER_ROL_SYNC;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_ROLE_DEL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_ROLE_DEL" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
-- Function in to delete a specific user-role
--
-- IN: P_APP_NAME/ P_ROLE_USER = name of the application and user to be deleted
-- P_USER/ P_PWD = usr/pwd of the adminsitrator
--
-- return run_id = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist
-- return -3 = user is not administrator
-- return -4 = user/role does not exist
    l_last_run_id number;
    role_cnt number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    l_last_run_id :=CMP_GUI_API_LAST_RUN_ID(P_APP_NAME);
    if l_last_run_id <0 then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        if (CMP_GUI_API_USER_ROLE_YN(P_APP_NAME, P_ROLE_USER)!=0) then return -4;
        else begin
          p_cmp_user_logging(sysdate, 'cmp_gui_api_user_role_del', p_role_user||' '||to_char(l_last_run_id,'999999999999999999')||'_p1');
          P_CMP_USER_CMP_USER_ROLES_DEL(p_role_user, l_last_run_id);

          select count(*)
          into role_cnt
          from cmp_user_cmp_user_roles
          where upper(environment)=upper(P_APP_NAME)
                and
                status not in ('DELETED','TO_DROP');
          if role_cnt=0 then
          begin
            p_cmp_user_logging(sysdate, 'cmp_gui_api_user_role_del', 'del role '||' '||to_char(l_last_run_id,'999999999999999999')||'_p1');
            l_result_temp :=CMP_GUI_API_ROLE_DEL(P_APP_NAME,P_USER,P_PWD);
          end; end if;
          return 0;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_USER_ROLE_DEL;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_ROLE_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_ROLE_NEW" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2,
  P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2
) RETURN NUMBER AS
-- Function for creating a application specific user/role
--
-- IN: P_APP_NAME/ P_ROLE_USER = name application and user for which role will be created
-- P_USER/P_PWD = administrator authentification
--
-- return run_id 0 = successfull
-- return -1 = application does not exist
-- return -2 = run_id does not exist
-- return -3 = user is not administrator
-- return -4 = user/role does already exist
-- return -5 = role_user does not exist

    l_last_run_id number;
    l_result_temp number;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    l_last_run_id :=CMP_GUI_API_LAST_RUN_ID(P_APP_NAME);
    if l_last_run_id <0 then return -2;
    else begin
      if (F_CMP_ADMIN_YN(p_user,p_pwd)!=0) then return -3;
      else begin
        if (CMP_GUI_API_USER_ROLE_YN(P_APP_NAME, p_role_user)=0) then return -4;
        else begin
          if (CMP_GUI_API_USER_YN(p_role_user)!=0) then return -5;
          else begin
            if CMP_GUI_API_ROLE_YN(P_APP_NAME)=-2 then
            begin
              l_result_temp := CMP_GUI_API_ROLE_NEW(P_APP_NAME, P_USER, P_PWD);
              p_cmp_user_logging(sysdate, 'cmp_gui_api_user_role_new', 'make new role'||to_char(l_last_run_id,'999999999999999999')||'_p1');
            end; end if;
            p_cmp_user_logging(sysdate, 'cmp_gui_api_user_role_new', p_role_user||' '||to_char(l_last_run_id,'999999999999999999')||'_p2');
            P_CMP_USER_CMP_USER_ROLES_NEW(p_role_user, l_last_run_id);
            return 0;
          end; end if;
        end; end if;
      end; end if;
    end; end if;
  end; end if;

END CMP_GUI_API_USER_ROLE_NEW;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_ROLE_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_ROLE_YN" 
(
  P_APP_NAME IN VARCHAR2,
  P_ROLE_USER IN VARCHAR2
) RETURN NUMBER AS
-- Function for checking if aplication specific user/role exists
--
-- IN: P_APP_NAME = name of the application
-- P_ROLE_USER = name of the user
--
-- return run_id = successfull
-- return 0 = user/role does exist
-- return -1 = appliciation does not exist
-- return -2 = user/role does not exist
    l_user_role_ind number;
    cursor c_last_run_of_param_config(p_c_environment VARCHAR2) is
    select *
    from cmp_user_param_config
    where upper(p_c_environment)=upper(environment)
          and
          run_datetime = (select max(run_datetime)
                          from cmp_user_param_config
                           where upper(p_c_environment)=upper(environment));
    r_user_param_config c_last_run_of_param_config%rowtype;
BEGIN
  if (CMP_GUI_API_APP_EXISTS_YN(P_APP_NAME)!=0) then return -1;
  else begin
    open c_last_run_of_param_config(P_APP_NAME);
    fetch c_last_run_of_param_config into r_user_param_config;
    close c_last_run_of_param_config;

    select count(*)
    into l_user_role_ind
    from cmp_user_cmp_user_roles
    where upper(username)=upper(P_ROLE_USER)
          and
          upper(rolename)=upper(r_user_param_config.prefix||'_'||r_user_param_config.environment||'_TESTER');
    if l_user_role_ind=1 then return 0;
    else return -2;
    end if;
  end; end if;

END CMP_GUI_API_USER_ROLE_YN;
/
--------------------------------------------------------
--  DDL for Function CMP_GUI_API_USER_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CMP_GUI_API_USER_YN" 
(
  P_USERNAME IN VARCHAR2
) RETURN NUMBER AS
-- Function for checking if user exists in system; not necessary to be cmp_user
--
-- IN: P_USERNAME = name of the application
--
-- return 0 = user does exist
-- return -1 = user does not exist
    l_user_ind number;
BEGIN
    select count(*)
    into l_user_ind
    from cmp_user_cmp_users
    where upper(username) = upper(p_username);
    if l_user_ind=1 then return 0;
    else return -1;
    end if;

END CMP_GUI_API_USER_YN;
/
--------------------------------------------------------
--  DDL for Function F_CMP_ADMIN_CHPWD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_ADMIN_CHPWD" 
( P_USER IN VARCHAR2,
  P_PWD IN VARCHAR2,
  P_NEW_PWD_st IN VARCHAR2,
  P_NEW_PWD_nd IN VARCHAR2
) RETURN NUMBER AS
l_check_admin number;
BEGIN
  -- return  0 = user is administrator
  -- return -1 = user is no administrator
  if (p_new_pwd_st!=p_new_pwd_nd) then return -2;
  else begin
    update cmp_user_administrator set password=P_NEW_PWD_st
    where username = P_USER;
    return -0;
  end; end if;
END f_cmp_admin_chpwd;
/
--------------------------------------------------------
--  DDL for Function F_CMP_ADMIN_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_ADMIN_YN" 
( P_USER IN VARCHAR2,
  P_PASSWORD IN VARCHAR2
) RETURN NUMBER AS
l_check_admin number;
BEGIN
  -- return  0 = user is administrator
  -- return -1 = user is no administrator

  --p_cmp_user_logging(sysdate, 'f_cmp_administrator_YN', '---');
  select count(*)
  into l_check_admin
  from cmp_user_administrator
  where upper(username)=upper(P_USER)
        and
        upper(password)=upper(P_PASSWORD);
  if (l_check_admin=1) then return 0; else return -1; end if;

END F_CMP_ADMIN_YN;
/
--------------------------------------------------------
--  DDL for Function F_CMP_CONVERT_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_CONVERT_RUN_ID" 
(
  P_RUN_ID NUMBER
) RETURN VARCHAR2 AS
BEGIN
  return replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(to_char(P_RUN_ID),'0','A'),'1','B'),'2','C'),'3','D'),'4','E'),'5','F'),'6','G'),'7','H'),'8','I'),'9','J');
END F_CMP_CONVERT_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_C_COLUMN_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_C_COLUMN_DIFF" 
(
  P_VAL1 VARCHAR2,
  P_VAL2 VARCHAR2
) RETURN VARCHAR2 AS
l_type varchar2(4000 CHAR);
i NUMBER;
diff_pos NUMBER;
from_pos NUMBER;
to_pos NUMBER;
found number(1);
window number;
BEGIN
  window :=5;
  found :=0;
  i:=0;
  diff_pos:=0;
  while (found=0 and i<4000) loop
    i:=i+1;
    if nvl(substr(p_val1,i,1),'^')!=nvl(substr(p_val2,i,1),'^') then
      diff_pos :=i;
      if diff_pos<= 5 then from_pos :=1; else from_pos :=diff_pos-window; end if;
      if diff_pos>= 3995 then to_pos :=100; else to_pos :=diff_pos+window; end if;
      found:=1;
    end if;
  end loop;
  --l_type:=to_char(from_pos,'9999')||'-'||to_char(diff_pos,'9999')||'-'||to_char(to_pos,'9999');
  l_type :=nvl(substr(p_val1,from_pos,(to_pos-from_pos)+1),'NULL')||' versus '||nvl(substr(p_val2,from_pos,(to_pos-from_pos)+1),'NULL');
  if not(p_val1 is NULL)
     and
     not(p_val2 is NULL)
     and
     (abs(nvl(length(p_val1),0)-nvl(length(p_val2),0))>0) then l_type :=l_type||' (length difference)'; end if;
  return l_type;
END F_CMP_DATA_C_COLUMN_DIFF;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_D_COLUMN_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_D_COLUMN_DIFF" 
(
  P_VAL1 DATE,
  P_VAL2 DATE
) RETURN VARCHAR2 AS
l_type varchar2(4000 CHAR);
BEGIN
  l_type :=nvl(to_char(p_val1,'DD.MM.YYYY HH24:MI:SS'),'NULL')||' versus '||nvl(to_char(p_val2,'DD.MM.YYYY HH24:MI:SS'),'NULL');
  return l_type;
END F_CMP_DATA_D_COLUMN_DIFF;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_N_COLUMN_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_N_COLUMN_DIFF" 
(
  P_VAL1 NUMBER,
  P_VAL2 NUMBER
) RETURN VARCHAR2 AS
l_type varchar2(4000 CHAR);
BEGIN
  l_type :=nvl(to_char(p_val1,'999,999,999.99999'),'NULL')||' versus '||nvl(to_char(p_val2,'999,999,999.99999'),'NULL');
  return l_type;
END F_CMP_DATA_N_COLUMN_DIFF;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_SWAP_BACKWARD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_SWAP_BACKWARD" 
(
  P_RUN_ID NUMBER
) RETURN NUMBER AS
BEGIN

 begin

  delete from CMP_USER_CONSTRAINTS where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into CMP_USER_CONSTRAINTS (TAB, COL, UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL,
                                                 NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, RUN_ID)
         select TAB, COL, UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL,
                NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, RUN_ID
         from APP_APX_TEST.SWP_USER_CONSTRAINTS where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from CMP_USER_CONSTRAINTS_ANL where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into CMP_USER_CONSTRAINTS_ANL (TAB, COL, POS, MAXPOS, UNQ_CONS, UNQ_CONS_ID, TEC_UNQ_CONS,
              TEC_UNQ_CONS_ID, FK_CONS, FK_CONS_ID, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, ANL_UNQCONS_NEXISTS_LYN,
              ANL_UNQCONS_UNIQUE_LYN, ANL_UNQCONS_NULL_LYN, ANL_TECUNQ_DUBBEL_LYN, ANL_TECUNQ_CONS_UNIQUE_LYN,
              ANL_TECUNQ_CONS_INTSEC_LYN, ANL_FKCONS_WITHOUT_LYN, ANL_ONLYCOL_L, ANL_UNQCONS_NEXISTS_RYN, ANL_UNQCONS_UNIQUE_RYN,
              ANL_UNQCONS_NULL_RYN, ANL_TECUNQ_DUBBEL_RYN, ANL_TECUNQ_CONS_UNIQUE_RYN, ANL_TECUNQ_CONS_INTSEC_RYN,
              ANL_FKCONS_WITHOUT_RYN, ANL_ONLYCOL_R, RUN_ID, ANL_DATATYPE_DIFF_LNY, ANL_DATATYPE_DIFF_RNY,
              ANL_FKCONS_WITHOUT_DATA_LYN, ANL_FKCONS_WITHOUT_DATA_RYN, ANL_TECUNQ_NULL_LYN, ANL_TECUNQ_NULL_RYN)
         select TAB, COL, POS, MAXPOS, UNQ_CONS, UNQ_CONS_ID, TEC_UNQ_CONS,
              TEC_UNQ_CONS_ID, FK_CONS, FK_CONS_ID, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, ANL_UNQCONS_NEXISTS_LYN,
              ANL_UNQCONS_UNIQUE_LYN, ANL_UNQCONS_NULL_LYN, ANL_TECUNQ_DUBBEL_LYN, ANL_TECUNQ_CONS_UNIQUE_LYN,
              ANL_TECUNQ_CONS_INTSEC_LYN, ANL_FKCONS_WITHOUT_LYN, ANL_ONLYCOL_L, ANL_UNQCONS_NEXISTS_RYN, ANL_UNQCONS_UNIQUE_RYN,
              ANL_UNQCONS_NULL_RYN, ANL_TECUNQ_DUBBEL_RYN, ANL_TECUNQ_CONS_UNIQUE_RYN, ANL_TECUNQ_CONS_INTSEC_RYN,
              ANL_FKCONS_WITHOUT_RYN, ANL_ONLYCOL_R, RUN_ID, ANL_DATATYPE_DIFF_LNY, ANL_DATATYPE_DIFF_RNY,
              ANL_FKCONS_WITHOUT_DATA_LYN, ANL_FKCONS_WITHOUT_DATA_RYN, ANL_TECUNQ_NULL_LYN, ANL_TECUNQ_NULL_RYN
         from APP_APX_TEST.SWP_USER_CONSTRAINTS_ANL
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from CMP_USER_IMPORT_TABLES where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into CMP_USER_IMPORT_TABLES (SRC_TAB, IN_SCOPE, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, NOMATCH_YN, NOT_UNIQUE_YN, DST_TAB_TOO_LONG_YN, RUN_ID)
         select SRC_TAB, IN_SCOPE, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, NOMATCH_YN, NOT_UNIQUE_YN, DST_TAB_TOO_LONG_YN, RUN_ID
         from APP_APX_TEST.SWP_USER_IMPORT_TABLES
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from CMP_USER_SELECTION_TABLES where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into CMP_USER_SELECTION_TABLES (TAB, IN_SCOPE, ORDER_ASCENDING, RUN_ID)
         select TAB, IN_SCOPE, ORDER_ASCENDING, RUN_ID
         from APP_APX_TEST.SWP_USER_SELECTION_TABLES
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  commit;
  p_cmp_user_logging(sysdate,'f_cmp_data_swap_backward',' p1');
  return 0;

end;

END F_CMP_DATA_SWAP_BACKWARD;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_SWAP_FORWARD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_SWAP_FORWARD" 
(
  P_RUN_ID NUMBER
) RETURN NUMBER AS
BEGIN

begin
  delete from APP_APX_TEST.SWP_USER_CMP_ROLES;
  insert into APP_APX_TEST.SWP_USER_CMP_ROLES (ENVIRONMENT, ROLENAME, STATUS)
         select ENVIRONMENT, ROLENAME, STATUS
         from CMP_USER_CMP_ROLES;

  delete from APP_APX_TEST.SWP_USER_CMP_USER_ROLES;
  insert into APP_APX_TEST.SWP_USER_CMP_USER_ROLES (ROLENAME, USERNAME, STATUS, ENVIRONMENT)
         select ROLENAME, USERNAME, STATUS, ENVIRONMENT
         from CMP_USER_CMP_USER_ROLES;

  delete from APP_APX_TEST.SWP_USER_CMP_USERS;
  insert into APP_APX_TEST.SWP_USER_CMP_USERS (USERNAME, CMP_USER_YN)
         select USERNAME, CMP_USER_YN
         from CMP_USER_CMP_USERS;

  delete from APP_APX_TEST.SWP_USER_CONSTRAINTS where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into APP_APX_TEST.SWP_USER_CONSTRAINTS (TAB, COL, UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL,
                                                 NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, RUN_ID)
         select TAB, COL, UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL,
                NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, RUN_ID
         from CMP_USER_CONSTRAINTS where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from APP_APX_TEST.SWP_USER_CONSTRAINTS_ANL where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into APP_APX_TEST.SWP_USER_CONSTRAINTS_ANL (TAB, COL, POS, MAXPOS, UNQ_CONS, UNQ_CONS_ID, TEC_UNQ_CONS,
              TEC_UNQ_CONS_ID, FK_CONS, FK_CONS_ID, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, ANL_UNQCONS_NEXISTS_LYN,
              ANL_UNQCONS_UNIQUE_LYN, ANL_UNQCONS_NULL_LYN, ANL_TECUNQ_DUBBEL_LYN, ANL_TECUNQ_CONS_UNIQUE_LYN,
              ANL_TECUNQ_CONS_INTSEC_LYN, ANL_FKCONS_WITHOUT_LYN, ANL_ONLYCOL_L, ANL_UNQCONS_NEXISTS_RYN, ANL_UNQCONS_UNIQUE_RYN,
              ANL_UNQCONS_NULL_RYN, ANL_TECUNQ_DUBBEL_RYN, ANL_TECUNQ_CONS_UNIQUE_RYN, ANL_TECUNQ_CONS_INTSEC_RYN,
              ANL_FKCONS_WITHOUT_RYN, ANL_ONLYCOL_R, RUN_ID, ANL_DATATYPE_DIFF_LNY, ANL_DATATYPE_DIFF_RNY,
              ANL_FKCONS_WITHOUT_DATA_LYN, ANL_FKCONS_WITHOUT_DATA_RYN, ANL_TECUNQ_NULL_LYN, ANL_TECUNQ_NULL_RYN)
         select TAB, COL, POS, MAXPOS, UNQ_CONS, UNQ_CONS_ID, TEC_UNQ_CONS,
              TEC_UNQ_CONS_ID, FK_CONS, FK_CONS_ID, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, ANL_UNQCONS_NEXISTS_LYN,
              ANL_UNQCONS_UNIQUE_LYN, ANL_UNQCONS_NULL_LYN, ANL_TECUNQ_DUBBEL_LYN, ANL_TECUNQ_CONS_UNIQUE_LYN,
              ANL_TECUNQ_CONS_INTSEC_LYN, ANL_FKCONS_WITHOUT_LYN, ANL_ONLYCOL_L, ANL_UNQCONS_NEXISTS_RYN, ANL_UNQCONS_UNIQUE_RYN,
              ANL_UNQCONS_NULL_RYN, ANL_TECUNQ_DUBBEL_RYN, ANL_TECUNQ_CONS_UNIQUE_RYN, ANL_TECUNQ_CONS_INTSEC_RYN,
              ANL_FKCONS_WITHOUT_RYN, ANL_ONLYCOL_R, RUN_ID, ANL_DATATYPE_DIFF_LNY, ANL_DATATYPE_DIFF_RNY,
              ANL_FKCONS_WITHOUT_DATA_LYN, ANL_FKCONS_WITHOUT_DATA_RYN, ANL_TECUNQ_NULL_LYN, ANL_TECUNQ_NULL_RYN
         from CMP_USER_CONSTRAINTS_ANL
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from APP_APX_TEST.SWP_USER_CONSTRAINTS_LIB;
  insert into APP_APX_TEST.SWP_USER_CONSTRAINTS_LIB (ENVIRONMENT, DB_SCHEMA, PREFIX, LEFT_SUFFIX, RIGHT_SUFFIX, TAB, COL,
              UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, DESCRIPTION)
         select ENVIRONMENT, DB_SCHEMA, PREFIX, LEFT_SUFFIX, RIGHT_SUFFIX, TAB, COL,
              UNQ_CONS, TEC_UNQ_CONS, FK_CONS, FK_TAB, FK_COL, EXCLUDE_COL, NON_STND_TEC_COL, LEFT_COL_IND, RIGHT_COL_IND, DESCRIPTION
         from CMP_USER_CONSTRAINTS_LIB;

  delete from APP_APX_TEST.SWP_USER_DBMS_SCHED_STATUS;
  insert into APP_APX_TEST.SWP_USER_DBMS_SCHED_STATUS (STATUS, ERR_MSG, JOB_NAME, LOG_DATE)
         select STATUS, ERR_MSG, JOB_NAME, LOG_DATE
         from CMP_USER_DBMS_SCHED_STATUS
         where job_name is not null;

  delete from APP_APX_TEST.SWP_USER_IMPORT_TABLES where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into APP_APX_TEST.SWP_USER_IMPORT_TABLES (SRC_TAB, IN_SCOPE, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, NOMATCH_YN, NOT_UNIQUE_YN, DST_TAB_TOO_LONG_YN, RUN_ID)
         select SRC_TAB, IN_SCOPE, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, NOMATCH_YN, NOT_UNIQUE_YN, DST_TAB_TOO_LONG_YN, RUN_ID
         from CMP_USER_IMPORT_TABLES
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  delete from APP_APX_TEST.SWP_USER_IMPORT_TABLES_LIB;
  insert into APP_APX_TEST.SWP_USER_IMPORT_TABLES_LIB (ENVIRONMENT, DB_SCHEMA, SRC_SCHEMA, SUFFIX, SRC_TAB, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, DESCRIPTION)
         select ENVIRONMENT, DB_SCHEMA, SRC_SCHEMA, SUFFIX, SRC_TAB, DST_TAB_PREFIX, DST_TAB_BODY, DST_TAB_SUFFIX, DESCRIPTION
         from CMP_USER_IMPORT_TABLES_LIB;

  delete from APP_APX_TEST.SWP_USER_PARAM_CONFIG;
  insert into APP_APX_TEST.SWP_USER_PARAM_CONFIG (RUN_DATETIME, RUN_ID, RUN_DESCRIPTION, ENVIRONMENT, DB_SCHEMA, PREFIX,
              TABLESPACE, LEFT_SUFFIX, RIGHT_SUFFIX, SPOOL_OUTPUT_DIR, COMPARE_BIN_DIR, COMPARE_SQL_DIR, LEFT_SUFFIX_CLEAN,
              RIGHT_SUFFIX_CLEAN, ORACLE_HOME, LD_LIBRARY_PATH, TEC_COL_1, TEC_COL_2, TEC_COL_3, TEC_COL_4, TEC_COL_5,
              TEC_COL_6, TEC_COL_7, TEC_COL_8, TEC_COL_9, TEC_COL_10, LOCKED_YN, DB_SCHEMA_PWD, DB_SID, SRC_SCHEMA, USED_BY, EXT_IND)
         select RUN_DATETIME, RUN_ID, RUN_DESCRIPTION, ENVIRONMENT, DB_SCHEMA, PREFIX,
         TABLESPACE, LEFT_SUFFIX, RIGHT_SUFFIX, SPOOL_OUTPUT_DIR, COMPARE_BIN_DIR, COMPARE_SQL_DIR, LEFT_SUFFIX_CLEAN,
         RIGHT_SUFFIX_CLEAN, ORACLE_HOME, LD_LIBRARY_PATH, TEC_COL_1, TEC_COL_2, TEC_COL_3, TEC_COL_4, TEC_COL_5,
         TEC_COL_6, TEC_COL_7, TEC_COL_8, TEC_COL_9, TEC_COL_10, LOCKED_YN, DB_SCHEMA_PWD, DB_SID, SRC_SCHEMA, USED_BY, EXT_IND
         from CMP_USER_PARAM_CONFIG;

  delete from APP_APX_TEST.SWP_USER_SELECTION_TABLES where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;
  insert into APP_APX_TEST.SWP_USER_SELECTION_TABLES (TAB, IN_SCOPE, ORDER_ASCENDING, RUN_ID)
         select TAB, IN_SCOPE, ORDER_ASCENDING, RUN_ID
         from CMP_USER_SELECTION_TABLES
         where CMP_GUI_API_RECONVERT_RUN_ID(run_id)=p_run_id;

  commit;
  p_cmp_user_logging(sysdate,'f_cmp_data_swap_forward',' run_id:'||to_char(p_run_id,'999999999999999999'));
  return 0;

end;

END F_CMP_DATA_SWAP_FORWARD;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DATA_TYPE_COLUMN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DATA_TYPE_COLUMN" 
(
  P_TABLE_NAME VARCHAR2,
  P_COLUMN_NAME VARCHAR2,
  P_LEFT VARCHAR2,
  P_RIGHT VARCHAR2
) RETURN VARCHAR2 AS
l_datatype varchar2(4000 CHAR);
BEGIN
  select decode(substr(data_type,1,1),'V','F_CMP_DATA_C_COLUMN_DIFF('||p_left||'.'||P_COLUMN_NAME||','||p_right||'.'||P_COLUMN_NAME||')',
                                      'C','F_CMP_DATA_C_COLUMN_DIFF('||p_left||'.'||P_COLUMN_NAME||','||p_right||'.'||P_COLUMN_NAME||')',
                                      'N','F_CMP_DATA_N_COLUMN_DIFF('||p_left||'.'||P_COLUMN_NAME||','||p_right||'.'||P_COLUMN_NAME||')',
                                      'D','F_CMP_DATA_D_COLUMN_DIFF('||p_left||'.'||P_COLUMN_NAME||','||p_right||'.'||P_COLUMN_NAME||')',
                                      chr(39)||'not equal'||chr(39))
  into l_datatype
  from user_tab_cols
  where table_name=p_table_name
      and
      column_name=p_column_name;
  return l_datatype;
END F_CMP_DATA_TYPE_COLUMN;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CLN_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CLN_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
    l_os_mode :=unix_give_os_mode;
    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_PART1');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_cln_part1_log', p_job_name||'_q3');

    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_cln_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

END F_CMP_DWH_MAIN_CLN_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CLR_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CLR_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_CLR_PART1');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_CLR_part1_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_CLR_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_CLR_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CON_ANL_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CON_ANL_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_CON_ANL');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_anl_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_anl_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_CON_ANL_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CON_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CON_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART1');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_part1_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_CON_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CON_PART2_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CON_PART2_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART2');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_PART2_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_PART2_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_CON_PART2_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CON_PART3_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CON_PART3_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART3');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_PART3_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_PART3_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_CON_PART3_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CRT_VIEW_1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CRT_VIEW_1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
    l_os_mode :=unix_give_os_mode;
    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_PART1');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_1_log', p_job_name||'_q3');

    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

END F_CMP_DWH_MAIN_CRT_VIEW_1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_CRT_VIEW_2_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_CRT_VIEW_2_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
    l_os_mode :=unix_give_os_mode;
    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_PART2');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_2_log', p_job_name||'_q3');

    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_2_log', nvl(r_job_status.status,'EMPTY')||'_q4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

END F_CMP_DWH_MAIN_CRT_VIEW_2_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_IMP_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_IMP_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART1');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_imp_part1_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_imp_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_IMP_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_IMP_PART2_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_IMP_PART2_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 10;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART2');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_imp_part2_log', p_job_name||'_r3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, nvl(r_job_status.status,'EMPTY')||'_r4', p_job_name||'_r3');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_IMP_PART2_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_INS_ROL_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_INS_ROL_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 5;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_INS_ROL');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_ins_rol_log', p_job_name||'_q1');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_ins_rol_log', nvl(r_job_status.status,'EMPTY')||'_q2');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_INS_ROL_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_NEW_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_NEW_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART1');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_part1_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_NEW_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_NEW_PART2_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_NEW_PART2_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 10;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART2');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_part2_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_part2_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
  begin
    begin
      dbms_scheduler.stop_job(r_job_status.job_name, force => TRUE);
      dbms_scheduler.disable(r_job_status.job_name, force => TRUE);
    exception
      when others then null;
    end;
    return 0;
  end;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_NEW_PART2_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_RE_PART1_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_RE_PART1_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART1');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_part1_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_part1_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
    return 0;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_RE_PART1_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_DWH_MAIN_RE_PART2_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_DWH_MAIN_RE_PART2_LOG" (p_run_id NUMBER) return NUMBER
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 10;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
  p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART2');

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_part2_log', p_job_name||'_q3');

  delete from cmp_user_dbms_sched_status
  where job_name=p_job_name;
  commit;

  l_cnt :=0;
  WHILE l_cnt<l_max_loop
  LOOP
    dbms_lock.sleep(l_wait_seconds);
    open c_job_status(p_job_name);
    fetch c_job_status into r_job_status;
    l_cnt :=l_cnt+1;
    if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
    close c_job_status;
  END LOOP;

  p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_part2_log', nvl(r_job_status.status,'EMPTY')||'_q4');

  insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
  values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
  commit;

  if r_job_status.status='SUCCEEDED' then
  begin
    begin
      dbms_scheduler.stop_job(r_job_status.job_name, force => TRUE);
      dbms_scheduler.disable(r_job_status.job_name, force => TRUE);
    exception
      when others then null;
    end;
    return 0;
  end;
  else
    return -1;
  end if;

END F_CMP_DWH_MAIN_RE_PART2_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_CLN_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_CLN_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_cln_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_cln_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_CLN_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_CLR_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_CLR_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CLR_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_CLR_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_CLR_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_CLR_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_CON_ANL_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_CON_ANL_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CON_ANL_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_anl_top_log',p_job_name||'_p1');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_anl_top_log',nvl(r_job_status.status,'EMPTY')||'_p2');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

   end;
  else
    return 0;
  end if;

END F_CMP_MAIN_CON_ANL_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_CON_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_CON_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CON_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_con_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_CON_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_CRT_VIEW_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_CRT_VIEW_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_crt_view_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_CRT_VIEW_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_IMP_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_IMP_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_imp_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_imp_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_IMP_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_INS_ROL_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_INS_ROL_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin


    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_INS_ROL_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_ins_rol_top_log',p_job_name||'_p1');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_anl_top_log',nvl(r_job_status.status,'EMPTY')||'_p2');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

   end;
  else
    return 0;
  end if;

END F_CMP_MAIN_INS_ROL_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_NEW_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_NEW_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_new_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_NEW_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_MAIN_RE_TOP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_MAIN_RE_TOP_LOG" (p_run_id varchar2) return number
is
-- P_RUN_ID - run_id of job
--
-- return
-- 0 okay
-- -1 job has not succeeded
--
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
l_cnt number;
l_max_loop number default 10000;
l_wait_seconds number default 3;
cursor c_job_status(p_c_job_name varchar2) is
select status, additional_info, job_name, log_date
  from user_scheduler_job_run_details
  where job_name=p_c_job_name
        and
        log_date= (select max(log_date)
                   from user_scheduler_job_run_details
                   where job_name=p_c_job_name);
r_job_status c_job_status%rowtype;
l_os_mode varchar2(10);
BEGIN

  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX' then
  begin

    p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
    p_job_name :=UPPER(p_run_char_id||'_CMP_RESTART_TOP');

    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_top_log',p_job_name||'_p3');


    delete from cmp_user_dbms_sched_status
    where job_name=p_job_name;
    commit;

    l_cnt :=0;
    WHILE l_cnt<l_max_loop
    LOOP
      dbms_lock.sleep(l_wait_seconds);
      open c_job_status(p_job_name);
      fetch c_job_status into r_job_status;
      l_cnt :=l_cnt+1;
      if nvl(r_job_status.status,'EMPTY')!='EMPTY' then l_cnt:=l_max_loop; end if;
      close c_job_status;
    END LOOP;


    p_cmp_user_logging(sysdate, 'f_cmp_dwh_main_re_top_log',nvl(r_job_status.status,'EMPTY')||'_p4');

    insert into cmp_user_dbms_sched_status(status, err_msg, job_name, log_date)
    values (r_job_status.status, r_job_status.additional_info,r_job_status.job_name, r_job_status.log_date);
    commit;

    if r_job_status.status='SUCCEEDED' then
      return 0;
    else
      return -1;
    end if;

  end;
  else
    return 0;
  end if;

END F_CMP_MAIN_RE_TOP_LOG;
/
--------------------------------------------------------
--  DDL for Function F_CMP_RECONVERT_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_RECONVERT_RUN_ID" 
(
  P_RUN_ID VARCHAR2
) RETURN NUMBER AS
BEGIN
  return replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(to_char(P_RUN_ID),'A','0'),'B','1'),'C','2'),'D','3'),'E','4'),'F','5'),'G','6'),'H','7'),'I','8'),'J','9');
END F_CMP_RECONVERT_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function F_CMP_USER_PARAM_CONFIG_COPY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_USER_PARAM_CONFIG_COPY" (p_in_run_id number,
                                                         p_new_app_name varchar2,
                                                         p_left_suffix varchar2,
                                                         p_right_suffix varchar2,
                                                         p_run_description varchar2,
                                                         p_user_name varchar2,
                                                         p_left_suffix_clean varchar2,
                                                         p_right_suffix_clean varchar2) return number as
l_free_run_id number;
begin
                       return     F_CMP_USER_PARAM_CONFIG_FCOPY(
                                  p_in_run_id => p_in_run_id,
                                  p_new_app_name => p_new_app_name,
                                  p_left_suffix => p_left_suffix,
                                  p_right_suffix =>  p_right_suffix,
                                  p_run_description => p_run_description,
                                  p_DB_SCHEMA => null,
                                  p_prefix => null,
                                  p_tablespace => null,
                                  p_SPOOL_OUTPUT_DIR => null,
                                  p_COMPARE_BIN_DIR => null,
                                  p_COMPARE_SQL_DIR => null,
                                  p_LEFT_SUFFIX_CLEAN => p_LEFT_SUFFIX_CLEAN,
                                  p_RIGHT_SUFFIX_CLEAN => p_RIGHT_SUFFIX_CLEAN,
                                  p_ORACLE_HOME => null,
                                  p_LD_LIBRARY_PATH => null,
                                  p_TEC_COL_1 => null,
                                  p_TEC_COL_2 => null,
                                  p_TEC_COL_3 => null,
                                  p_TEC_COL_4 => null,
                                  p_TEC_COL_5 => null,
                                  p_TEC_COL_6 => null,
                                  p_TEC_COL_7 => null,
                                  p_TEC_COL_8 => null,
                                  p_TEC_COL_9 => null,
                                  p_TEC_COL_10 => null,
                                  p_USER_NAME => p_user_name,
                                  p_used_by => null,
                                  p_LOCKED_YN => null,
                                  p_DB_SCHEMA_PWD => null,
                                  p_DB_SID => null,
                                  p_ext_ind => null,
                                  p_src_schema => null);
END F_CMP_USER_PARAM_CONFIG_COPY;
/
--------------------------------------------------------
--  DDL for Function F_CMP_USER_PARAM_CONFIG_FCOPY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_USER_PARAM_CONFIG_FCOPY" (p_in_run_id number,
                                                       p_new_app_name varchar2,
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
                                                       p_user_name varchar2,
                                                       p_used_by varchar2,
                                                       p_LOCKED_YN number,
                                                       p_DB_SCHEMA_PWD varchar2,
                                                       p_DB_SID varchar2,
                                                       p_ext_ind varchar2,
                                                       p_src_schema varchar2) return number as
l_free_run_id number;
begin
  declare
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select *
    from cmp_user_param_config
    where p_c_run_id=run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
     select F_FREE_RUN_ID
     into l_free_run_id
     from dual;
     open c_user_param_config(p_in_run_id);
     fetch c_user_param_config into r_user_param_config;
     close c_user_param_config;
     p_cmp_user_logging(sysdate,'f_cmp_user_param_config_fcopy ','p1');
     insert into cmp_user_param_config
      (RUN_DATETIME,
	     RUN_ID,
	     RUN_DESCRIPTION,
	     ENVIRONMENT,
	     DB_SCHEMA,
	     PREFIX,
	     TABLESPACE,
	     LEFT_SUFFIX,
	     RIGHT_SUFFIX,
	     SPOOL_OUTPUT_DIR,
	     COMPARE_BIN_DIR,
	     COMPARE_SQL_DIR,
	     LEFT_SUFFIX_CLEAN,
	     RIGHT_SUFFIX_CLEAN,
       ORACLE_HOME,
	     LD_LIBRARY_PATH,
	     TEC_COL_1,
	     TEC_COL_2,
	     TEC_COL_3,
	     TEC_COL_4,
	     TEC_COL_5,
	     TEC_COL_6,
	     TEC_COL_7,
	     TEC_COL_8,
	     TEC_COL_9,
	     TEC_COL_10,
       USER_NAME,
       USED_BY,
       LOCKED_YN,
       DB_SCHEMA_PWD,
       DB_SID,
       ext_ind,
       src_schema)
       values
       (sysdate,
	     l_free_run_id,
	     substr('copy of RUN_ID:'||to_char(r_user_param_config.RUN_ID)||' '||nvl(p_run_description,'admin action'),1,200),
	     nvl(p_new_app_name,r_user_param_config.ENVIRONMENT),
	     nvl(p_DB_SCHEMA, r_user_param_config.DB_SCHEMA),
	     nvl(p_PREFIX, r_user_param_config.PREFIX),
	     nvl(p_TABLESPACE, r_user_param_config.TABLESPACE),
	     nvl(p_left_suffix,r_user_param_config.LEFT_SUFFIX),
	     nvl(p_right_suffix,r_user_param_config.RIGHT_SUFFIX),
	     nvl(p_SPOOL_OUTPUT_DIR, r_user_param_config.SPOOL_OUTPUT_DIR),
	     nvl(p_COMPARE_BIN_DIR, r_user_param_config.COMPARE_BIN_DIR),
	     nvl(p_COMPARE_SQL_DIR, r_user_param_config.COMPARE_SQL_DIR),
	     nvl(p_LEFT_SUFFIX_CLEAN, r_user_param_config.LEFT_SUFFIX_CLEAN),
	     nvl(p_RIGHT_SUFFIX_CLEAN, r_user_param_config.RIGHT_SUFFIX_CLEAN),
       nvl(p_ORACLE_HOME, r_user_param_config.ORACLE_HOME),
	     nvl(p_LD_LIBRARY_PATH, r_user_param_config.LD_LIBRARY_PATH),
	     nvl(p_tec_col_1, r_user_param_config.TEC_COL_1),
	     nvl(p_tec_col_2, r_user_param_config.TEC_COL_2),
	     nvl(p_tec_col_3, r_user_param_config.TEC_COL_3),
	     nvl(p_tec_col_4, r_user_param_config.TEC_COL_4),
	     nvl(p_tec_col_5, r_user_param_config.TEC_COL_5),
	     nvl(p_tec_col_6, r_user_param_config.TEC_COL_6),
	     nvl(p_tec_col_7, r_user_param_config.TEC_COL_7),
	     nvl(p_tec_col_8, r_user_param_config.TEC_COL_8),
	     nvl(p_tec_col_9, r_user_param_config.TEC_COL_9),
	     nvl(p_tec_col_10, r_user_param_config.TEC_COL_10),
       nvl(p_USER_NAME, r_user_param_config.USER_NAME),
       nvl(p_used_by, r_user_param_config.USED_BY),
       nvl(p_LOCKED_YN, r_user_param_config.LOCKED_YN),
       nvl(p_DB_SCHEMA_PWD, r_user_param_config.DB_SCHEMA_PWD),
       nvl(p_DB_SID, r_user_param_config.DB_SID),
       nvl(p_EXT_IND, r_user_param_config.EXT_IND),
       nvl(p_SRC_SCHEMA, r_user_param_config.SRC_SCHEMA)
);
  end;
  commit;
  return l_free_run_id;
END F_CMP_USER_PARAM_CONFIG_FCOPY;
/
--------------------------------------------------------
--  DDL for Function F_CMP_USER_SEL_CLN_YN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_CMP_USER_SEL_CLN_YN" 
(
  P_RUN_ID NUMBER
) RETURN NUMBER AS
    rest_cnt NUMBER;
BEGIN
  DECLARE
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select environment, prefix, right_suffix
    from cmp_user_param_config
    where upper(run_id) = upper(p_c_run_id);
    r_user_param_config c_user_param_config%rowtype;
  BEGIN
    open c_user_param_config(p_run_id);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;

    select decode(count(*),0,0,1)
    into rest_cnt
    from user_tables
    where (table_name like '%'||r_user_param_config.right_suffix
          )
         and
            (table_name like UPPER(r_user_param_config.prefix||'%')
            or
            table_name like UPPER(r_user_param_config.environment||'%')
            );
  end;
  return rest_cnt;
END F_CMP_USER_SEL_CLN_YN;
/
--------------------------------------------------------
--  DDL for Function F_FORMAT_SUFFIX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_FORMAT_SUFFIX" 
(
  P_APP_NAME IN VARCHAR2,
  P_REL_NR IN NUMBER,
  P_CYC_NR IN NUMBER,
  P_DAY_NR IN NUMBER
)RETURN VARCHAR2 AS
BEGIN
    return replace(substr(P_APP_NAME,1,1)||to_char(P_REL_NR,'09')||substr(P_APP_NAME,2,1)||to_char(P_CYC_NR,'09')||substr(P_APP_NAME,3,1)||to_char(P_DAY_NR,'0'),' ','');
END F_FORMAT_SUFFIX;
/
--------------------------------------------------------
--  DDL for Function F_FREE_CMPREF_CONS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_FREE_CMPREF_CONS" (p_prefix varchar2) RETURN NUMBER AS
l_next_val NUMBER(6,0);
l_found NUMBER(1,0);
BEGIN
  l_found :=1;
  WHILE l_found>0
  LOOP
     select seq_cmpref_cons.nextval
     into l_next_val
     from dual;

     select count(*)
     into l_found
     from user_constraints
     where constraint_name = replace(upper(p_prefix)||'REF'||to_char(l_next_val,'09999'),' ','');
  END LOOP;
  return l_next_val;
END F_FREE_CMPREF_CONS;
/
--------------------------------------------------------
--  DDL for Function F_FREE_CMPREFUNQ_CONS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_FREE_CMPREFUNQ_CONS" (p_prefix varchar2) RETURN NUMBER AS
l_next_val NUMBER(6,0);
l_found NUMBER(1,0);
BEGIN
  l_found :=1;
  WHILE l_found>0
  LOOP
     select seq_cmprefunq_cons.nextval
     into l_next_val
     from dual;

     select count(*)
     into l_found
     from user_constraints
     where constraint_name = replace(upper(p_prefix)||'REFUNQ'||to_char(l_next_val,'09999'),' ','');
  END LOOP;
  return l_next_val;
END F_FREE_CMPREFUNQ_CONS;
/
--------------------------------------------------------
--  DDL for Function F_FREE_CMPUNQ_CONS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_FREE_CMPUNQ_CONS" (p_prefix varchar2) RETURN NUMBER AS
l_next_val NUMBER(6,0);
l_found NUMBER(1,0);
BEGIN
  l_found :=1;
  WHILE l_found>0
  LOOP
     select seq_cmpunq_cons.nextval
     into l_next_val
     from dual;

     select count(*)
     into l_found
     from user_constraints
     where constraint_name = replace(upper(p_prefix)||'UNQ'||to_char(l_next_val,'09999'),' ','');
  END LOOP;
  return l_next_val;
END F_FREE_CMPUNQ_CONS;
/
--------------------------------------------------------
--  DDL for Function F_FREE_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "F_FREE_RUN_ID" RETURN NUMBER AS
l_next_val NUMBER(6,0);
l_found NUMBER(1,0);
BEGIN
  l_found :=1;
  WHILE l_found>0
  LOOP
     select seq_cmp_run_id.nextval
     into l_next_val
     from dual;

     select count(*)
     into l_found
     from cmp_user_param_config
     where l_next_val=run_id;
  END LOOP;
  return l_next_val;
END F_FREE_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function UNIX_ADMIN_CLEAN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_ADMIN_CLEAN" RETURN NUMBER AS
BEGIN
  delete from unix_spool_file where run_id is not null;
  delete from unix_sql_file where run_id is not null;
  delete from unix_sql_params where run_id is not null;
  delete from unix_sh_file where run_id is not null;
  commit;
  return 0;
END UNIX_ADMIN_CLEAN;
/
--------------------------------------------------------
--  DDL for Function UNIX_BASH_SHELL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_BASH_SHELL" (p_shell_script VARCHAR2, p_run_id VARCHAR2) RETURN NUMBER AS
  cursor c_shell_steps(p_c_shell_script varchar2) is
  select distinct file_name, step_nr, sql_file_name, sh_file_name, sql_file_name_dir
  from unix_sh_file
  where file_name=p_c_shell_script
        and
        ((run_id is NULL) or (run_id=p_run_id))
  order by step_nr;
  r_shell_steps c_shell_steps%rowtype;
  l_result number;
BEGIN
    P_CMP_USER_LOGGING(sysdate, 'unix_bash_shell', 'start '||substr(p_shell_script,1,80));

    open c_shell_steps(p_shell_script);
    LOOP
      fetch c_shell_steps into r_shell_steps;
      exit WHEN c_shell_steps%NOTFOUND;
      if r_shell_steps.SQL_FILE_NAME is not null then
        l_result :=UNIX_SQLPLUS(r_shell_steps.SQL_FILE_NAME,p_run_id,r_shell_steps.sql_file_name_dir);
      else
        l_result :=UNIX_BASH_SHELL(r_shell_steps.SH_FILE_NAME, p_run_id);
      end if;
    END LOOP;
    close c_shell_steps;
  RETURN 0;
END UNIX_BASH_SHELL;
/
--------------------------------------------------------
--  DDL for Function UNIX_CLEAN_RUN_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_CLEAN_RUN_ID" (P_RUN_ID VARCHAR2) RETURN NUMBER AS
BEGIN
  delete from unix_spool_file where run_id=p_run_id;
  delete from unix_sql_file where run_id=p_run_id;
  delete from unix_sql_params where run_id=p_run_id;
  delete from unix_sh_file where run_id=p_run_id;
  commit;
  return 0;
END UNIX_CLEAN_RUN_ID;
/
--------------------------------------------------------
--  DDL for Function UNIX_CMP_PARAM_CONFIG_GEN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_CMP_PARAM_CONFIG_GEN" (P_RUN_ID VARCHAR2) RETURN NUMBER AS
cursor c_user_tab_sel(P_C_RUN_ID VARCHAR2) is
select tab
from CMP_USER_SELECTION_TABLES us2
where run_id=p_c_run_id
      and
      in_scope=1
order by us2.order_ascending asc, tab;
r_user_tab_sel c_user_tab_sel%rowtype;
l_cnt_user_sel NUMBER(10,0);
BEGIN
   delete from unix_sql_params where run_id=p_run_id;
   insert into unix_sql_params(param_name, param_value, run_id)
    select '&run_id', F_CMP_CONVERT_RUN_ID(run_id), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&db_schema_pwd', db_schema_pwd, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&ext_ind', ext_ind, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&db_sid', db_sid, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&environment', environment, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&db_schema', db_schema, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&src_schema', src_schema, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tablespace', tablespace, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&prefix', prefix, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&left_suffix', left_suffix, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&right_suffix', right_suffix, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&spool_output_dir', spool_output_dir, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&compare_bin_dir', compare_bin_dir, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&compare_sql_dir', compare_sql_dir, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&left_suffix_clean', left_suffix_clean, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&right_suffix_clean', right_suffix_clean, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&ORACLE_HOME', ORACLE_HOME, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&LD_LIBRARY_PATH', LD_LIBRARY_PATH, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_1', tec_col_1, p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_2', nvl(tec_col_2,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_3', nvl(tec_col_3,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_4', nvl(tec_col_4,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_5', nvl(tec_col_5,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_6', nvl(tec_col_6,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_7', nvl(tec_col_7,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_8', nvl(tec_col_8,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_9', nvl(tec_col_9,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&tech_column_10', nvl(tec_col_10,tec_col_1), p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&funct_sleutel_constraint_name', 'CMPUNQ%', p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;
  insert into unix_sql_params(param_name, param_value, run_id)
    select '&column_or_constraint', 'substr(ucc6.column_name,1,10)', p_run_id
    from cmp_user_param_config
    where F_CMP_CONVERT_RUN_ID(run_id) = p_run_id;


open c_user_tab_sel(p_run_id);
l_cnt_user_sel :=0;
  LOOP
    l_cnt_user_sel :=l_cnt_user_sel+1;
    fetch c_user_tab_sel into r_user_tab_sel;
    exit WHEN c_user_tab_sel%NOTFOUND;
      insert into unix_sql_params(param_name, param_value, run_id) values
      (replace('&tab_left_'||to_char(l_cnt_user_sel,'0999'),' ',''), '&prefix'||'_'||substr(r_user_tab_sel.tab,5,length(r_user_tab_sel.tab)-4)||'_&left_suffix', p_run_id);
      insert into unix_sql_params(param_name, param_value, run_id) values
      (replace('&tab_right_'||to_char(l_cnt_user_sel,'0999'),' ',''), '&prefix'||'_'||substr(r_user_tab_sel.tab,5,length(r_user_tab_sel.tab)-4)||'_&right_suffix', p_run_id);
      insert into unix_sql_params(param_name, param_value, run_id) values
      (replace('&tab_dest_'||to_char(l_cnt_user_sel,'0999'),' ',''), '&prefix'||'_'||'&environment'||'_'||substr(r_user_tab_sel.tab,5,length(r_user_tab_sel.tab)-4), p_run_id);
  END LOOP;
  close c_user_tab_sel;


commit;

  return 0;
END UNIX_CMP_param_config_gen;
/
--------------------------------------------------------
--  DDL for Function UNIX_CREATE_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_CREATE_VIEW" (P_SH_FILE_NAME VARCHAR2, P_SQL_FILE_NAME VARCHAR2, p_start_nr NUMBER, P_RUN_ID VARCHAR2) RETURN NUMBER AS
  cursor c_user_tab_sel(P_C_RUN_ID VARCHAR2) is
  select tab, order_ascending
  from CMP_USER_SELECTION_TABLES us2
  where run_id=p_c_run_id
        and
        in_scope=1
  order by us2.order_ascending asc, tab;
  r_user_tab_sel c_user_tab_sel%rowtype;
  cursor c_pattern_statement_sql(p_c_file_name varchar2) is
  select file_name, statement_nr, statement_type, statement_content_1,
                                       statement_content_2,
                                       statement_content_3,
                                       statement_content_4,
                                       statement_content_5,
                                       spool_file_name, spool_file_type, template_ind
  from unix_sql_file
  where upper(p_c_file_name)=upper(file_name)
        and
        template_ind=1
        and
        run_id is null
  order by statement_nr;
  r_pattern_statement_sql c_pattern_statement_sql%rowtype;
  l_statement_cnt NUMBER(5,0);
  l_param_cnt NUMBER(5,0);
  l_container_1 varchar2(4000);
  l_container_2 varchar2(4000);

BEGIN

  P_CMP_USER_LOGGING(sysdate, 'UNIX_CREATE_VIEW start', P_SQL_FILE_NAME);

  open c_user_tab_sel(p_run_id);
  l_statement_cnt :=0;
  l_param_cnt :=0;
    LOOP
      fetch c_user_tab_sel into r_user_tab_sel;
      exit WHEN c_user_tab_sel%NOTFOUND;
      l_param_cnt :=l_param_cnt+1;


      open c_pattern_statement_sql(P_SQL_FILE_NAME);
      loop
        fetch c_pattern_statement_sql into r_pattern_statement_sql;
        exit when c_pattern_statement_sql%NOTFOUND;
          l_statement_cnt :=l_statement_cnt+1;
          insert into unix_sql_file(file_name,
                                    statement_nr,
                                    statement_type,
                                    statement_content_1,
                                    statement_content_2,
                                    statement_content_3,
                                    statement_content_4,
                                    statement_content_5,
                                    spool_file_name,
                                    spool_file_type,
                                    run_id, template_ind)
          values (replace(replace(r_pattern_statement_sql.file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql','')||'.sql',
                 l_statement_cnt,
                 r_pattern_statement_sql.statement_type,
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_1, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_2, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_3, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_4, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_5, l_param_cnt),
                 replace(replace(r_pattern_statement_sql.spool_file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql','')||'.sql',
                 r_pattern_statement_sql.spool_file_type,
                 p_run_id,
                 null);
      END LOOP;

      -- fill sh file
      insert into unix_sh_file(file_name,
                                  step_nr,
                                  sql_file_name,
                                  sh_file_name,
                                  sql_file_name_dir,
                                  run_id)
      values (P_SH_FILE_NAME,
                6+(l_param_cnt-1)*8+(p_start_nr-1)*2,
                replace(replace(r_pattern_statement_sql.file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql',''),
                null,
                'SQL',
                p_run_id
               );
      insert into unix_sh_file(file_name,
                                  step_nr,
                                  sql_file_name,
                                  sh_file_name,
                                  sql_file_name_dir,
                                  run_id)
      values (P_SH_FILE_NAME,
                6+(l_param_cnt-1)*8+(p_start_nr-1)*2+1,
                replace(replace(r_pattern_statement_sql.spool_file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql',''),
                null,
                'SPOOL',
                p_run_id
               );
      -- end fill sh file

    close c_pattern_statement_sql;

    END LOOP;
  commit;
close c_user_tab_sel;

return 0;
END UNIX_CREATE_VIEW;
/
--------------------------------------------------------
--  DDL for Function UNIX_ELIMINATE_CLOSE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_ELIMINATE_CLOSE" (P_STATEMENT VARCHAR2) RETURN VARCHAR2 AS
l_statement varchar2(4000);
BEGIN
  select replace(replace(p_statement,';',''),'/','')
  into l_statement
  from dual;
  return l_statement;
END UNIX_ELIMINATE_CLOSE;
/
--------------------------------------------------------
--  DDL for Function UNIX_GIVE_OS_MODE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_GIVE_OS_MODE" RETURN VARCHAR2 AS
l_os_mode varchar2(10 char);
BEGIN

  --os_mode can be ORACLE, UNIX, CLOUD

  select os_mode
  into l_os_mode
  from unix_os_mode;

  return l_os_mode;

END UNIX_GIVE_OS_MODE;
/
--------------------------------------------------------
--  DDL for Function UNIX_NEXT_ROW_NR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_NEXT_ROW_NR" (P_RUN_ID VARCHAR2, P_SPOOL_FILE VARCHAR2) RETURN VARCHAR2 AS
l_cnt NUMBER;
l_max_nr NUMBER;
BEGIN
  select count(*)
  into l_cnt
  from unix_spool_file
  where upper(file_name)=upper(p_spool_file)
        and
        upper(run_id)=upper(p_run_id);

  if l_cnt=0 then
    return 1;
  else
    begin
      select max(row_nr)
      into l_max_nr
      from unix_spool_file
      where upper(file_name)=upper(p_spool_file)
            and
            upper(run_id)=upper(p_run_id);
      return l_max_nr+1;
    end;
  end if;
END UNIX_NEXT_ROW_NR;
/
--------------------------------------------------------
--  DDL for Function UNIX_REFKEY_CHANGE_PARAM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_REFKEY_CHANGE_PARAM" (P_STATEMENT VARCHAR2, P_CNT_USER_SEL NUMBER) RETURN VARCHAR2 AS
l_container_1 varchar2(4000);
l_container_2 varchar2(4000);
BEGIN
   l_container_1 :=replace(p_statement,'&tab_left',replace('&tab_left_'||to_char(p_cnt_user_sel,'0999'),' ',''));
   l_container_2 :=replace(l_container_1,'&tab_right',replace('&tab_right_'||to_char(p_cnt_user_sel,'0999'),' ',''));
   return replace(l_container_2,'&tab_dest', replace('&tab_dest_'||to_char(p_cnt_user_sel,'0999'),' ',''));
END UNIX_REFKEY_CHANGE_PARAM;
/
--------------------------------------------------------
--  DDL for Function UNIX_REFKEY_COMPARE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_REFKEY_COMPARE" (P_SH_FILE_NAME VARCHAR2, P_SQL_FILE_NAME VARCHAR2, p_start_nr NUMBER, P_RUN_ID VARCHAR2) RETURN NUMBER AS
  cursor c_user_tab_sel(P_C_RUN_ID VARCHAR2) is
  select tab, order_ascending
  from CMP_USER_SELECTION_TABLES us2
  where run_id=p_c_run_id
        and
        in_scope=1
  order by us2.order_ascending asc, tab;
  r_user_tab_sel c_user_tab_sel%rowtype;
  cursor c_pattern_statement_sql(p_c_file_name varchar2) is
  select file_name, statement_nr, statement_type, statement_content_1,
                                       statement_content_2,
                                       statement_content_3,
                                       statement_content_4,
                                       statement_content_5,
                                       spool_file_name, spool_file_type, template_ind
  from unix_sql_file
  where upper(p_c_file_name)=upper(file_name)
        and
        template_ind=1
        and
        run_id is null
  order by statement_nr;
  r_pattern_statement_sql c_pattern_statement_sql%rowtype;
  l_statement_cnt NUMBER(5,0);
  l_param_cnt NUMBER(5,0);
  l_container_1 varchar2(4000);
  l_container_2 varchar2(4000);

BEGIN

  P_CMP_USER_LOGGING(sysdate, 'UNIX_REFKEY_COMPARE start', P_SQL_FILE_NAME);

  open c_user_tab_sel(p_run_id);
  l_statement_cnt :=0;
  l_param_cnt :=0;
    LOOP
      fetch c_user_tab_sel into r_user_tab_sel;
      exit WHEN c_user_tab_sel%NOTFOUND;
      l_param_cnt :=l_param_cnt+1;


      open c_pattern_statement_sql(P_SQL_FILE_NAME);
      loop
        fetch c_pattern_statement_sql into r_pattern_statement_sql;
        exit when c_pattern_statement_sql%NOTFOUND;
          l_statement_cnt :=l_statement_cnt+1;
          insert into unix_sql_file(file_name,
                                    statement_nr,
                                    statement_type,
                                    statement_content_1,
                                    statement_content_2,
                                    statement_content_3,
                                    statement_content_4,
                                    statement_content_5,
                                    spool_file_name,
                                    spool_file_type,
                                    run_id, template_ind)
          values (replace(replace(r_pattern_statement_sql.file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql','')||'.sql',
                 l_statement_cnt,
                 r_pattern_statement_sql.statement_type,
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_1, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_2, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_3, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_4, l_param_cnt),
                 UNIX_REFKEY_CHANGE_PARAM(r_pattern_statement_sql.statement_content_5, l_param_cnt),
                 replace(replace(r_pattern_statement_sql.spool_file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql','')||'.sql',
                 r_pattern_statement_sql.spool_file_type,
                 p_run_id,
                 null);
      END LOOP;

      -- fill sh file
      insert into unix_sh_file(file_name,
                                  step_nr,
                                  sql_file_name,
                                  sh_file_name,
                                  sql_file_name_dir,
                                  run_id)
      values (P_SH_FILE_NAME,
                6+(l_param_cnt-1)*8+(p_start_nr-1)*2,
                replace(replace(r_pattern_statement_sql.file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql',''),
                null,
                'SQL',
                p_run_id
               );
      insert into unix_sh_file(file_name,
                                  step_nr,
                                  sql_file_name,
                                  sh_file_name,
                                  sql_file_name_dir,
                                  run_id)
      values (P_SH_FILE_NAME,
                6+(l_param_cnt-1)*8+(p_start_nr-1)*2+1,
                replace(replace(r_pattern_statement_sql.spool_file_name||'_'||to_char(l_param_cnt,'09999'),' ',''),'.sql',''),
                null,
                'SPOOL',
                p_run_id
               );
      -- end fill sh file

    close c_pattern_statement_sql;

    END LOOP;
  commit;
close c_user_tab_sel;

return 0;
END UNIX_REFKEY_COMPARE;
/
--------------------------------------------------------
--  DDL for Function UNIX_REPLACE_PARAM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_REPLACE_PARAM" (P_STATEMENT VARCHAR2, P_RUN_ID VARCHAR2) RETURN VARCHAR2 AS
  l_statement varchar2(4000);
  cursor c_param_values is
  select param_name, param_value
  from unix_sql_params
  where upper(run_id)=upper(p_run_id);
  r_param_values c_param_values%rowtype;
BEGIN
  l_statement :=p_statement;
  open c_param_values;

  LOOP
    fetch c_param_values into r_param_values;
    exit WHEN c_param_values%NOTFOUND;
    l_statement :=replace(l_statement,r_param_values.param_name,r_param_values.param_value);
  END LOOP;
  close c_param_values;

  return l_statement;
END UNIX_REPLACE_PARAM;
/
--------------------------------------------------------
--  DDL for Function UNIX_REPLACE_PARAM_BY_PARAM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_REPLACE_PARAM_BY_PARAM" (P_RUN_ID VARCHAR2) RETURN NUMBER AS
  l_changed_param_value varchar2(2000);
  cursor c_param(P_C_RUN_ID VARCHAR2) is
  select param_name, param_value
  from unix_sql_params
  where upper(run_id)=upper(p_c_run_id);
  r_param c_param%rowtype;
BEGIN
  open c_param(p_run_id);

  LOOP
    fetch c_param into r_param;
    exit WHEN c_param%NOTFOUND;
    l_changed_param_value :=unix_replace_param(r_param.param_value,P_RUN_ID);
    update unix_sql_params
    set param_value=l_changed_param_value
    where l_changed_param_value!=r_param.param_value
          and
          r_param.param_name=param_name
          and
          run_id=p_run_id;
  END LOOP;
  close c_param;
  commit;

  return 0;
END UNIX_REPLACE_PARAM_BY_PARAM;
/
--------------------------------------------------------
--  DDL for Function UNIX_RUN_ID_CLEAN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_RUN_ID_CLEAN" (P_RUN_ID VARCHAR2) RETURN NUMBER AS
BEGIN
  delete from unix_spool_file where run_id is not null and run_id=p_run_id;
  delete from unix_sql_file where run_id is not null  and run_id=p_run_id;
  delete from unix_sql_params where run_id is not null  and run_id=p_run_id;
  delete from unix_sh_file where run_id is not null  and run_id=p_run_id;
  commit;
  return 0;
END UNIX_RUN_ID_CLEAN;
/
--------------------------------------------------------
--  DDL for Function UNIX_SPOOL_ROW_TO_FILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SPOOL_ROW_TO_FILE" (P_RUN_ID VARCHAR2, P_SPOOL_FILE_NAME VARCHAR2, P_SPOOL_FILE_TYPE VARCHAR2,P_STATEMENT_NR NUMBER, P_ROW_CONTENT VARCHAR2, P_ERROR CHAR) RETURN NUMBER AS
BEGIN
  insert into unix_spool_file (counter, datetime, RUN_ID, file_name, file_type, row_nr, row_content, error, statement_nr)
  values (seq_spool_file.nextval, sysdate, p_run_id, p_spool_file_name, p_spool_file_type, UNIX_NEXT_ROW_NR(p_run_id, p_spool_file_name), p_row_content, P_ERROR, p_statement_nr);
  commit;
  RETURN 0;
END UNIX_SPOOL_ROW_TO_FILE;
/
--------------------------------------------------------
--  DDL for Function UNIX_SQLPLUS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SQLPLUS" (P_FILE_NAME VARCHAR2, P_RUN_ID VARCHAR2, P_DIRECTORY VARCHAR2) RETURN NUMBER AS
  cursor c_statements_sql(p_c_file_name varchar2) is
  select statement_nr, statement_type, statement_content_1,
                                       statement_content_2,
                                       statement_content_3,
                                       statement_content_4,
                                       statement_content_5,
                                       spool_file_name, spool_file_type
  from unix_sql_file
  where p_c_file_name=file_name
        and
        template_ind is null
        and
        (run_id is null or run_id=p_run_id)
  order by statement_nr;
  r_statements_sql c_statements_sql%rowtype;
  cursor c_statements_spool(p_c_file_name varchar2) is
  select row_nr, row_content, file_name, statement_nr
  from unix_spool_file
  where upper(p_c_file_name||'.sql')=upper(file_name)
        and
        upper(file_type)='SQL'
        and
        run_id=p_run_id
  order by row_nr;
  r_statements_spool c_statements_spool%rowtype;
  l_result number(1,0);
  statement_spool_sql_1 varchar2(4000);
  statement_spool_sql_2 varchar2(4000);
  statement_spool_sql_3 varchar2(4000);
  statement_spool_sql_4 varchar2(4000);
  statement_spool_sql_5 varchar2(4000);
  statement_spool_sql_6 varchar2(4000);
  statement_spool_sql_7 varchar2(4000);
  statement_spool_sql_8 varchar2(4000);
  statement_spool_sql_9 varchar2(4000);
  l_statement_length number(10,0);
  l_comma_ind NUMBER(1,0);
BEGIN
  P_CMP_USER_LOGGING(sysdate, 'unix_sqlplus '||'start', substr(p_file_name,1,80)||' '||P_DIRECTORY);

  if upper(P_DIRECTORY)='SQL' then
  begin
    open c_statements_sql(p_file_name||'.sql');
    LOOP
      fetch c_statements_sql into r_statements_sql;
      exit WHEN c_statements_sql%NOTFOUND;
      if r_statements_sql.statement_type='SELECT' then
        l_result :=UNIX_SQLPLUS_SELECT_SQLPACK(r_statements_sql.STATEMENT_CONTENT_1,
                                               r_statements_sql.STATEMENT_CONTENT_2,
                                               r_statements_sql.STATEMENT_CONTENT_3,
                                               r_statements_sql.STATEMENT_CONTENT_4,
                                               r_statements_sql.STATEMENT_CONTENT_5,
                                               P_RUN_ID, r_statements_sql.SPOOL_FILE_NAME,
                                               r_statements_sql.SPOOL_FILE_TYPE,
                                               r_statements_sql.STATEMENT_NR);
      elsif r_statements_sql.statement_type in ('FUNCTION', 'PROCEDURE') then
      l_result :=UNIX_SQLPLUS_COMMAND_DIRECT(r_statements_sql.STATEMENT_CONTENT_1,
                                              r_statements_sql.STATEMENT_CONTENT_2,
                                              r_statements_sql.STATEMENT_CONTENT_3,
                                              r_statements_sql.STATEMENT_CONTENT_4,
                                              r_statements_sql.STATEMENT_CONTENT_5,
                                              P_RUN_ID, r_statements_sql.SPOOL_FILE_NAME,
                                              r_statements_sql.SPOOL_FILE_TYPE,
                                              r_statements_sql.STATEMENT_NR);
      else
        l_result :=UNIX_SQLPLUS_COMMAND_SQLPACK(r_statements_sql.STATEMENT_CONTENT_1,
                                                r_statements_sql.STATEMENT_CONTENT_2,
                                                r_statements_sql.STATEMENT_CONTENT_3,
                                                r_statements_sql.STATEMENT_CONTENT_4,
                                                r_statements_sql.STATEMENT_CONTENT_5,
                                                null,
                                                null,
                                                null,
                                                null,
                                                P_RUN_ID, r_statements_sql.SPOOL_FILE_NAME,
                                                r_statements_sql.SPOOL_FILE_TYPE,
                                                r_statements_sql.STATEMENT_NR);
      end if;
    END LOOP;
    close c_statements_sql;
  end;
  elsif upper(P_DIRECTORY)='SPOOL' then
  begin

    statement_spool_sql_1 :=null;
    statement_spool_sql_2 :=null;
    statement_spool_sql_3 :=null;
    statement_spool_sql_4 :=null;
    statement_spool_sql_5 :=null;
    statement_spool_sql_6 :=null;
    statement_spool_sql_7 :=null;
    statement_spool_sql_8 :=null;
    statement_spool_sql_9 :=null;

    open c_statements_spool(p_file_name);

    LOOP
      fetch c_statements_spool into r_statements_spool;
      l_comma_ind :=0;
      if instr(r_statements_spool.row_content,';')>0 then
        l_comma_ind :=1;
      end if;

      l_statement_length :=nvl(length(statement_spool_sql_1),0)+
                           nvl(length(statement_spool_sql_2),0)+
                           nvl(length(statement_spool_sql_3),0)+
                           nvl(length(statement_spool_sql_4),0)+
                           nvl(length(statement_spool_sql_5),0)+
                           nvl(length(statement_spool_sql_6),0)+
                           nvl(length(statement_spool_sql_7),0)+
                           nvl(length(statement_spool_sql_8),0)+
                           nvl(length(statement_spool_sql_9),0)+
                           nvl(length(r_statements_spool.row_content),0);
      if l_statement_length >= 0 and l_statement_length <3000
        then statement_spool_sql_1:=statement_spool_sql_1||r_statements_spool.row_content;
      elsif l_statement_length >= 3000 and l_statement_length <6000
        then statement_spool_sql_2:=statement_spool_sql_2||r_statements_spool.row_content;
      elsif l_statement_length >= 6000 and l_statement_length <9000
        then statement_spool_sql_3:=statement_spool_sql_3||r_statements_spool.row_content;
      elsif l_statement_length >= 9000 and l_statement_length <12000
        then statement_spool_sql_4:=statement_spool_sql_4||r_statements_spool.row_content;
      elsif l_statement_length >= 12000 and l_statement_length <15000
        then statement_spool_sql_5:=statement_spool_sql_5||r_statements_spool.row_content;
      elsif l_statement_length >= 15000 and l_statement_length <18000
        then statement_spool_sql_6:=statement_spool_sql_6||r_statements_spool.row_content;
      elsif l_statement_length >= 18000 and l_statement_length <21000
        then statement_spool_sql_7:=statement_spool_sql_7||r_statements_spool.row_content;
      elsif l_statement_length >= 21000 and l_statement_length <24000
        then statement_spool_sql_8:=statement_spool_sql_8||r_statements_spool.row_content;
      elsif l_statement_length >= 24000 and l_statement_length <27000
        then statement_spool_sql_9:=statement_spool_sql_9||r_statements_spool.row_content;
      end if;


      exit WHEN c_statements_spool%NOTFOUND;
      if l_comma_ind =1 then
      begin
        l_result :=UNIX_SQLPLUS_COMMAND_SQLPACK(statement_spool_sql_1,
                                                statement_spool_sql_2,
                                                statement_spool_sql_3,
                                                statement_spool_sql_4,
                                                statement_spool_sql_5,
                                                statement_spool_sql_6,
                                                statement_spool_sql_7,
                                                statement_spool_sql_8,
                                                statement_spool_sql_9,
                                                P_RUN_ID, p_file_name||'.lst',
                                                'lst',
                                                r_statements_spool.STATEMENT_NR);

         statement_spool_sql_1 :=null;
         statement_spool_sql_2 :=null;
         statement_spool_sql_3 :=null;
         statement_spool_sql_4 :=null;
         statement_spool_sql_5 :=null;
         statement_spool_sql_6 :=null;
         statement_spool_sql_7 :=null;
         statement_spool_sql_8 :=null;
         statement_spool_sql_9 :=null;
      end;
      end if;
    END LOOP;
    close c_statements_spool;
  end;
  end if;

  RETURN 0;
END UNIX_SQLPLUS;
/
--------------------------------------------------------
--  DDL for Function UNIX_SQLPLUS_COMMAND_DIRECT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SQLPLUS_COMMAND_DIRECT" (P_STATEMENT_CONTENT_1 VARCHAR2,
                                        P_STATEMENT_CONTENT_2 VARCHAR2,
                                        P_STATEMENT_CONTENT_3 VARCHAR2,
                                        P_STATEMENT_CONTENT_4 VARCHAR2,
                                        P_STATEMENT_CONTENT_5 VARCHAR2,
                                        P_RUN_ID VARCHAR2, P_SPOOL_FILE_NAME VARCHAR2, P_SPOOL_FILE_TYPE VARCHAR2, P_STATEMENT_NR NUMBER) RETURN NUMBER AS
l_result number;
BEGIN
  P_CMP_USER_LOGGING(sysdate, 'unix_sqlplus_command_direct', substr(P_SPOOL_FILE_NAME,1,80)||' '||P_SPOOL_FILE_TYPE);

  begin
  EXECUTE IMMEDIATE UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID);
  exception
  when others then
  begin
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID), 'E');
    return 1;
  end;
  end;
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID), NULL);
  RETURN 0;
END UNIX_SQLPLUS_COMMAND_DIRECT;
/
--------------------------------------------------------
--  DDL for Function UNIX_SQLPLUS_COMMAND_SQLPACK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SQLPLUS_COMMAND_SQLPACK" (P_STATEMENT_CONTENT_1 VARCHAR2,
                                      P_STATEMENT_CONTENT_2 VARCHAR2,
                                      P_STATEMENT_CONTENT_3 VARCHAR2,
                                      P_STATEMENT_CONTENT_4 VARCHAR2,
                                      P_STATEMENT_CONTENT_5 VARCHAR2,
                                      P_STATEMENT_CONTENT_6 VARCHAR2,
                                      P_STATEMENT_CONTENT_7 VARCHAR2,
                                      P_STATEMENT_CONTENT_8 VARCHAR2,
                                      P_STATEMENT_CONTENT_9 VARCHAR2,
                                      P_RUN_ID VARCHAR2, P_SPOOL_FILE_NAME VARCHAR2, P_SPOOL_FILE_TYPE VARCHAR2, P_STATEMENT_NR NUMBER) RETURN NUMBER AS
  l_result NUMBER;
  cur_hdl  INTEGER;
  rows_processed  BINARY_INTEGER;
BEGIN
   P_CMP_USER_LOGGING(sysdate, 'unix_sqlplus_command_sqlpack', substr(P_SPOOL_FILE_NAME,1,80)||' '||P_SPOOL_FILE_TYPE);


   -- open cursor
   cur_hdl := dbms_sql.open_cursor;

   begin
     -- parse cursor
    dbms_sql.parse(cur_hdl, UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_2, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_3, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_4, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_5, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_6, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_7, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_8, P_RUN_ID))||
                            UNIX_ELIMINATE_CLOSE(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_9, P_RUN_ID))
                            ,dbms_sql.native);

     -- execute cursor
     rows_processed := dbms_sql.execute(cur_hdl);
   exception
   when others then
   begin
     l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID), 'E');
     if P_STATEMENT_CONTENT_2 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_2, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_3 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_3, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_4 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_4, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_5 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_5, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_6 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_6, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_7 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_7, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_8 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_8, P_RUN_ID), 'E'); end if;
     if P_STATEMENT_CONTENT_9 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_9, P_RUN_ID), 'E'); end if;
     return 1;
   end;
   end;

   -- close cursor
   dbms_sql.close_cursor(cur_hdl);
   P_CMP_USER_LOGGING(sysdate, 'unix_sqlplus_command_sqlpack', 'SPOOL ROW TO FILE '||substr(P_SPOOL_FILE_NAME,1,20)||' '||P_SPOOL_FILE_TYPE);
   l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID), NULL);
   if P_STATEMENT_CONTENT_2 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_2, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_3 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_3, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_4 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_4, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_5 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_5, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_6 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_6, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_7 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_7, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_8 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_8, P_RUN_ID), NULL); end if;
   if P_STATEMENT_CONTENT_9 is not null then l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_9, P_RUN_ID), NULL); end if;
  RETURN 0;
END UNIX_SQLPLUS_COMMAND_SQLPACK;
/
--------------------------------------------------------
--  DDL for Function UNIX_SQLPLUS_SELECT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SQLPLUS_SELECT" (P_STATEMENT_CONTENT VARCHAR2, P_RUN_ID VARCHAR2, P_SPOOL_FILE_NAME VARCHAR2, P_SPOOL_FILE_TYPE VARCHAR2) RETURN NUMBER AS
TYPE CurTyp IS REF CURSOR;
cur CurTyp;
select_row    VARCHAR2(4000);
l_result      NUMBER;
l_cnt_rows    NUMBER;
BEGIN

  begin
    P_CMP_USER_LOGGING(sysdate, 'unix_sqlplus_select', substr(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT, P_RUN_ID),20,100));
    OPEN cur FOR UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT, P_RUN_ID);
  exception
  when others then
  begin
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, 0, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT, P_RUN_ID), 'E');
    return 1;
  end;
  end;

  l_cnt_rows :=0;
  LOOP
    FETCH cur INTO select_row;
    EXIT WHEN cur%NOTFOUND;
    l_cnt_rows :=l_cnt_rows+1;
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, UNIX_ELIMINATE_CLOSE(select_row), NULL,0);
  END LOOP;
  CLOSE cur;
  if l_cnt_rows=0 then
     l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, 'select '||''' no selection '''||' from dual', NULL,0);
  end if;

RETURN 0;

END UNIX_SQLPLUS_SELECT;
/
--------------------------------------------------------
--  DDL for Function UNIX_SQLPLUS_SELECT_SQLPACK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNIX_SQLPLUS_SELECT_SQLPACK" (P_STATEMENT_CONTENT_1 VARCHAR2,
                                     P_STATEMENT_CONTENT_2 VARCHAR2,
                                     P_STATEMENT_CONTENT_3 VARCHAR2,
                                     P_STATEMENT_CONTENT_4 VARCHAR2,
                                     P_STATEMENT_CONTENT_5 VARCHAR2,
                                     P_RUN_ID VARCHAR2, P_SPOOL_FILE_NAME VARCHAR2, P_SPOOL_FILE_TYPE VARCHAR2, P_STATEMENT_NR NUMBER) RETURN NUMBER AS
  l_result      NUMBER;
  l_cnt_rows    NUMBER;
  cur_hdl int;
  rows_processed int;
  select_row varchar2(4000);
  salary int;
BEGIN
  P_CMP_USER_LOGGING(sysdate, 'UNIX_SQLPLUS_SELECT', 'pre'||substr(P_STATEMENT_CONTENT_1,1,80));
  P_CMP_USER_LOGGING(sysdate, 'UNIX_SQLPLUS_SELECT', 'post'||substr(UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID),1,80));

  cur_hdl := dbms_sql.open_cursor; -- open cursor

  begin

    dbms_sql.parse(cur_hdl, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID)||
                            UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_2, P_RUN_ID)||
                            UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_3, P_RUN_ID)||
                            UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_4, P_RUN_ID)||
                            UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_5, P_RUN_ID), dbms_sql.native);

    -- describe defines
    dbms_sql.define_column(cur_hdl, 1, select_row, 4000);

    rows_processed := dbms_sql.execute(cur_hdl); -- execute
  exception
  when others then
  begin
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, UNIX_REPLACE_PARAM(P_STATEMENT_CONTENT_1, P_RUN_ID), 'E');
    return 1;
  end;
  end;

l_cnt_rows :=0;
LOOP
  -- fetch a row
  IF dbms_sql.fetch_rows(cur_hdl) > 0 then

    -- fetch columns from the row
    dbms_sql.column_value(cur_hdl, 1, select_row);

    l_cnt_rows :=l_cnt_rows+1;

    -- <process data>
    l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR, select_row, NULL);

      ELSE
        EXIT;
      END IF;
END LOOP;
dbms_sql.close_cursor(cur_hdl); -- close cursor

if l_cnt_rows=0 then
  l_result :=UNIX_SPOOL_ROW_TO_FILE(P_RUN_ID, P_SPOOL_FILE_NAME, P_SPOOL_FILE_TYPE, P_STATEMENT_NR,'', NULL); -- no selection
end if;

RETURN 0;

END UNIX_SQLPLUS_SELECT_SQLPACK;
/
