create or replace 
procedure FA_InsUpDel_SYSTEM_PARAMETERS
     (
     pc_ActionType      in number,
     pc_MAJOR           in varchar2,
     pc_Minor           in number,
     pc_A_DESCRIPTION   in varchar2,
     pc_USER            in varchar2,
     prm_id            out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_InsUpDel_SYSTEM_PARAMETERS
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new , update,Delete Service info into the
--                   Parameters Table                                            
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_SYSTEM_PARAMETERS                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As
vr_MINOR    varchar2(20);
vr_OldServiceName Varchar2(500);
vr_seq_no number;
 out_f number;

begin

if pc_ActionType=0 then 

 select max(SP_MINOR)+1 into vr_MINOR   from FA_SYSTEM_PARAMETERS where SP_MAJOR=pc_MAJOR;

  INSERT INTO FA_SYSTEM_PARAMETERS(SP_MAJOR,SP_MINOR,SP_E_DESCRIPTION,SP_A_DESCRIPTION,SP_USER)VALUES(pc_MAJOR,vr_MINOR,pc_A_DESCRIPTION,pc_A_DESCRIPTION,pc_USER);
   

commit; 

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
    'New Insert',
    vr_MINOR,
    sysdate,
    pc_USER,
    'FA_SYSTEM_PARAMETERS'
  );



commit;  

prm_id:=vr_MINOR;


 elsif pc_ActionType=1 then
 
 select SP_A_DESCRIPTION into vr_OldServiceName from FA_SYSTEM_PARAMETERS where SP_MAJOR=pc_MAJOR and SP_MINOR=pc_Minor;
 
 update FA_SYSTEM_PARAMETERS
 set SP_E_DESCRIPTION=pc_A_DESCRIPTION,
     SP_A_DESCRIPTION=pc_A_DESCRIPTION,
     SP_MOD_DATE=sysdate,
     SP_USER=pc_USER
     where SP_MAJOR=pc_MAJOR and SP_MINOR=pc_Minor;
   
commit; 

select nvl(max(AT_SEQ_NO),0)+1 into vr_seq_no from FA_AUDIT_TRAILS;

 INSERT INTO FA_AUDIT_TRAILS
  (
    AT_SEQ_NO,
    AT_TRXN_TYPE,
    AT_OLD_DATA,
    AT_NEW_DATA,
    MOD_DATE,
    AT_USER,
    TABLE_NAME
  )
  VALUES
  (
    vr_seq_no,
    'New Update',
    vr_OldServiceName,
    pc_A_DESCRIPTION,
    sysdate,
    pc_USER,
    'FA_SYSTEM_PARAMETERS'
  );



commit;  

prm_id:=pc_Minor;


 elsif pc_ActionType=2 then
 
 select SP_A_DESCRIPTION into vr_OldServiceName from FA_SYSTEM_PARAMETERS where SP_MAJOR=pc_MAJOR and SP_MINOR=pc_Minor;
 
 update FA_SYSTEM_PARAMETERS
 set SP_DELETED=1,
     SP_MOD_DATE=sysdate,
     SP_USER=pc_USER
     where SP_MAJOR=pc_MAJOR and SP_MINOR=pc_Minor;
   
commit; 

select nvl(max(AT_SEQ_NO),0)+1 into vr_seq_no from FA_AUDIT_TRAILS;

 INSERT INTO FA_AUDIT_TRAILS
  (
    AT_SEQ_NO,
    AT_TRXN_TYPE,
    AT_OLD_DATA,
    MOD_DATE,
    AT_USER,
    TABLE_NAME
  )
  VALUES
  (
    vr_seq_no,
    'Delete',
    vr_OldServiceName,
    sysdate,
    pc_USER,
    'FA_SYSTEM_PARAMETERS'
  );



commit;  

prm_id:=pc_Minor;


 end if;
end;