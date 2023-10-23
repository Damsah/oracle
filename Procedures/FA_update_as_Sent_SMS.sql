create or replace 
procedure FA_update_as_Sent_SMS
(
 pc_SMS_id in number
 )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_update_as_Sent_SMS
--Date written	   : 27-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures
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

update FA_Send_SMS
set SMS_status=1 , SMS_sent_Date= trunc(to_date(sysdate,'dd/mm/rrrr'))
where SMS_id=pc_SMS_id;

commit;

end;