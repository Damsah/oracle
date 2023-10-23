create or replace 
procedure FA_Get_ChartOfAccountLevels(
  refcur_SYSTEM_ChartLevel OUT sys_refcursor,
  pc_Level     in number
) AUTHID CURRENT_USER
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_ChartOfAccountLevels
--Date written	   : 17-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get Chart of account
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
 Plsql_dynamicView Varchar2(8000);
 vViwName Varchar2(200);
 begin
 
 if pc_level=0 then
 
 Sql_Statement := 'select CFA_NUMBER,CFA_NAME, prior CFA_NUMBER as Pairents 
from FA_CHART_OF_ACCOUNTS
start with CFA_PAIRENT = -1
connect by CFA_PAIRENT=prior CFA_NUMBER
order by CFA_ID';

 open refcur_SYSTEM_ChartLevel for Sql_Statement;
 
 else
 
 vViwName:='VCustomerChart_'||pc_level;
 Plsql_dynamicView:='create or replace View '|| vViwName ||'
 as 
SELECT CUSTOMER_ID,
  ACCOUNT_NUMBER,
  ACCOUNT_NAME,
  ACCOUNT_PAIRENT,
  ACCOUNT_CONNECTEDBY
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_level;
 
  
     Execute Immediate Plsql_dynamicView;
     
     
       Sql_Statement := 'select distinct ACCOUNT_NUMBER as CFA_NUMBER,ACCOUNT_NAME as CFA_NAME, prior ACCOUNT_NUMBER as Pairents 
from '||vViwName||'  
start with ACCOUNT_PAIRENT = -1
connect by ACCOUNT_PAIRENT=prior ACCOUNT_NUMBER
order by ACCOUNT_NUMBER';
  
   open refcur_SYSTEM_ChartLevel for Sql_Statement;   
  
/*
 
  Sql_Statement := 'select distinct ACCOUNT_NUMBER as CFA_NUMBER,ACCOUNT_NAME as CFA_NAME, prior ACCOUNT_NUMBER as Pairents 
from '|| vViwName ||'
where CUSTOMER_ID='||pc_level||' 
start with ACCOUNT_PAIRENT = -1
connect by ACCOUNT_PAIRENT=prior ACCOUNT_NUMBER
order by ACCOUNT_NUMBER';

 open refcur_SYSTEM_ChartLevel for Sql_Statement;
 */
 /*else
 
 
   Sql_Statement := 'select distinct ACCOUNT_NUMBER as CFA_NUMBER,ACCOUNT_NAME as CFA_NAME, prior ACCOUNT_NUMBER as Pairents 
from FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_level||' 
start with ACCOUNT_PAIRENT = -1
connect by ACCOUNT_PAIRENT=prior ACCOUNT_NUMBER
order by ACCOUNT_NUMBER';

  Sql_Statement := 'select distinct ACCOUNT_NUMBER as CFA_NUMBER,ACCOUNT_NAME as CFA_NAME, prior ACCOUNT_NUMBER as Pairents 
from FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_level||' 
start with ACCOUNT_PAIRENT = -1
connect by ACCOUNT_PAIRENT=prior ACCOUNT_NUMBER
order by ACCOUNT_NUMBER';

  Sql_Statement := 'select  ACCOUNT_NUMBER as CFA_NUMBER,ACCOUNT_NAME as CFA_NAME,  ACCOUNT_NUMBER as Pairents 
from FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID='||pc_level||'
order by ACCOUNT_NUMBER';

 open refcur_SYSTEM_ChartLevel for Sql_Statement;
 */
end if;

 end;