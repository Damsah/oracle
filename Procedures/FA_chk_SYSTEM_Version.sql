create or replace 
procedure FA_chk_SYSTEM_Version(
  refcur_Version OUT sys_refcursor
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_chk_SYSTEM_Version
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures to ckeck about Version
--                                                            
--Program Inputs   : refer to the parameter list.
--Program outputs  : get data
--Return Code	   : flag
--		        1 : successful
--                      0 : not pass
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
 

 
 
  Sql_Statement := 'select trim(SV_NO) SV_NO  from FA_SYSTEM_VERSION';
 open refcur_Version for Sql_Statement;


 end;