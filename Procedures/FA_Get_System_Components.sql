create or replace 
procedure FA_Get_System_Components(
  refcur_SYSTEM_Components OUT sys_refcursor,
  pc_Option     in number,
  pc_where     in varchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_System_Components
--Date written	   : 6-09-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get 
--                                                            
--Program Inputs   : refer to the parameter list.
--Program outputs  : get data
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :                                             
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------     

------------------------------------------------------------------------------

 as
 Sql_Statement Varchar2(8000);
 
 Base_emp_id number;
 emp_id number;
 vr_USER_ID number;
 begin
 if pc_Option=0 then
 
 Sql_Statement := 'SELECT SG_ID,SG_GROUP_TITLE FROM FA_SYSTEM_GROUPS  where SG_GROUP_DELETED=0 '||pc_where;
 open refcur_SYSTEM_Components for Sql_Statement;
 
 elsif pc_Option=1 then
 
 Sql_Statement := 'SELECT SSG_ID,SSG_TITLE,GROUP_ID FROM FA_SYSTEM_SUB_GROUP where SSG_DELETED=0 and SSG_ID!=4 '||pc_where;
 open refcur_SYSTEM_Components for Sql_Statement;
 
 
 elsif pc_Option=2 then
 
 Sql_Statement := 'SELECT SF_ID,SF_FORM_AR_NAME,BTN_ID FROM FA_SYSTEM_FORMS where SF_DELETED=0 '||pc_where||' order by BTN_ID';
 open refcur_SYSTEM_Components for Sql_Statement;
 
  elsif pc_Option=3 then
 
 Sql_Statement := 'SELECT emp.OE_ID OE_ID,emp.OE_EMP_NAME OE_EMP_NAME FROM FA_OWER_EMPLOYEE emp
inner join FA_SYSTEM_USERS us on emp.OE_ID=us.EMP_ID
where emp.OE_STATUS=0 and us.SU_USER_ID not in (select distinct( SU_ID) from FA_SYSTEM_USER_PRIVILEGE )
  order by emp.OE_ID ';
 open refcur_SYSTEM_Components for Sql_Statement;
 
   elsif pc_Option=4 then
 
 Sql_Statement := 'SELECT emp.OE_ID OE_ID,emp.OE_EMP_NAME OE_EMP_NAME FROM FA_OWER_EMPLOYEE emp
inner join FA_SYSTEM_USERS us on emp.OE_ID=us.EMP_ID
where emp.OE_STATUS=0 and us.SU_USER_ID  in (select distinct( SU_ID) from FA_SYSTEM_USER_PRIVILEGE )
  order by emp.OE_ID ';
 open refcur_SYSTEM_Components for Sql_Statement;
 
   elsif pc_Option=5 then
 
 Sql_Statement := 'SELECT nvl(max(SSGF_ID),0)+1 MaxNo FROM FA_SYSTEM_SUBG_FORM';
 open refcur_SYSTEM_Components for Sql_Statement;
 
    elsif pc_Option=6 then
 --'121/521' Base_emp_id/emp_id
-- select substr(pc_where,1,to_number(instr(pc_where,'/'))-1) into Base_emp_id from dual;
 --select substr(pc_where,to_number(instr(pc_where,'/'))+1) into emp_id from dual;
 --select SU_USER_ID into vr_USER_ID from FA_SYSTEM_USERS where emp_id=emp_id;
 
 --insert into FA_SYSTEM_USER_PRIVILEGE SELECT PRIVILEGE_SEQ_NO.NEXTVAL as SUP_ID, vr_USER_ID, SFG_ID,SUP_DELETED 
--FROM FA_SYSTEM_USER_PRIVILEGE where SUP_DELETED=0 and su_id=Base_emp_id;

 insert into FA_SYSTEM_USER_PRIVILEGE 
 SELECT PRIVILEGE_SEQ_NO.NEXTVAL as SUP_ID,
 (select SU_USER_ID  from FA_SYSTEM_USERS where emp_id=(select substr(pc_where,to_number(instr(pc_where,'/'))+1) from dual))
 as SU_ID, SFG_ID,SUP_DELETED 
FROM FA_SYSTEM_USER_PRIVILEGE where SUP_DELETED=0 and su_id=(select substr(pc_where,1,to_number(instr(pc_where,'/'))-1) from dual);

elsif pc_Option=7 then

 Sql_Statement := 'SELECT nvl(max(SFG_ID),0)+1 MaxFG FROM FA_SYSTEM_FORM_GROUP';
 open refcur_SYSTEM_Components for Sql_Statement;
 
elsif pc_Option=8 then



   if pc_where is not NULL then
     Execute Immediate pc_where;
    End If;
Commit;

 Sql_Statement := 'select 1 ok_sts from dual';
 open refcur_SYSTEM_Components for Sql_Statement;


 
 end if;

 end;