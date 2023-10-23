create or replace 
procedure FA_Get_SYSTEM_PARAMETERS(
  refcur_SYSTEM_PARAMETERS OUT sys_refcursor,
  pc_Major in nvarchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_SYSTEM_PARAMETERS
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data from  the
--                   FA_SYSTEM_PARAMETERS table                                          
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

if pc_Major='0' then

 Sql_Statement := ' SELECT SP_MAJOR,SP_MINOR,SP_A_DESCRIPTION FROM FA_SYSTEM_PARAMETERS where  sp_minor!=0 and sp_deleted=0 order by sp_minor  ';
 open refcur_SYSTEM_PARAMETERS for Sql_Statement;
 
else 
 Sql_Statement := ' SELECT SP_MINOR,SP_A_DESCRIPTION FROM FA_SYSTEM_PARAMETERS where sp_major='''||pc_Major||'''   and sp_minor!=0 and sp_deleted=0 order by sp_minor  ';
 open refcur_SYSTEM_PARAMETERS for Sql_Statement;
 
 end if;
 end;