create or replace 
procedure FA_Get_EXEMPTION_YEAR(
  refcur_SYSTEM_EXEMPTION_YEAR OUT sys_refcursor,
  pc_Year in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_EXEMPTION_YEAR
--Date written	   : 20-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get EXEMPTION_YEAR
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
 
 Sql_Statement := 'SELECT 
EXEMPTION_AMOUNT,DISABLEDAMOUNT 
FROM FA_SALARY_EXEMPTION_YEAR
where EXEMPTION_FROM_YEAR<='||pc_Year||' and ( exemption_to_year>='||pc_Year||' or exemption_to_year is null)';

 open refcur_SYSTEM_EXEMPTION_YEAR for Sql_Statement;
 

 end;