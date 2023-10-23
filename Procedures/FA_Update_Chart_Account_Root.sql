create or replace 
procedure FA_Update_Chart_Account_Root
(
 pc_custID in number
 )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Update_Chart_Account_Root
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
ChkMainRoot number;
begin


commit;

insert into  FA_CUSTOMER_CHART_OF_ACCOUNT t1
(customer_id,ACCOUNT_NUMBER,ACCOUNT_NAME,ACCOUNT_PAIRENT)  (select distinct pc_custID, t2.CFA_NUMBER,t2.CFA_NAME,t2.CFA_PAIRENT from FA_CHART_OF_ACCOUNTS t2
where t2.CFA_NUMBER in (select t1.ACCOUNT_PAIRENT from FA_CUSTOMER_CHART_OF_ACCOUNT t1 where t1.customer_id=pc_custID )
 and t2.CFA_NUMBER not in (select t1.ACCOUNT_NUMBER from FA_CUSTOMER_CHART_OF_ACCOUNT t1 where t1.customer_id=pc_custID ) );
 
 commit;

 select count(ACCOUNT_PAIRENT) into ChkMainRoot from FA_CUSTOMER_CHART_OF_ACCOUNT
 where customer_id=pc_custID and ACCOUNT_PAIRENT=-1;
 
 if ChkMainRoot=0 then
 
 insert into FA_CUSTOMER_CHART_OF_ACCOUNT 
 ( 
    customer_id,
    ACCOUNT_NUMBER,
    ACCOUNT_NAME,
    ACCOUNT_PAIRENT
 ) values (pc_custID,0,'شجرة الحسابات',-1);
 commit;
 end if;
end;