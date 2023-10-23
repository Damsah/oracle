create or replace 
procedure FA_InsUpdt_Cust_Account
     (
       pc_CUSTOMER_ID               in number,
       pc_AccountName               in varchar2,
       pc_AccountNumber             in varchar2,
       pc_AccountPairent            in varchar2,
       pc_Operation                 in varchar2,
       pc_USER                      in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_InsUpdt_Cust_Account
--Date written	   : 20-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Customer Account                                       
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
vr_AgrementID    varchar2(20);
vr_FXG_ID number;

Plsql_Services Varchar2(8000);

vr_seq_no number;
begin

if upper(pc_Operation)='A' then
INSERT
INTO FA_CUSTOMER_CHART_OF_ACCOUNT
  (
    CUSTOMER_ID,
    ACCOUNT_NUMBER,
    ACCOUNT_NAME,
    ACCOUNT_PAIRENT
  )
  VALUES
  (
    pc_CUSTOMER_ID,
    pc_AccountNumber,
    pc_AccountName,
    pc_AccountPairent
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
    'New Insert Account of Customer '||pc_CUSTOMER_ID,
    pc_AccountNumber,
    sysdate,
    pc_USER,
    'FA_CUSTOMER_CHART_OF_ACCOUNT'
  );



commit;  


elsif upper(pc_Operation)='E' then

UPDATE FA_CUSTOMER_CHART_OF_ACCOUNT
SET ACCOUNT_NAME =pc_AccountName
WHERE CUSTOMER_ID   = pc_CUSTOMER_ID
AND ACCOUNT_NAME    = pc_AccountNumber;

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
    'Update Account of Customer '||pc_CUSTOMER_ID,
    pc_AccountName,
    pc_AccountNumber,
    sysdate,
    pc_USER,
    'FA_CUSTOMER_CHART_OF_ACCOUNT'
  );



commit; 


elsif upper(pc_Operation)='C' then



UPDATE FA_CUSTOMER_CHART_OF_ACCOUNT
SET ACCOUNT_CONNECTEDBY =pc_AccountName
WHERE CUSTOMER_ID   = pc_CUSTOMER_ID
AND ACCOUNT_NUMBER    = pc_AccountNumber;

commit;

UPDATE FA_CUSTOMER_CHART_OF_ACCOUNT
SET ACCOUNT_CONNECTEDBY =pc_AccountNumber
WHERE CUSTOMER_ID   = pc_CUSTOMER_ID
AND ACCOUNT_NUMBER    = pc_AccountPairent;

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
    'Connect Account of Customer '||pc_CUSTOMER_ID,
    ' Main Account '||pc_AccountName ||' Connected '||pc_AccountNumber||' and connected '||pc_accountpairent,
    sysdate,
    pc_USER,
    'FA_CUSTOMER_CHART_OF_ACCOUNT'
  );



commit; 

elsif upper(pc_Operation)='PASS' then



UPDATE FA_SYSTEM_USERS
SET SU_USER_PASSWORD =pc_AccountNumber,
SU_PASSWORD_CHANGE_DATE= trunc(to_date(sysdate,'dd/mm/rrrr'))
WHERE upper(SU_USER)=upper( pc_AccountName);

commit;

elsif upper(pc_Operation)='LASTLOGIN' then



UPDATE FA_SYSTEM_USERS
SET SU_LAST_LOGON_DATE= sysdate
WHERE upper(SU_USER)=upper( pc_AccountName);

commit;


end if;

prm_id:=1;

end;