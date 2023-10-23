create or replace 
procedure FA_Insert_Immediate
     (
       pc_Insert        in Clob,
       pc_USER          in varchar2,
       pc_id            in number,
       pc_table_Name    in varchar2,
       prm_id           out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Immediate
--Date written	   : 29-11-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts Immediate General                               
--Program Inputs   : 
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
   
  vr_seq_no number; 
  prm_idOut number;
begin


    if pc_Insert is not NULL then
     Execute Immediate pc_Insert;
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
    'New id'||pc_id,
    0,
    sysdate,
    pc_USER,
    pc_table_Name
  );
  commit;

select nvl(max(JOR_ID),0)+1 into prm_idOut from FA_JOURNAL;
prm_id:=prm_idOut;


end;