create or replace 
procedure FA_Get_AccountsChild(
  refcur_AccountChild OUT sys_refcursor,
  pc_CustomerId in number,
  pc_PairentNo in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_AccountsChild
--Date written	   : 23-06-2022
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
 
 begin
 
 Sql_Statement := 'select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT='||pc_PairentNo||' and CUSTOMER_ID='||pc_CustomerId;
 open refcur_AccountChild for Sql_Statement;
 

 end;