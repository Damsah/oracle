create or replace 
procedure FA_Get_SYSTEM_FTP(
  refcur_SYSTEM_FTP OUT sys_refcursor
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_SYSTEM_FTP
--Date written	   : 10-0-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get FTP
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
 
 Sql_Statement := 'SELECT FTP_LINK, FTP_USER, FTP_PASSWORD FROM FA_SYSTEM_FTP';

 open refcur_SYSTEM_FTP for Sql_Statement;
 

 end;