--------------------------------------------------------
--  File created - Saturday-February-01-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure P_CMP_CREDENTIAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_CREDENTIAL" (P_PWD VARCHAR2)
is
BEGIN
  begin
      dbms_scheduler.drop_credential( credential_name => 'app_CMP_CRED', force => TRUE );
  exception
    when others then null;
  end;
  dbms_scheduler.create_credential('app_CMP_CRED','oracle',P_PWD, NULL, NULL, NULL);
END P_CMP_credential;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLN_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLN_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CLN_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin


     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_CLN_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
        --    credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;

end if;




END P_CMP_DWH_MAIN_CLN_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLN_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLN_PART1_CL" is
begin
  P_CMP_DWH_MAIN_CLN_PART1(14);
END P_CMP_DWH_MAIN_CLN_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLN_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLN_PART1_LG_CL" is
l_result number;
begin
  l_result :=F_CMP_DWH_MAIN_CLN_PART1_LOG(14);
END P_CMP_DWH_MAIN_CLN_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLR_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLR_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
l_result number(1,0);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLR_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CLR_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLR_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_CLR_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
    --        credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_DWH_MAIN_CLR_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLR_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLR_PART1_CL" is
begin
  P_CMP_DWH_MAIN_CLR_PART1(14);
END P_CMP_DWH_MAIN_CLR_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CLR_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CLR_PART1_LG_CL" is
l_result number;
begin
  l_result :=F_CMP_DWH_MAIN_CLR_PART1_LOG(14);
END P_CMP_DWH_MAIN_CLR_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_ANL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_ANL" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
l_result number(1,0);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CON_ANL');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CONSTRAINT_ANALYSIS_TRAILER'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CON_ANL');
     p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_ANALYSIS.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
     --       credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_DWH_MAIN_CON_ANL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_ANL_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_ANL_CL" is
begin
  P_CMP_DWH_MAIN_CON_ANL(5023);
END P_CMP_DWH_MAIN_CON_ANL_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_ANL_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_ANL_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_CON_ANL_LOG(13);
END P_CMP_DWH_MAIN_CON_ANL_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
l_result number(1,0);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CONSTRAINT_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
    --        credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;


END P_CMP_DWH_MAIN_CON_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART1_CL" is
begin
  P_CMP_DWH_MAIN_CON_PART1(13);
END P_CMP_DWH_MAIN_CON_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART1_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_CON_PART1_LOG(13);
END P_CMP_DWH_MAIN_CON_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART2" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
l_result number(1,0);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART2');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CONSTRAINT_TRAILER_PART2'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART2');
     p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_PART2.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
   --         credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_DWH_MAIN_CON_PART2;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART2_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART2_CL" is
begin
  P_CMP_DWH_MAIN_CON_PART2(13);
END P_CMP_DWH_MAIN_CON_PART2_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART2_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART2_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_CON_PART2_LOG(13);
END P_CMP_DWH_MAIN_CON_PART2_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART3
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART3" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
l_result number(1,0);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART3');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CONSTRAINT_TRAILER_PART3'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CONSTR_PART3');
     p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_PART3.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
    --        credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;


END P_CMP_DWH_MAIN_CON_PART3;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART3_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART3_CL" is
begin
  P_CMP_DWH_MAIN_CON_PART3(13);
END P_CMP_DWH_MAIN_CON_PART3_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CON_PART3_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CON_PART3_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_CON_PART3_LOG(13);
END P_CMP_DWH_MAIN_CON_PART3_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CRT_VIEW_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CRT_VIEW_PART1" (p_run_id NUMBER, p_old_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_old_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id := (F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_PART1');

     p_old_run_char_id := (F_CMP_CONVERT_RUN_ID(p_old_run_id));
     l_result :=UNIX_RUN_ID_CLEAN(p_old_run_char_id);
     l_result :=UNIX_CMP_param_config_gen(p_old_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_PREPARE', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_DROP_LEFT_RIGHT', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_INF',p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_CNT', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_GRP',p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_DSH', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_CMP_LEFT', p_old_run_char_id);
    l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_VIEW_CMP_RIGHT', p_old_run_char_id);


/*     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_VIEW_PREPARE'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_VIEW'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_INF'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_CNT'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_GRP'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_DSH'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_CMP_LEFT'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CXMP_DWH_MAIN_CRT_VIEW_CMP_RIGHT'', '''||p_old_run_char_id||''');
                                  end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');



  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;  */

end;
elsif l_os_mode='UNIX' then
begin
     /*

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_CLN_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
        --    credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

  */
  null;
end;

end if;




END P_CMP_DWH_MAIN_CRT_VIEW_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_CRT_VIEW_PART2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_CRT_VIEW_PART2" (p_run_id NUMBER, p_old_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_old_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id := (F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_PART2');

     p_old_run_char_id := (F_CMP_CONVERT_RUN_ID(p_old_run_id));
     l_result :=UNIX_RUN_ID_CLEAN(p_old_run_char_id);
     l_result :=UNIX_CMP_param_config_gen(p_old_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW', p_old_run_char_id);
     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW_LEFT_RIGHT', p_old_run_char_id);
     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW_INF', p_old_run_char_id);
     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW_DSH', p_old_run_char_id);
     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW_CNT', p_old_run_char_id);
     l_result :=UNIX_BASH_SHELL('CMP_DWH_MAIN_CRT_TOP_VIEW_GRP', p_old_run_char_id);

/*     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_LEFT_RIGHT'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_DETAIL'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_INF'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_GRP'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_CNT'', '''||p_old_run_char_id||''');
                                  l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_CRT_TOP_VIEW_DSH'', '''||p_old_run_char_id||''');
                                  end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;   /*

end;
elsif l_os_mode='UNIX' then
begin
     /*

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_CLN_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
        --    credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

  */
  null;
end;

end if;




END P_CMP_DWH_MAIN_CRT_VIEW_PART2;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_IMP_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_IMP_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
    --        credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_DWH_MAIN_IMP_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART1_CL" is
begin
  P_CMP_DWH_MAIN_IMP_PART1(14);
END P_CMP_DWH_MAIN_IMP_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART1_LG_CL" is
l_result number;
begin
  l_result :=F_CMP_DWH_MAIN_IMP_PART1_LOG(14);
END P_CMP_DWH_MAIN_IMP_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART2" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART2');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_IMP_TRAILER_PART2'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_PART2');
     p_shell_script_name :='CMP_DWH_MAIN_IMP_PART2.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
      --      credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_DWH_MAIN_IMP_PART2;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART2_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART2_CL" is
begin
  P_CMP_DWH_MAIN_IMP_PART2(14);
END P_CMP_DWH_MAIN_IMP_PART2_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_IMP_PART2_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_IMP_PART2_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_IMP_PART2_LOG(14);
END P_CMP_DWH_MAIN_IMP_PART2_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_INS_ROL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_INS_ROL" (p_run_id NUMBER, p_user VARCHAR2, p_pwd VARCHAR2)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
p_check_authorization number;
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

  if (F_CMP_ADMIN_YN(p_user,p_pwd)=0)
  then begin

  l_os_mode :=unix_give_os_mode;

    if l_os_mode in ('ORACLE','CLOUD')
    then begin

         p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
         p_job_name :=UPPER(p_run_char_id||'_CMP_INS_ROL');

         l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

         begin
           dbms_scheduler.drop_job(job_name => p_job_name,
                                   defer => false,
                                   force => true);
         exception
           when others then null;
         end;

         dbms_scheduler.create_job(
                job_name   => p_job_name,
                job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
                job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_INSTALL_ROLES_TRAILER'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
                number_of_arguments => 0,  -- ORACLE specific
                start_date => SYSTIMESTAMP,
                enabled    => FALSE,
                auto_drop     => TRUE,
                repeat_interval => NULL,
                comments      => 'Job defined by an existing program and schedule.');


      dbms_scheduler.enable(p_job_name);
      if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

    end;
    elsif l_os_mode='UNIX' then
    begin

         p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
         p_job_name :=UPPER(p_run_char_id||'_CMP_INS_ROL');
         p_shell_script_name :='CMP_DWH_MAIN_INSTALL_ROLES.'||p_run_char_id||'.sh';

         select spool_output_dir
         into p_spool_output_dir
         from cmp_user_param_config
         where run_id = p_run_id;

         begin
           dbms_scheduler.drop_job(job_name => p_job_name,
                                   defer => false,
                                   force => false);
         exception
           when others then null;
         end;

         dbms_scheduler.create_job(
                job_name   => p_job_name,
                job_type   => 'EXECUTABLE',
                job_action => '/bin/bash',
                number_of_arguments => 1,
                start_date => SYSTIMESTAMP,
                enabled    => FALSE,
                auto_drop     => TRUE,
                repeat_interval => NULL,
         --       credential_name     => 'app_CMP_CRED',
                comments      => 'Job defined by an existing program and schedule.');


      dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
      dbms_scheduler.enable(p_job_name);
      dbms_scheduler.run_job(p_job_name,FALSE);
    end;
    end if;

end; end if;

END P_CMP_DWH_MAIN_INS_ROL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_INS_ROL_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_INS_ROL_CL" is
begin
  P_CMP_DWH_MAIN_INS_ROL(13,'admin','welkom');
END P_CMP_DWH_MAIN_INS_ROL_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_INS_ROL_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_INS_ROL_LG_CL" is
l_result number;
begin
  l_result :=F_CMP_DWH_MAIN_INS_ROL_LOG(13);
END P_CMP_DWH_MAIN_INS_ROL_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_NEW_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_NEW_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
       --     credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);
end;
end if;


END P_CMP_DWH_MAIN_NEW_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART1_CL" is
begin
  P_CMP_DWH_MAIN_NEW_PART1(13);
END P_CMP_DWH_MAIN_NEW_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART1_LG_CL" is
l_result number;
begin
  l_result :=F_CMP_DWH_MAIN_NEW_PART1_LOG(13);
END P_CMP_DWH_MAIN_NEW_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART2" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

if l_os_mode !='CLOUD' then DBMS_LOCK.SLEEP(30); end if; -- sleep to let the catalog settle itself

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART2');

      l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_NEW_TRAILER_PART2_PREPARE'', '''||p_run_char_id||'''); l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_NEW_TRAILER_PART2'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_PART2');
     p_shell_script_name :='CMP_DWH_MAIN_NEW_PART2.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
   --         credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;


END P_CMP_DWH_MAIN_NEW_PART2;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART2_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART2_CL" is
begin
  P_CMP_DWH_MAIN_NEW_PART2(13);
END P_CMP_DWH_MAIN_NEW_PART2_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_NEW_PART2_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_NEW_PART2_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_NEW_PART2_LOG(13);
END P_CMP_DWH_MAIN_NEW_PART2_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART1" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART1');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_RESTART_TRAILER_PART1'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART1');
     p_shell_script_name :='CMP_DWH_MAIN_RESTART_PART1.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
       --     credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);
end;
end if;


END P_CMP_DWH_MAIN_RE_PART1;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART1_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART1_CL" is
begin
  P_CMP_DWH_MAIN_RE_PART1(13);
END P_CMP_DWH_MAIN_RE_PART1_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART1_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART1_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_RE_PART1_LOG(13);
END P_CMP_DWH_MAIN_RE_PART1_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART2" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_run_char_id VARCHAR2(6);
p_spool_output_dir varchar2(2000);
p_shell_script_name varchar2(2000);
l_result number(1,0);
l_os_mode varchar2(10);
BEGIN

l_os_mode :=unix_give_os_mode;

if l_os_mode in ('ORACLE','CLOUD')
then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART2');

     l_result :=UNIX_CMP_param_config_gen(p_run_char_id); -- ORACLE specific

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => true);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'PLSQL_BLOCK',   -- ORACLE specific
            job_action => 'declare l_temp number(1,0); begin l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_RESTART_TRAILER_PART2_PREPARE'', '''||p_run_char_id||'''); l_temp :=UNIX_BASH_SHELL(''CMP_DWH_MAIN_RESTART_TRAILER_PART2'', '''||p_run_char_id||'''); end;',  -- ORACLE specific
            number_of_arguments => 0,  -- ORACLE specific
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.enable(p_job_name);
  if l_os_mode in ('ORACLE') then dbms_scheduler.run_job(p_job_name,FALSE); end if;

end;
elsif l_os_mode='UNIX' then
begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_RE_PART2');
     p_shell_script_name :='CMP_DWH_MAIN_RESTART_PART2.'||p_run_char_id||'.sh';

     select spool_output_dir
     into p_spool_output_dir
     from cmp_user_param_config
     where run_id = p_run_id;

     begin
       dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
     exception
       when others then null;
     end;

     dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 1,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
    --        credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_spool_output_dir||'/'||p_shell_script_name);
  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);
end;
end if;

END P_CMP_DWH_MAIN_RE_PART2;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART2_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART2_CL" is
begin
  P_CMP_DWH_MAIN_RE_PART2(13);
END P_CMP_DWH_MAIN_RE_PART2_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_DWH_MAIN_RE_PART2_LG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_DWH_MAIN_RE_PART2_LG_CL" is
l_result number;
begin
  l_result := F_CMP_DWH_MAIN_RE_PART2_LOG(13);
END P_CMP_DWH_MAIN_RE_PART2_LG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLN_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLN_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLN_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_CLN_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
        --      credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_CLN_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLN_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLN_TOP_CL" is
begin
  P_CMP_MAIN_CLN_TOP(20);
END P_CMP_MAIN_CLN_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLN_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLN_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_CLN_TOP_LOG(14);
END P_CMP_MAIN_CLN_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLR_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLR_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CLR_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_CLR_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
       --       credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_CLR_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLR_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLR_TOP_CL" is
begin
  P_CMP_MAIN_CLR_TOP(14);
END P_CMP_MAIN_CLR_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CLR_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CLR_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_CLR_TOP_LOG(14);
END P_CMP_MAIN_CLR_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_ANL_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_ANL_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

   p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
   p_job_name :=UPPER(p_run_char_id||'_CMP_CON_ANL_TOP');
   p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_ANALYSIS_TOP.sh';

   select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
   into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
   from cmp_user_param_config
   where run_id = p_run_id;

  begin
    dbms_scheduler.drop_job(job_name => p_job_name,
                            defer => false,
                            force => false);
  exception
    when others then null;
  end;

  dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 11,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
     --       credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
  dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
  dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
  dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
  dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
  dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
  dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
  dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_CON_ANL_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_ANL_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_ANL_TOP_CL" is
begin
  P_CMP_MAIN_CON_ANL_TOP(13);
END P_CMP_MAIN_CON_ANL_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_ANL_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_ANL_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_CON_ANL_TOP_LOG(13);
END P_CMP_MAIN_CON_ANL_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

   p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
   p_job_name :=UPPER(p_run_char_id||'_CMP_CON_TOP');
   p_shell_script_name :='CMP_DWH_MAIN_CONSTRAINT_TOP.sh';

   select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
   into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
   from cmp_user_param_config
   where run_id = p_run_id;

  begin
    dbms_scheduler.drop_job(job_name => p_job_name,
                            defer => false,
                            force => false);
  exception
    when others then null;
  end;

  dbms_scheduler.create_job(
            job_name   => p_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            number_of_arguments => 11,
            start_date => SYSTIMESTAMP,
            enabled    => FALSE,
            auto_drop     => TRUE,
            repeat_interval => NULL,
      --      credential_name     => 'app_CMP_CRED',
            comments      => 'Job defined by an existing program and schedule.');


  dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
  dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
  dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
  dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
  dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
  dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
  dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
  dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
  dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

  dbms_scheduler.enable(p_job_name);
  dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_CON_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_TOP_CL" is
begin
  P_CMP_MAIN_CON_TOP(5023);
END P_CMP_MAIN_CON_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CON_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CON_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_CON_TOP_LOG(13);
END P_CMP_MAIN_CON_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_CRT_VIEW_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_CRT_VIEW_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin
     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_CRT_VIEW_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_CRT_VIEW_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
        --      credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_CRT_VIEW_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_IMP_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_IMP_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_IMP_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_IMP_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
     --         credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

end;
end if;

END P_CMP_MAIN_IMP_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_IMP_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_IMP_TOP_CL" is
begin
  P_CMP_MAIN_IMP_TOP(14);
END P_CMP_MAIN_IMP_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_IMP_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_IMP_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_IMP_TOP_LOG(51);
END P_CMP_MAIN_IMP_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_INS_ROL_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_INS_ROL_TOP" (p_run_id NUMBER, p_user VARCHAR2, p_pwd VARCHAR2)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

    if (F_CMP_ADMIN_YN(p_user,p_pwd)=0)
    then begin
      p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
       p_job_name :=UPPER(p_run_char_id||'_CMP_INS_ROL_TOP');
       p_shell_script_name :='CMP_DWH_MAIN_INSTALL_ROLES_TOP.sh';

       select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
       into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
       from cmp_user_param_config
       where run_id = p_run_id;

      begin
        dbms_scheduler.drop_job(job_name => p_job_name,
                               defer => false,
                               force => false);
      exception
        when others then null;
      end;

      dbms_scheduler.create_job(
                job_name   => p_job_name,
                job_type   => 'EXECUTABLE',
                job_action => '/bin/bash',
                number_of_arguments => 11,
                start_date => SYSTIMESTAMP,
                enabled    => FALSE,
                auto_drop     => TRUE,
                repeat_interval => NULL,
       --         credential_name     => 'app_CMP_CRED',
                comments      => 'Job defined by an existing program and schedule.');


      dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
      dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
      dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
      dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
      dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
      dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
      dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
      dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
      dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
      dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
      dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

      dbms_scheduler.enable(p_job_name);
      dbms_scheduler.run_job(p_job_name,FALSE);

   end; end if;

 end;
 end if;

END P_CMP_MAIN_INS_ROL_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_INS_ROL_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_INS_ROL_TOP_CL" is
begin
  P_CMP_MAIN_INS_ROL_TOP(13,'admin','welkom');
END P_CMP_MAIN_INS_ROL_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_INS_ROL_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_INS_ROL_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_INS_ROL_TOP_LOG(13);
END P_CMP_MAIN_INS_ROL_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_NEW_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_NEW_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_NEW_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_NEW_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
             -- credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_NEW_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_NEW_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_NEW_TOP_CL" is
begin
  P_CMP_MAIN_NEW_TOP(5023);
END P_CMP_MAIN_NEW_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_NEW_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_NEW_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_NEW_TOP_LOG(13);
END P_CMP_MAIN_NEW_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_RE_TOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_RE_TOP" (p_run_id NUMBER)
is
p_job_name varchar2(200);
p_compare_bin_dir varchar2(2000);
p_spool_output_dir varchar2(2000);
p_compare_sql_dir varchar2(2000);
p_oracle_home varchar2(2000);
p_ld_library_path varchar2(2000);
p_db_schema varchar2(2000);
p_db_schema_pwd varchar2(2000);
p_db_sid varchar2(2000);
p_run_char_id VARCHAR2(6);
p_ext_ind VARCHAR2(1);
p_shell_script_name varchar2(2000);
l_os_mode varchar2(10);
BEGIN
  l_os_mode :=unix_give_os_mode;

  if l_os_mode='UNIX'
  then begin

     p_run_char_id :=(F_CMP_CONVERT_RUN_ID(p_run_id));
     p_job_name :=UPPER(p_run_char_id||'_CMP_RESTART_TOP');
     p_shell_script_name :='CMP_DWH_MAIN_RESTART_TOP.sh';

     select compare_bin_dir, spool_output_dir, compare_sql_dir, oracle_home, ld_library_path, db_schema, nvl(db_schema_pwd,''), db_sid, ext_ind
     into p_compare_bin_dir, p_spool_output_dir, p_compare_sql_dir, p_oracle_home, p_ld_library_path, p_db_schema, p_db_schema_pwd, p_db_sid, p_ext_ind
     from cmp_user_param_config
     where run_id = p_run_id;

    begin
      dbms_scheduler.drop_job(job_name => p_job_name,
                              defer => false,
                              force => false);
    exception
      when others then null;
    end;

    dbms_scheduler.create_job(
              job_name   => p_job_name,
              job_type   => 'EXECUTABLE',
              job_action => '/bin/bash',
              number_of_arguments => 11,
              start_date => SYSTIMESTAMP,
              enabled    => FALSE,
              auto_drop     => TRUE,
              repeat_interval => NULL,
        --      credential_name     => 'app_CMP_CRED',
              comments      => 'Job defined by an existing program and schedule.');


    dbms_scheduler.set_job_argument_value(p_job_name, 1, p_compare_bin_dir||'/'||p_shell_script_name);
    dbms_scheduler.set_job_argument_value(p_job_name, 2, p_run_char_id);
    dbms_scheduler.set_job_argument_value(p_job_name, 3, p_compare_bin_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 4, p_spool_output_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 5, p_compare_sql_dir);
    dbms_scheduler.set_job_argument_value(p_job_name, 6, p_oracle_home);
    dbms_scheduler.set_job_argument_value(p_job_name, 7, p_ld_library_path);
    dbms_scheduler.set_job_argument_value(p_job_name, 8, p_db_schema);
    dbms_scheduler.set_job_argument_value(p_job_name, 9, p_db_schema_pwd);
    dbms_scheduler.set_job_argument_value(p_job_name, 10, p_db_sid);
    dbms_scheduler.set_job_argument_value(p_job_name, 11, p_ext_ind);

    dbms_scheduler.enable(p_job_name);
    dbms_scheduler.run_job(p_job_name,FALSE);

  end;
  end if;


END P_CMP_MAIN_RE_TOP;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_RE_TOP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_RE_TOP_CL" is
begin
  P_CMP_MAIN_RE_TOP(13);
END P_CMP_MAIN_RE_TOP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_MAIN_RE_TOP_LOG_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_MAIN_RE_TOP_LOG_CL" is
l_result number;
begin
  l_result :=F_CMP_MAIN_RE_TOP_LOG(13);
END P_CMP_MAIN_RE_TOP_LOG_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_DEL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_DEL" (p_run_id_src NUMBER) is
BEGIN
  declare
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select environment, prefix
    from cmp_user_param_config
    where upper(run_id) = upper(p_c_run_id);
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    update cmp_user_cmp_roles
    set status = 'TO_DROP'
    where UPPER(environment)=UPPER(r_user_param_config.environment);
    commit;
  end;
END P_CMP_USER_CMP_ROLES_DEL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_DEL_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_DEL_CL" is
begin
  P_CMP_USER_CMP_ROLES_DEL(13);
END P_CMP_USER_CMP_ROLES_DEL_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_NEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_NEW" (p_run_id_src NUMBER) is
BEGIN
  declare
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select environment, prefix
    from cmp_user_param_config
    where run_id = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    insert into cmp_user_cmp_roles (environment, rolename, status)
    values (upper(r_user_param_config.environment),
            UPPER(r_user_param_config.prefix||'_'||r_user_param_config.environment||'_TESTER'),
            'NEW');
    commit;
  end;
END P_CMP_USER_CMP_ROLES_NEW;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_NEW_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_NEW_CL" is
begin
  P_CMP_USER_CMP_ROLES_NEW(13);
END P_CMP_USER_CMP_ROLES_NEW_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_RM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_RM" (P_USER VARCHAR2,  P_PWD VARCHAR2) is
BEGIN
  if (F_CMP_ADMIN_YN(p_user,p_pwd)=0)
  then begin
    delete from cmp_user_cmp_roles where status = 'DELETED';
    commit;
  end; end if;
END P_CMP_USER_CMP_ROLES_RM;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_ROLES_SYNC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_ROLES_SYNC" is
begin
  update CMP_USER_CMP_ROLES cur
  set status='DELETED'
  where status !='NEW'
  and
  not exists
  (select 1
   from dba_role_privs
   where cur.rolename=granted_role
  );
  update CMP_USER_CMP_ROLES cur
  set status='OKAY'
  where exists
  (select 1
   from dba_role_privs
   where cur.rolename=granted_role
  );
  commit;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USER_ROLES_DEL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USER_ROLES_DEL" (p_user VARCHAR2, p_run_id_src NUMBER) is
BEGIN
  declare
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select environment, prefix
    from cmp_user_param_config
    where upper(run_id) = upper(p_c_run_id);
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    update cmp_user_cmp_user_roles
    set status = 'TO_DROP'
    where rolename=UPPER(r_user_param_config.prefix||'_'||r_user_param_config.environment||'_TESTER')
          and
          UPPER(username)=UPPER(p_user)
          and
          upper(environment)=upper(r_user_param_config.environment);
    commit;
  end;
END P_CMP_USER_CMP_USER_ROLES_DEL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USER_ROLES_NEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USER_ROLES_NEW" (p_user VARCHAR2, p_run_id_src NUMBER) is
BEGIN
  declare
    cursor c_user_param_config(p_c_run_id NUMBER) is
    select environment, prefix
    from cmp_user_param_config
    where run_id = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    insert into cmp_user_cmp_user_roles (rolename, username, status, environment)
    values (UPPER(r_user_param_config.prefix||'_'||upper(r_user_param_config.environment)||'_TESTER'),
            UPPER(p_user),
            'NEW',
            UPPER(r_user_param_config.environment));
    commit;
  end;
END P_CMP_USER_CMP_USER_ROLES_NEW;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USER_ROLES_RM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USER_ROLES_RM" (P_USER VARCHAR2,  P_PWD VARCHAR2) is
BEGIN
  if (F_CMP_ADMIN_YN(p_user,p_pwd)=0)
  then begin
    delete from cmp_user_cmp_user_roles
    where status = 'DELETED';
    commit;
  end; end if;
END P_CMP_USER_CMP_USER_ROLES_RM;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USER_ROLES_SYNC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USER_ROLES_SYNC" is
begin
  update CMP_USER_CMP_USER_ROLES cur
  set status='DELETED'
  where status!='NEW'
  and
  not exists
  (select 1
   from dba_role_privs
   where cur.rolename=granted_role
         and
         cur.username=grantee
  );
  update CMP_USER_CMP_USER_ROLES cur
  set status='OKAY'
  where exists
  (select 1
   from dba_role_privs
   where cur.rolename=granted_role
         and
         cur.username=grantee
  );
  commit;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USERS_SYNC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USERS_SYNC" is
begin
  insert into cmp_user_cmp_users (username, cmp_user_yn)
  select username, 'N'
  from all_users alu
     where not exists
     (select 1
     from cmp_user_cmp_users cuc
      where alu.username=cuc.username);
  delete from cmp_user_cmp_user_roles cur
  where not exists
  (select 1
  from cmp_user_cmp_users
  where cur.username=username
  );
  update cmp_user_cmp_users cuc
  set cmp_user_yn='J'
  where exists
  (select 1
   from cmp_user_cmp_user_roles cur
   where cuc.username=cur.username);
  update cmp_user_cmp_users cuc
  set cmp_user_yn='N'
  where not exists
  (select 1
   from cmp_user_cmp_user_roles cur
   where cuc.username=cur.username);
  commit;

end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USR_ROL_DEL_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USR_ROL_DEL_CL" is
begin
  P_CMP_USER_CMP_USER_ROLES_DEL('analist_1',13);
END P_CMP_USER_CMP_USR_ROL_DEL_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CMP_USR_ROL_NEW_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CMP_USR_ROL_NEW_CL" is
begin
  P_CMP_USER_CMP_USER_ROLES_NEW('analist_1',13);
END P_CMP_USER_CMP_USR_ROL_NEW_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTR_LOAD_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTR_LOAD_CL" is
BEGIN
  p_cmp_user_constraints_load(f_cmp_convert_run_id(13),f_cmp_convert_run_id(13));
END P_CMP_USER_CONSTR_LOAD_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTR_REUSE_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTR_REUSE_CL" is
BEGIN
  p_cmp_user_constraints_reuse(f_cmp_convert_run_id(13),f_cmp_convert_run_id(13));
END P_CMP_USER_CONSTR_REUSE_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTR_SAVE_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTR_SAVE_CL" IS
BEGIN
 P_CMP_USER_CONSTRAINTS_SAVE(f_cmp_convert_run_id(83), 'nieuw voor test');
END P_CMP_USER_CONSTR_SAVE_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_ANL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_ANL" (p_run_id varchar2) IS
BEGIN
  delete from cmp_user_constraints_anl where run_id=p_run_id;
  commit;
  insert into cmp_user_constraints_anl(TAB,
                                       COL,
                                       POS,
                                       MAXPOS,
                                       UNQ_CONS,
                                       UNQ_CONS_ID,
	                                     TEC_UNQ_CONS,
                                       TEC_UNQ_CONS_ID,
                                       FK_CONS,
                                       FK_CONS_ID,
	                                     FK_TAB,
                                       FK_COL,
                                       EXCLUDE_COL,
                                       NON_STND_TEC_COL,
                                       RUN_ID)
  select us.TAB,
         us.COL,
         ust.pos,
         ust.maxpos,
         ust.UNQ_CONS,
         ust.UNQ_CONS_ID,
         ust.TEC_UNQ_CONS,
         ust.TEC_UNQ_CONS_ID,
         ust.FK_CONS,
         ust.FK_CONS_ID,
         ust.FK_TAB,
         ust.FK_COL,
         ust.EXCLUDE_COL,
         ust.NON_STND_TEC_COL,
         p_run_id
  from cmp_user_constraints us, cmp_user_constraints_tmp ust
  where us.tab=ust.tab(+)
        and
        us.col=ust.col(+)
        and
        us.run_id=ust.run_id(+)
        and
        us.run_id=p_run_id;

  commit;
END P_CMP_USER_CONSTRAINTS_ANL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_FK_COLS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_FK_COLS" (p_run_id varchar2) is
BEGIN
  update CMP_USER_CONSTRAINTS cuc
  set fk_col = (select cuc2.col
                from CMP_USER_CONSTRAINTS cuc2
                where cuc.fk_tab=cuc2.tab
                      and
                      cuc2.tec_unq_cons=1
                      and
                      cuc2.run_id=p_run_id
                      and
                      rownum<2)
  where cuc.run_id=p_run_id;
  commit;
END P_CMP_USER_CONSTRAINTS_FK_COLS;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_INIT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_INIT" (p_run_id varchar2) is
begin
  declare
    cursor c_user_constraints(p_c_run_id VARCHAR2, par_unq_cons NUMBER, par_tec_unq_cons NUMBER, par_fk_cons NUMBER, par_exclude_col NUMBER, par_non_stnd_tec_col NUMBER, par_left_col_ind NUMBER, par_right_col_ind NUMBER) is
      select *
      from CMP_USER_CONSTRAINTS
      where run_id=p_c_run_id
            and
            (
              (nvl(unq_cons,'0') != 0 and par_unq_cons=1)
              or
              (nvl(tec_unq_cons,'0') != 0 and par_tec_unq_cons=1)
              or
              (nvl(fk_cons,'0') != 0 and par_fk_cons=1)
              or
              (nvl(exclude_col,'0') != 0 and par_exclude_col=1)
              or
              (nvl(non_stnd_tec_col,'0') != 0 and par_non_stnd_tec_col=1)
              or
              (nvl(left_col_ind,'0') != 0 and par_left_col_ind=1)
              or
              (nvl(right_col_ind,'0') != 0 and par_right_col_ind=1)
            )
      order by tab, col;
      r_user_constraints c_user_constraints%rowtype;
    cursor c_user_max_constraints(p_c_run_id VARCHAR2, par_unq_cons NUMBER, par_tec_unq_cons NUMBER, par_fk_cons NUMBER, par_tab VARCHAR2) is
      select count(*) as max_cons
      from CMP_USER_CONSTRAINTS
      where (((nvl(unq_cons,'0') != 0) and par_unq_cons=1)
              or
              ((nvl(tec_unq_cons,'0') != 0) and par_tec_unq_cons=1)
              or
              ((nvl(fk_cons,'0') != 0) and par_fk_cons=1))
            and
            par_tab=tab
            and
            p_c_run_id=run_id;
    r_user_max_constraints c_user_max_constraints%rowtype;
    temp_tab VARCHAR2(30);
    pos NUMBER(6,0);
    maxpos NUMBER(6,0);
    cnt_unq_cons NUMBER(5,0);
    cnt_tec_unq_cons NUMBER(5,0);
    cnt_fk_cons NUMBER(5,0);
  begin
    delete from CMP_USER_CONSTRAINTS_TMP where run_id=p_run_id;
    open c_user_constraints(p_run_id,1,1,1,1,1,1,1);
    pos :=1;
    cnt_unq_cons :=0;
    cnt_tec_unq_cons :=0;
    cnt_fk_cons :=0;
    loop
      fetch c_user_constraints into r_user_constraints;
      exit when c_user_constraints%NOTFOUND;
      if r_user_constraints.tab != nvl(temp_tab,'tab') then
        pos :=0;
        open c_user_max_constraints(p_run_id,1,0,0,r_user_constraints.tab);
        fetch c_user_max_constraints into r_user_max_constraints;
        if c_user_max_constraints%FOUND then
          maxpos :=r_user_max_constraints.max_cons;
        else
          maxpos :=0;
        end if;
        close c_user_max_constraints;
      end if;
      if r_user_constraints.unq_cons=1 then
        pos :=pos+1;
      end if;
      if (r_user_constraints.unq_cons=1 and pos=1) then cnt_unq_cons := F_FREE_CMPUNQ_CONS('CMP'); end if;
      if r_user_constraints.tec_unq_cons=1 then cnt_tec_unq_cons := F_FREE_CMPREFUNQ_CONS('CMP'); end if;
      if r_user_constraints.fk_cons=1 then cnt_fk_cons := F_FREE_CMPREF_CONS('CMP'); end if;
      temp_tab :=r_user_constraints.tab;
      insert into CMP_USER_CONSTRAINTS_TMP
        (TAB, COL, POS, MAXPOS,
        UNQ_CONS, UNQ_CONS_ID,
        TEC_UNQ_CONS, TEC_UNQ_CONS_ID,
        FK_CONS, FK_CONS_ID,
        FK_TAB,
        FK_COL,
        EXCLUDE_COL,
        NON_STND_TEC_COL,
        LEFT_COL_IND,
        RIGHT_COL_IND,
        RUN_ID)
        values
        (r_user_constraints.tab, r_user_constraints.col,
         decode(r_user_constraints.unq_cons,1,pos,0), decode(r_user_constraints.unq_cons,1,maxpos,0),
        r_user_constraints.unq_cons , decode(r_user_constraints.unq_cons,1,'CMPUNQ'||substr(to_char(cnt_unq_cons,'09999'),2,5),''),
        r_user_constraints.tec_unq_cons, decode(r_user_constraints.tec_unq_cons,1,'CMPREFUNQ'||substr(to_char(cnt_tec_unq_cons,'09999'),2,5),''),
        r_user_constraints.fk_cons, decode(r_user_constraints.fk_cons,1,'CMPREF'||substr(to_char(cnt_fk_cons,'09999'),2,5),''),
        r_user_constraints.fk_tab,
        r_user_constraints.fk_col,
        r_user_constraints.exclude_col,
        r_user_constraints.non_stnd_tec_col,
        r_user_constraints.left_col_ind,
        r_user_constraints.right_col_ind,
        p_run_id
        );
    end loop;
    close c_user_constraints;
    commit;
  end;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_LOAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_LOAD" (p_run_id_src varchar2,p_run_id_dst varchar2) is
BEGIN
  declare
    cursor c_user_constraints_lib(p_environment varchar2, p_db_schema varchar2, p_prefix varchar2, p_left_suffix varchar2, p_right_suffix varchar2) is
    select *
    from CMP_user_constraints_lib
    where upper(p_environment)=upper(environment)
          and
          upper(p_db_schema)=upper(db_schema)
          and
          upper(p_prefix)=upper(prefix)
          and
          upper(p_left_suffix)=upper(left_suffix)
          and
          upper(p_right_suffix)=upper(right_suffix);
    r_user_constraints_lib c_user_constraints_lib%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select environment, db_schema, prefix, left_suffix, right_suffix
    from cmp_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
    p_cmp_user_logging(sysdate, 'p_cmp_user_constraints_load', 'p1');
    delete from cmp_user_constraints where run_id=p_run_id_dst;
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    open c_user_constraints_lib(r_user_param_config.environment,r_user_param_config.db_schema,r_user_param_config.prefix,r_user_param_config.left_suffix,r_user_param_config.right_suffix);
    loop
      fetch c_user_constraints_lib into r_user_constraints_lib;
      exit when c_user_constraints_lib%NOTFOUND;

      insert into cmp_user_constraints
      (TAB,
      COL,
      UNQ_CONS,
      TEC_UNQ_CONS,
      FK_CONS,
      FK_TAB,
      FK_COL,
      EXCLUDE_COL,
      NON_STND_TEC_COL,
      LEFT_COL_IND,
      RIGHT_COL_IND,
      RUN_ID)
      values
      (r_user_constraints_lib.TAB,
      r_user_constraints_lib.COL,
	    r_user_constraints_lib.UNQ_CONS,
      r_user_constraints_lib.TEC_UNQ_CONS,
      r_user_constraints_lib.FK_CONS,
	    r_user_constraints_lib.FK_TAB,
  	  r_user_constraints_lib.FK_COL,
	    r_user_constraints_lib.EXCLUDE_COL,
	    r_user_constraints_lib.NON_STND_TEC_COL,
      r_user_constraints_lib.LEFT_COL_IND,
      r_user_constraints_lib.RIGHT_COL_IND,
      p_run_id_dst);


    end loop;
    close c_user_param_config;
  end;
  commit;
END P_CMP_USER_CONSTRAINTS_LOAD;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_REUSE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_REUSE" (p_run_id_src varchar2, p_run_id_dst varchar2) is
BEGIN
  declare
    cursor c_user_constraints_lib(p_environment varchar2, p_db_schema varchar2, p_prefix varchar2, p_left_suffix varchar2, p_right_suffix varchar2) is
    select *
    from CMP_user_constraints_lib
    where upper(p_environment)=upper(environment)
          and
          upper(p_db_schema)=upper(db_schema)
          and
          upper(p_prefix)=upper(prefix)
          and
          upper(p_left_suffix)=upper(left_suffix)
          and
          upper(p_right_suffix)=upper(right_suffix);
    r_user_constraints_lib c_user_constraints_lib%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select environment, db_schema, prefix, left_suffix, right_suffix
    from cmp_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
    p_cmp_user_logging(sysdate, 'p_cmp_user_constraints_reuse', 'p1');
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    open c_user_constraints_lib(r_user_param_config.environment,r_user_param_config.db_schema,r_user_param_config.prefix,r_user_param_config.left_suffix,r_user_param_config.right_suffix);
    loop
      fetch c_user_constraints_lib into r_user_constraints_lib;
      exit when c_user_constraints_lib%NOTFOUND;

       update cmp_user_constraints uca
       set uca.UNQ_CONS = r_user_constraints_lib.UNQ_CONS,
	         uca.TEC_UNQ_CONS = r_user_constraints_lib.TEC_UNQ_CONS,
           uca.FK_CONS = r_user_constraints_lib.FK_CONS,
	         uca.FK_TAB = r_user_constraints_lib.fk_tab,
           uca.FK_COL = r_user_constraints_lib.fk_col,
	         uca.EXCLUDE_COL = r_user_constraints_lib.EXCLUDE_COL,
	         uca.NON_STND_TEC_COL = r_user_constraints_lib.NON_STND_TEC_COL
       where upper(r_user_constraints_lib.tab)=upper(uca.tab)
             and
             upper(r_user_constraints_lib.col)=upper(uca.col)
             and
             run_id=p_run_id_dst;


    end loop;
    close c_user_param_config;
  end;
  commit;
END P_CMP_USER_CONSTRAINTS_REUSE;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_CONSTRAINTS_SAVE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_CONSTRAINTS_SAVE" (p_run_id varchar2, p_in_description varchar2) IS
BEGIN
  declare
    cursor c_user_constraints(p_c_run_id varchar2) is
    select * from CMP_user_constraints
    where run_id=p_c_run_id;
    r_user_constraints c_user_constraints%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select * from CMP_user_param_config
    where upper(f_cmp_convert_run_id(run_id)) = upper(p_c_run_id);
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    delete from cmp_user_constraints_lib clib
    where upper(r_user_param_config.ENVIRONMENT)=upper(ENVIRONMENT)
          and
	        upper(r_user_param_config.db_schema)=upper(db_schema)
	        and
          upper(r_user_param_config.prefix)=upper(prefix)
	        and
          upper(r_user_param_config.left_suffix)=upper(left_suffix)
	        and
          upper(r_user_param_config.right_suffix)=upper(right_suffix)
          and
          exists (select 1
                  from cmp_user_constraints ucs
                  where  upper(run_id)=p_run_id
                         and
                         clib.tab=ucs.tab);

    open c_user_constraints(p_run_id);
    loop
      fetch c_user_constraints into r_user_constraints;
      exit when c_user_constraints%NOTFOUND;

      insert into cmp_user_constraints_lib
      (ENVIRONMENT,
	     DB_SCHEMA,
	     PREFIX,
	     LEFT_SUFFIX,
	     RIGHT_SUFFIX,
	     TAB,
	     COL,
	     UNQ_CONS,
	     TEC_UNQ_CONS,
	     FK_CONS,
	     FK_TAB,
	     FK_COL,
	     EXCLUDE_COL,
	     NON_STND_TEC_COL,
       LEFT_COL_IND,
       RIGHT_COL_IND,
	     DESCRIPTION)
       values
       (upper(r_user_param_config.ENVIRONMENT),
	     upper(r_user_param_config.db_schema),
	     upper(r_user_param_config.prefix),
	     upper(r_user_param_config.left_suffix),
	     upper(r_user_param_config.right_suffix),
	     upper(r_user_constraints.TAB),
	     upper(r_user_constraints.COL),
	     r_user_constraints.UNQ_CONS,
	     r_user_constraints.TEC_UNQ_CONS,
	     r_user_constraints.FK_CONS,
	     r_user_constraints.FK_TAB,
	     r_user_constraints.FK_COL,
	     r_user_constraints.EXCLUDE_COL,
	     r_user_constraints.NON_STND_TEC_COL,
	     r_user_constraints.LEFT_COL_IND,
	     r_user_constraints.RIGHT_COL_IND,
	     p_in_description);

    end loop;
    close c_user_constraints;
  end;
  commit;
END P_CMP_USER_CONSTRAINTS_SAVE;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_LOGGING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_LOGGING" (p_datetime date, p_function varchar2, p_message varchar2) is
begin
  --insert into cmp_user_logging (counter,datetime, function, message)
  --values (seq_cmp_log.nextval,p_datetime, p_function, p_message);
  --commit;
  NULL;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_PARAM_CONF_CP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_PARAM_CONF_CP_CL" (p_in_run_id number) is
l_new_run_id number;
begin
  l_new_run_id :=F_CMP_USER_PARAM_CONFIG_COPY(12,null,'EMPTY','EMPTY','call from p_cmp_user_param_conf_cp_cl','DIRECT CALL','EMPTY','EMPTY');
END P_CMP_USER_PARAM_CONF_CP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_CLN_LIB_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_CLN_LIB_CL" (p_run_id varchar2) is
BEGIN
  P_CMP_USER_SELECTION_CLN_LIB(f_cmp_convert_run_id(14));
END P_CMP_USER_SEL_CLN_LIB_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_IMP_CHECK_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_IMP_CHECK_CL" is
BEGIN
  P_CMP_USER_SELECTION_IMP_CHECK(f_cmp_convert_run_id(14),'A01P01P1');
END P_CMP_USER_SEL_IMP_CHECK_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_IMP_FMT_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_IMP_FMT_CL" is
begin
  P_CMP_USER_SELECTION_IMP_FMT(f_cmp_convert_run_id(13),1,3,8,99);
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_IMP_LOAD_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_IMP_LOAD_CL" is
BEGIN
  p_cmp_user_selection_imp_load(f_cmp_convert_run_id(13),f_cmp_convert_run_id(12));
END P_CMP_USER_SEL_IMP_LOAD_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_IMP_RESUSE_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_IMP_RESUSE_CL" is
BEGIN
  P_CMP_USER_SELECTION_IMP_REUSE(f_cmp_convert_run_id(14),f_cmp_convert_run_id(12));
END P_CMP_USER_SEL_IMP_RESUSE_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SEL_IMP_SAVE_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SEL_IMP_SAVE_CL" is
begin
  P_CMP_USER_SELECTION_IMP_SAVE(f_cmp_convert_run_id(14),'Dit is testset xyz...');
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_CLN_LIB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_CLN_LIB" (p_run_id varchar2) is
BEGIN
  declare
    cursor c_user_param_config(p_c_run_id varchar2) is
    select right_suffix
    from cmp_user_param_config
    where upper(f_cmp_convert_run_id(run_id)) = upper(p_c_run_id);
    r_user_param_config c_user_param_config%rowtype;
  begin
    if F_CMP_USER_SEL_CLN_YN(f_cmp_reconvert_RUN_ID(p_run_id))=0
    then
      open c_user_param_config(p_run_id);
      fetch c_user_param_config into r_user_param_config;
      close c_user_param_config;

      delete from cmp_user_param_config
      where nvl(left_suffix,'na')=r_user_param_config.right_suffix
            or
            nvl(right_suffix,'123456789')=r_user_param_config.right_suffix;
      delete from cmp_user_constraints_lib
      where nvl(left_suffix,'na')=r_user_param_config.right_suffix
            or
          nvl(right_suffix,'123456789')=r_user_param_config.right_suffix;
      delete from cmp_user_import_tables_lib
      where nvl(suffix,'na')=r_user_param_config.right_suffix;
      commit;
      end if;
    end;
END P_CMP_USER_SELECTION_CLN_LIB;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_CHECK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_CHECK" (p_run_id varchar2, P_SUFFIX_RIGHT varchar2) IS
BEGIN
declare
   cursor c_user_param_config(p_c_run_id varchar2) is
    select environment, db_schema, prefix, left_suffix, src_schema
    from cmp_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
begin
  p_cmp_user_logging(sysdate,'p_cmp_user_selection_imp_check','before cursor'||P_RUN_ID||' '||P_SUFFIX_RIGHT);

  open c_user_param_config(p_run_id);
  fetch c_user_param_config into r_user_param_config;
  close c_user_param_config;

  update CMP_USER_IMPORT_TABLES u1
  set NOT_UNIQUE_YN=0
  where upper(u1.run_id)=upper(p_run_id);

  update CMP_USER_IMPORT_TABLES u1
  set NOT_UNIQUE_YN=1
  where  1 < (select count(*)
            from CMP_USER_IMPORT_TABLES u2
            where upper(u1.dst_tab_body)=upper(u2.dst_tab_body)
                  and
                  upper(u1.run_id)=upper(u2.run_id))
         and
         upper(u1.run_id)=upper(p_run_id);

  update CMP_USER_IMPORT_TABLES u1
  set NOMATCH_YN=0
  where upper(u1.run_id)=upper(p_run_id);

  p_cmp_user_logging(sysdate,'p_cmp_user_selection_imp_check','before nomatch '||P_RUN_ID||' '||P_SUFFIX_RIGHT);

  update CMP_USER_IMPORT_TABLES u1
  set NOMATCH_YN=1
  where not exists (select 1
                    from CMP_USER_IMPORT_TABLES_LIB u2
                    where  upper(r_user_param_config.environment)=upper(u2.environment)
                           and
                           upper(P_SUFFIX_RIGHT)=upper(u2.suffix)
                           and
                           upper(u1.dst_tab_body)=upper(u2.dst_tab_body))
  and
  upper(u1.run_id)=upper(p_run_id);

  update CMP_USER_IMPORT_TABLES u1
  set DST_TAB_TOO_LONG_YN=0
  where upper(u1.run_id)=upper(p_run_id);

  update CMP_USER_IMPORT_TABLES u1
  set DST_TAB_TOO_LONG_YN=1
  where upper(u1.run_id)=upper(p_run_id)
        and
        (length(u1.dst_tab_prefix||'_'||u1.dst_tab_body||'_'||u1.dst_tab_suffix) > 30);
  commit;
  p_cmp_user_logging(sysdate,'p_cmp_user_selection_imp_check','after commit');
end;
END P_CMP_USER_SELECTION_IMP_CHECK;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_CL" is
BEGIN
  p_cmp_user_selection_imp_reuse(f_cmp_convert_run_id(13),f_cmp_convert_run_id(12));
END P_CMP_USER_SELECTION_IMP_CL;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_FMT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_FMT" (p_run_id varchar2, p_start_pos1 NUMBER, p_stop_pos1 NUMBER, p_start_pos2 NUMBER, p_stop_pos2 NUMBER) is
begin
  declare
  cursor c_user_param_config(p_c_run_id NUMBER) is
  select *
  from cmp_user_param_config
  where upper(p_c_run_id)=upper(run_id);
  r_user_param_config c_user_param_config%rowtype;
  begin
    p_cmp_user_logging(sysdate,'p_cmp_user_selection_imp_fmt',P_RUN_ID||' '||to_char(P_START_POS1,'999999')||' '||to_char(P_STOP_POS1,'999999')||' '||to_char(P_START_POS2,'999999')||' '||to_char(P_STOP_POS2,'999999'));
    open c_user_param_config(F_CMP_RECONVERT_RUN_ID(p_run_id));
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    p_cmp_user_logging(sysdate,'p_cmp_user_selection_imp_fmt','after cursor and before update');
    update CMP_USER_IMPORT_TABLES
    set DST_TAB_BODY=substr(src_tab,p_start_pos1,(p_stop_pos1-p_start_pos1)+1)||
               decode(p_start_pos2,0,'',substr(src_tab,p_start_pos2,(p_stop_pos2-p_start_pos2)+1))
    where upper(run_id)=upper(p_run_id);
    commit;
  end;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_LOAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_LOAD" (p_run_id_src varchar2,p_run_id_dst varchar2) is
BEGIN
  declare
    cursor c_user_selection_imp_lib(p_environment varchar2, p_db_schema varchar2, p_src_schema varchar2, p_suffix varchar2) is
    select *
    from CMP_user_import_tables_lib
    where upper(p_environment)=upper(environment)
          and
          upper(p_db_schema)=upper(db_schema)
          and
          upper(p_src_schema)=upper(src_schema)
          and
          upper(p_suffix)=upper(suffix);
    r_user_selection_imp_lib c_user_selection_imp_lib%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select environment, db_schema, prefix, right_suffix, src_schema
    from cmp_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
    r_user_param_config_dst c_user_param_config%rowtype;
    l_cnt_imp_tab number;
  begin
    open c_user_param_config(p_run_id_dst);
    fetch c_user_param_config into r_user_param_config_dst;
    close c_user_param_config;

    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    open c_user_selection_imp_lib(r_user_param_config.environment,r_user_param_config.db_schema,r_user_param_config.src_schema,r_user_param_config.right_suffix);
    loop
      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_load', 'before cursor c_user_selection_imp_lib '||r_user_param_config.environment||' '||r_user_param_config.db_schema||' ' ||r_user_param_config.src_schema||' ' ||r_user_param_config.right_suffix);

      fetch c_user_selection_imp_lib into r_user_selection_imp_lib;
      exit when c_user_selection_imp_lib%NOTFOUND;

      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_load', 'after cursor c_user_selection_imp_lib '||r_user_selection_imp_lib.SRC_TAB||' '||p_run_id_dst);

      select count(*)
      into l_cnt_imp_tab
      from CMP_USER_IMPORT_TABLES
      where upper(SRC_TAB)=upper(r_user_selection_imp_lib.SRC_TAB)
            and
            upper(DST_TAB_PREFIX)=upper(r_user_param_config_dst.environment)
            and
            upper(run_id)=upper(p_run_id_dst);


      if l_cnt_imp_tab=0
      then
        insert into CMP_USER_IMPORT_TABLES
        (SRC_TAB,
        IN_SCOPE,
        DST_TAB_PREFIX,
        DST_TAB_BODY,
        DST_TAB_SUFFIX,
        NOMATCH_YN,
        NOT_UNIQUE_YN,
        DST_TAB_TOO_LONG_YN,
        RUN_ID
        )
        values
        (
        r_user_selection_imp_lib.SRC_TAB,
        -1,
        r_user_param_config_dst.environment,
        r_user_selection_imp_lib.DST_TAB_BODY,
        r_user_param_config_dst.right_suffix,
        0,
        0,
        0,
        p_run_id_dst
        );
     end if;
    end loop;
    close c_user_param_config;
    close c_user_selection_imp_lib;
  end;
  commit;
  P_CMP_USER_SELECTION_IMP_REUSE(p_run_id_src, p_run_id_dst);
END P_CMP_USER_SELECTION_IMP_LOAD;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_REUSE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_REUSE" (p_run_id_src varchar2, p_run_id_dst varchar2) is
BEGIN
  declare
    cursor c_user_selection_imp_lib(p_environment varchar2, p_db_schema varchar2, p_src_schema varchar2, p_suffix varchar2) is
    select *
    from CMP_user_import_tables_lib
    where upper(p_environment)=upper(environment)
          and
          upper(p_db_schema)=upper(db_schema)
          and
          upper(p_src_schema)=upper(src_schema)
          and
          upper(p_suffix)=upper(suffix);
    r_user_selection_imp_lib c_user_selection_imp_lib%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select environment, db_schema, prefix, right_suffix, src_schema
    from cmp_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
   begin
    open c_user_param_config(p_run_id_src);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    open c_user_selection_imp_lib(r_user_param_config.environment,r_user_param_config.db_schema,r_user_param_config.src_schema,r_user_param_config.right_suffix);
    loop
      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_reuse', 'before cursor c_user_selection_imp_lib '||r_user_param_config.environment||' '||r_user_param_config.db_schema||' ' ||r_user_param_config.src_schema||' ' ||r_user_param_config.right_suffix);

      fetch c_user_selection_imp_lib into r_user_selection_imp_lib;
      exit when c_user_selection_imp_lib%NOTFOUND;

      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_reuse', 'after cursor c_user_selection_imp_lib '||r_user_selection_imp_lib.SRC_TAB||' '||p_run_id_dst);

       update cmp_user_import_tables uca
       set uca.DST_TAB_BODY = r_user_selection_imp_lib.DST_TAB_BODY
       where upper(r_user_selection_imp_lib.SRC_TAB)=upper(uca.SRC_TAB)
             and
             upper(run_id)=upper(p_run_id_dst);



    end loop;
    close c_user_selection_imp_lib;
  end;
  commit;
END P_CMP_USER_SELECTION_IMP_REUSE;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_IMP_SAVE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_IMP_SAVE" (p_run_id varchar2, p_in_description varchar2) IS
BEGIN
  declare
    cursor c_user_selection_imp(p_c_run_id varchar2) is
    select * from CMP_user_import_tables
    where upper(run_id)=upper(p_c_run_id)
          and
          in_scope=1;
    r_user_selection_imp c_user_selection_imp%rowtype;
    cursor c_user_param_config(p_c_run_id varchar2) is
    select * from CMP_user_param_config
    where f_cmp_convert_run_id(run_id) = p_c_run_id;
    r_user_param_config c_user_param_config%rowtype;
  begin
    open c_user_param_config(p_run_id);
    fetch c_user_param_config into r_user_param_config;
    close c_user_param_config;
    delete from cmp_user_import_tables_lib
    where upper(r_user_param_config.ENVIRONMENT)=upper(ENVIRONMENT)
          and
	        upper(r_user_param_config.db_schema)=upper(db_schema)
	        and
          upper(r_user_param_config.right_suffix)=upper(suffix);

    open c_user_selection_imp(p_run_id);
    loop

      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_save', 'before cursor c_user_selection_imp_lib '||p_run_id);

      fetch c_user_selection_imp into r_user_selection_imp;
      exit when c_user_selection_imp%NOTFOUND;

      p_cmp_user_logging(sysdate, 'p_cmp_user_selection_imp_save', 'after cursor c_user_selection_imp_lib '||r_user_param_config.environment||' '||r_user_param_config.db_schema||' ' ||r_user_param_config.src_schema||' ' ||r_user_param_config.right_suffix);

      insert into cmp_user_import_tables_lib
      (ENVIRONMENT,
	     DB_SCHEMA,
       SRC_SCHEMA,
	     SUFFIX,
	     SRC_TAB,
       DST_TAB_PREFIX,
	     DST_TAB_BODY,
       DST_TAB_SUFFIX,
	     DESCRIPTION)
       values
       (r_user_param_config.ENVIRONMENT,
        r_user_param_config.DB_SCHEMA,
        r_user_param_config.SRC_SCHEMA,
        r_user_param_config.RIGHT_SUFFIX,
        r_user_selection_imp.SRC_TAB,
        r_user_selection_imp.DST_TAB_PREFIX,
        r_user_selection_imp.DST_TAB_BODY,
        r_user_selection_imp.DST_TAB_SUFFIX,
        p_in_description);

    end loop;
    close c_user_selection_imp;
  end;
  commit;
END P_CMP_USER_SELECTION_IMP_SAVE;
/
--------------------------------------------------------
--  DDL for Procedure P_CMP_USER_SELECTION_INIT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_CMP_USER_SELECTION_INIT" (p_run_id varchar2) is
begin
  declare
    cursor c_user_selection(p_c_run_id varchar2) is
    select *
    from CMP_USER_SELECTION_TABLES
    where in_scope>0
          and
          run_id=p_c_run_id
          and
          not exists (select 1 from CMP_USER_SELECTION_TABLES_TMP where run_id=p_c_run_id)
          order by order_ascending;
    r_user_selection c_user_selection%rowtype;
    i NUMBER(6,0);
  begin
    i :=0;
    open c_user_selection(p_run_id);
    loop
      fetch c_user_selection into r_user_selection;
      exit when c_user_selection%NOTFOUND;
      i :=i+1;
      insert into CMP_USER_SELECTION_TABLES_TMP (TAB, IN_SCOPE, ORDER_ASCENDING,RUN_ID)
      values (r_user_selection.tab, r_user_selection.in_scope, i, r_user_selection.run_id);
    end loop;
    close c_user_selection;
    commit;
  end;
end;
/
--------------------------------------------------------
--  DDL for Procedure P_SCHED_TEST_SIMPLE_STEP1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_SCHED_TEST_SIMPLE_STEP1" AS
l_job_name varchar2(200);
BEGIN
   l_job_name :=UPPER('SCHEDTESTSIMPLE1');

  begin
    dbms_scheduler.drop_job(job_name => l_job_name,
                            defer => false,
                            force => false);
  exception
    when others then null;
  end;

  dbms_scheduler.create_job(
            job_name   => l_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/bin/bash',
            enabled    => TRUE);

  -- bekijk het resultaat in select * from all_scheduler_job_run_details order by log_id desc;

END P_SCHED_TEST_SIMPLE_STEP1;
/
--------------------------------------------------------
--  DDL for Procedure P_SCHED_TEST_SIMPLE_STEP2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_SCHED_TEST_SIMPLE_STEP2" AS
l_job_name varchar2(200);
BEGIN
   l_job_name :=UPPER('SCHEDTESTSIMPLE2');

  begin
    dbms_scheduler.drop_job(job_name => l_job_name,
                            defer => false,
                            force => false);
  exception
    when others then null;
  end;

  -- maak het onderstaande shell script in /tmp aan
  --  #!/bin/bash
  -- whoami > /tmp/looksched.lst
  --

  dbms_scheduler.create_job(
            job_name   => l_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/tmp/looksched.sh',
            enabled    => TRUE);

    -- bekijk het resultaat in select * from all_scheduler_job_run_details order by log_id desc;

END P_SCHED_TEST_SIMPLE_STEP2;
/
--------------------------------------------------------
--  DDL for Procedure P_SCHED_TEST_SIMPLE_STEP3
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "P_SCHED_TEST_SIMPLE_STEP3" AS
l_job_name varchar2(200);
BEGIN
  l_job_name :=UPPER('SCHEDTESTSIMPLE3');

  begin
    dbms_scheduler.drop_job(job_name => l_job_name,
                            defer => false,
                            force => false);
  exception
    when others then null;
  end;

  dbms_scheduler.create_job(
            job_name   => l_job_name,
            job_type   => 'EXECUTABLE',
            job_action => '/tmp/looksched.sh',
            enabled    => TRUE--,
 --           credential_name     => 'app_CMP_CRED'
            );

  -- bekijk het resultaat in select * from all_scheduler_job_run_details order by log_id desc;


END P_SCHED_TEST_SIMPLE_STEP3;
/
