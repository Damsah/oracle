create or replace 
procedure FA_InGetUp_Sectors(
  refcur_Secotrs OUT sys_refcursor,
  pc_Sector_id in number,
  pc_SECTOR_NAME in varchar2,
  pc_SECTOR_TAX_PERSANTAGE in number,
  pc_USER                in varchar2,
  pc_opertation         in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_InGetUp_Sectors
--Date written	   : 17/09/2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs and inset and update
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
 vr_sector_id number;
 vr_seq_no number;
 vr_sectorname varchar2(2000);
 vr_sector_tax_per number;
 begin
 
 
 
 if pc_opertation=1 then
 
 select nvl(max(SECTOR_ID),0)+1 into vr_sector_id from FA_SECTOR;
 
 INSERT
INTO FA_SECTOR
  (
    SECTOR_ID,
    SECTOR_NAME,
    SECTOR_TAX_PERSANTAGE,
    CO_DELETED
  )
  VALUES
  (
    vr_sector_id,
    pc_SECTOR_NAME,
    pc_SECTOR_TAX_PERSANTAGE,
    0
  );
  
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
    vr_sector_id,
    sysdate,
    pc_USER,
    'FA_SECTOR'
  );
  
commit;  

 Sql_Statement := 'select SECTOR_ID,SECTOR_NAME,SECTOR_TAX_PERSANTAGE from FA_SECTOR
 where CO_DELETED=0 and SECTOR_ID='||vr_sector_id;
 
 open refcur_Secotrs for Sql_Statement;
 
 elsif pc_opertation=2 then
 
  Sql_Statement := 'select SECTOR_ID,SECTOR_NAME,SECTOR_TAX_PERSANTAGE from FA_SECTOR
 where CO_DELETED=0 ';
 
 open refcur_Secotrs for Sql_Statement;
 
 elsif pc_opertation=3 then
 
  Sql_Statement := 'select SECTOR_ID,SECTOR_NAME,SECTOR_TAX_PERSANTAGE from FA_SECTOR
 where CO_DELETED=0 and SECTOR_ID='||vr_sector_id;
 
 open refcur_Secotrs for Sql_Statement;
 
 
  elsif pc_opertation=4 then
 

 
 select SECTOR_NAME,SECTOR_TAX_PERSANTAGE into vr_sectorname,vr_sector_tax_per from 
 FA_SECTOR where SECTOR_ID=pc_Sector_id;
 
 update FA_SECTOR
 set SECTOR_NAME=pc_SECTOR_NAME,SECTOR_TAX_PERSANTAGE=pc_SECTOR_TAX_PERSANTAGE
 where SECTOR_ID=pc_Sector_id;
 
 commit;
 
 select nvl(max(AT_SEQ_NO),0)+1 into vr_seq_no from FA_AUDIT_TRAILS;

 INSERT INTO FA_AUDIT_TRAILS
  (
    AT_SEQ_NO,
    AT_TRXN_TYPE,
    AT_NEW_DATA,
    AT_OLD_DATA,
    ENT_DATE,
    AT_USER,
    TABLE_NAME
  )
  VALUES
  (
    vr_seq_no,
    'New Update',
    pc_SECTOR_NAME||' and '||pc_SECTOR_TAX_PERSANTAGE||' for '||pc_Sector_id,
    vr_sectorname||' and '||vr_sector_tax_per||' for '||pc_Sector_id,
    sysdate,
    pc_USER,
    'FA_SECTOR'
  );
commit;  

 
  Sql_Statement := 'select SECTOR_ID,SECTOR_NAME,SECTOR_TAX_PERSANTAGE from FA_SECTOR
 where CO_DELETED=0 and SECTOR_ID='||pc_Sector_id;
 
 open refcur_Secotrs for Sql_Statement;
 
  elsif pc_opertation=5 then
 
 update FA_SECTOR
 set CO_DELETED=1
 where SECTOR_ID=pc_Sector_id;
 
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
    'Deleted',
    pc_Sector_id,
    sysdate,
    pc_USER,
    'FA_SECTOR'
  );
commit;  


 
  Sql_Statement := 'select SECTOR_ID,SECTOR_NAME,SECTOR_TAX_PERSANTAGE from FA_SECTOR
 where CO_DELETED=1 and SECTOR_ID='||pc_Sector_id;
 
 open refcur_Secotrs for Sql_Statement;
 
 
 end if;
 

 

 end;