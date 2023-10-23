create or replace 
procedure FA_Insert_SMS_TxT
     (
       pc_Insert_SMS    in Clob,
       pc_USER          in varchar2,
       prm_id           out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_SMS_TxT
--Date written	   : 12-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts SMS to send                                  
--Program Inputs   : 
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_SEND_SMS                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As
   
  vr_seq_no number; 
begin


    if pc_Insert_SMS is not NULL then
     Execute Immediate pc_Insert_SMS;
    End If;
Commit;


select nvl(max(AT_SEQ_NO),0)+1 into vr_seq_no from FA_AUDIT_TRAILS;

 INSERT INTO FA_AUDIT_TRAILS
  (
    AT_SEQ_NO,
    AT_TRXN_TYPE,
    AT_NEW_DATA,
    ENT_DATE,
    AT_USER,
    TABLE_NAME
  )
  VALUES
  (
    vr_seq_no,
    'New SMS For ALL',
    0,
    sysdate,
    pc_USER,
    'SMS Bluk'
  );
  commit;

prm_id:=1;


end;