create or replace 
procedure FA_Get_Accounts(
  refcur_Account OUT sys_refcursor,
  pc_CustomerId in number,
  pc_type in number
) AUTHID CURRENT_USER
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Accounts
--Date written	   : 20-06-2022
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
 vViwName varchar2(500);
 Plsql_dynamicView Varchar2(8000);
 vChkViewExist Number;
 begin
 
 if pc_type=1 then
 Sql_Statement := 'select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''الأصول الثابتة'')
 and ACCOUNT_NAME !=''الأراضي'' 
 and CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME !=''إستهلاك الأصول الثابته''';
 open refcur_Account for Sql_Statement;
 
 elsif pc_type=2 then
 
  Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''الموردون'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 open refcur_Account for Sql_Statement;
 elsif pc_type=3 then
 
   Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''إستهلاك الأصول الثابته'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
 elsif pc_type=4 then
 
  Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''مصاريف الإهلاك و الإستنفاذ'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
  open refcur_Account for Sql_Statement;
  
  
  elsif pc_type=5 then
 Sql_Statement := 'select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''الأصول الثابتة'') 
 and CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME !=''إستهلاك الأصول الثابته''';
 open refcur_Account for Sql_Statement;
  
   elsif pc_type=6  then
   
 Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''المصروفات'') 
 and CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME!=''مصاريف الإهلاك و الإستنفاذ'' and ACCOUNT_NAME!=''تكلفة المبيعات'' ';
  open refcur_Account for Sql_Statement;
  
  
   elsif pc_type=7  then
   
 Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''المشتريات'') 
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
   open refcur_Account for Sql_Statement;
   
   
   elsif pc_type=8  then
   
 Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME in (''المبيعات'',''الإيرادات الأخرى'') )
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
   open refcur_Account for Sql_Statement;
   
    elsif pc_type=9 then
 
  Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''العملاء'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 open refcur_Account for Sql_Statement;
   
   elsif pc_type=10 then
 Sql_Statement :='SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''العملاء'' ';
 open refcur_Account for Sql_Statement;
 
   
   elsif pc_type=11 then
  
  
Sql_Statement :='select nvl(max(ACCOUNT_NUMBER),0) MaxNode
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''العملاء'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
   elsif pc_type=12 then
  
  
Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''مصاريف المشتريات'') 
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
 
  elsif pc_type=13 then
  
  
Sql_Statement :='select ACCOUNT_NUMBER,
ACCOUNT_NAME
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''مصاريف البيع والتسويق'') 
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
   elsif pc_type=14 then
 
  vViwName:='VCustomerChart_'||pc_CustomerId;
 
 select count(*) into vChkViewExist from all_views
where upper(view_name)=upper(vViwName)
and upper(owner)=upper('FINANCIAL_AUDIT');

 if vChkViewExist>0 then
 
 Plsql_dynamicView:='drop View '||vViwName ;
 Execute Immediate Plsql_dynamicView;
     
 end if;
     
     
            Sql_Statement := 'select sysdate from dual';
  
   open refcur_Account for Sql_Statement; 
   
 
  elsif pc_type=55 then
  
  
Sql_Statement :='select nvl(max(ACCOUNT_NUMBER),0) MaxNode
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''الموردون'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
 elsif pc_type=551 then
 Sql_Statement :='SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''الموردون'' ';
 open refcur_Account for Sql_Statement;

  elsif pc_type=552 then
 Sql_Statement :='SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''مصاريف الإهلاك و الإستنفاذ'' ';
 open refcur_Account for Sql_Statement;
 
  elsif pc_type=553 then
  
  
Sql_Statement :='select nvl(max(ACCOUNT_NUMBER),0) MaxNode
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''مصاريف الإهلاك و الإستنفاذ'')
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
  elsif pc_type=554 then
 Sql_Statement :='SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''إستهلاك الأصول الثابته'' ';
 open refcur_Account for Sql_Statement;
 
 
   elsif pc_type=555 then
  
  
Sql_Statement :='select nvl(max(ACCOUNT_NUMBER),0) MaxNode
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_PAIRENT in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID='||pc_CustomerId||' and ACCOUNT_NAME=''إستهلاك الأصول الثابته'' )
 and CUSTOMER_ID='||pc_CustomerId||' ';
 
 open refcur_Account for Sql_Statement;
 
 end if;

 end;