create or replace 
procedure FA_Get_Bank_Branchs(
  refcur_SYSTEM_Bank_Branchs OUT sys_refcursor,
  pc_BankID in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Bank_Branchs
--Date written	   : 18-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get Bank Branchs
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
 
 Sql_Statement := 'SELECT BANK_BRANCH_ID,
BANK_BRANCH_NAME
FROM FA_BANK_BRANCH 
where CO_DELETED=0 and BANK_ID='||pc_BankID;

 open refcur_SYSTEM_Bank_Branchs for Sql_Statement;
 

 end;