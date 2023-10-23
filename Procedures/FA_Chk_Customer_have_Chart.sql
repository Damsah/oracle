create or replace 
procedure FA_Chk_Customer_have_Chart(
  pc_Customer_Id in number,
  pc_Check_Customer     out number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Chk_Customer_have_Chart
--Date written	   : 18-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures check if customer have a chart of account
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

vCheck_Customer number;
 
 begin
 
select count(CUSTOMER_ID) into vCheck_Customer from FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_customer_id;
 
pc_Check_Customer:=vCheck_Customer;

 end;