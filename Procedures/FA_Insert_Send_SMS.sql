create or replace 
procedure FA_Insert_Send_SMS
     (
       pc_SMS_Text                  in varchar2,
       pc_SMS_mobileNo              in varchar2,
       pc_SMS_Source                in varchar2,
       pc_sms_sender                in varchar2,
       pc_sms_password              in varchar2,
       pc_sms_account_name         in varchar2,
       pc_URL_ID                   in number,
       prm_id                 out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Send_SMS
--Date written	   : 27-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures                                    
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_COMPAGREMENT                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As

begin

insert into FA_Send_SMS
(
 SMS_id,
 SMS_Text,
 SMS_mobileNo,
 SMS_status,
 SMS_SOURCE,
 SMS_SENDER,
SMS_PASSWORD,
SMS_Account_Name,
URL_ID
)
values 
( 
FA_Send_SMS_seq_no.NEXTVAL,
 pc_SMS_Text,
 pc_SMS_mobileNo,
 0,
 pc_SMS_Source,
  pc_sms_sender,
  pc_sms_password,
  pc_sms_account_name,
  pc_URL_ID
  
 );
commit;  

prm_id:=1;


end;