create or replace 
procedure FA_Update_Chart_Account_Name
(
 pc_custID in number
 )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Update_Chart_Account_Name
--Date written	   : 18-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures Update Chart of Account name                                        
--Program Inputs   : major , desc,user
--Program outputs  : none
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
As

begin

update FA_CUSTOMER_CHART_OF_ACCOUNT t1
set (ACCOUNT_NUMBER,ACCOUNT_PAIRENT)=(select distinct t2.CFA_NUMBER,t2.CFA_PAIRENT from FA_CHART_OF_ACCOUNTS t2 where t1.ACCOUNT_NAME=t2.CFA_NAME)
where exists
(
 select 1
 from FA_CHART_OF_ACCOUNTS t2
 where  t1.ACCOUNT_NAME=t2.CFA_NAME
);


commit;

FA_Update_Chart_Account_Root(pc_custID);
end;