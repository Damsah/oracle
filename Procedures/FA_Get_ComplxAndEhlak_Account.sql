create or replace 
procedure FA_Get_ComplxAndEhlak_Account(
  refcur_SYSTEM_ComplxAndEhlak OUT sys_refcursor,
  pc_CustomerId     in number,
  pc_AccountNo    in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_ComplxAndEhlak_Account
--Date written	   : 29-06-2022
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
 
 Sql_Statement := 'select ehlak_Comp_account,ACCOUNT_NUMBER,ACCOUNT_NAME
from (
SELECT 
 ''1'' as ehlak_Comp_account,
  ACCOUNT_NUMBER,
  ACCOUNT_NAME
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_CONNECTEDBY='||pc_AccountNo||'  
 union all
 
SELECT 
 ''2'' as ehlak_Comp_account,
  ACCOUNT_NUMBER,
  ACCOUNT_NAME
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_CONNECTEDBY in (select  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_CONNECTEDBY='||pc_AccountNo||')  
)';

 open refcur_SYSTEM_ComplxAndEhlak for Sql_Statement;
 

 end;