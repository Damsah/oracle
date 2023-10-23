create or replace 
procedure FA_Get_SYSTEM_USER(
  refcur_SYSTEM_USER OUT sys_refcursor,
  pc_user     in nvarchar2,
  pc_password in varchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_SYSTEM_USER
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs for user
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
 
 begin
 
 Sql_Statement := 'SELECT su.SU_A_NAME,to_char(su.SU_LAST_LOGON_DATE,''dd/mm/yyyy HH:MI:SS AM'') lAST_LOGIN 
FROM FA_SYSTEM_USERS su 
where upper(su.SU_USER)= upper('''||pc_user||''')   and upper(su.SU_USER_PASSWORD) = upper('''||pc_password||''')  and su.SU_STATUS=''a''';
 open refcur_SYSTEM_USER for Sql_Statement;
 

 end;