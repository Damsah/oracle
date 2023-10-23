create or replace 
procedure FA_Get_SMS_to_send(
  refcur_SMS OUT sys_refcursor
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_SMS_to_send
--Date written	   : 27-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs for user
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
 
 Sql_Statement := 'select SMS_id,SMS_Text,SMS_mobileNo,SMS_SENDER,
SMS_PASSWORD,SMS_ACCOUNT_NAME,URL_ID from FA_Send_SMS
where SMS_status=0';
 open refcur_SMS for Sql_Statement;
 

 end;