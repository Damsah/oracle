create or replace 
procedure FA_Insert_Cust_Chart_Account
     (
     pc_custID             in number,
   -- Pc_Insert_Chart       in  clob,
    pc_USER                in varchar2,
    prm_id                 out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Customer_Chart_of_Account
--Date written	   : 18-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Customer Chart of account                                        
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_CUSTOMER_COMP                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As
vr_seq_no number;
Plsql_Insert_Chart Varchar2(32767);
chkMoneyCapitalAccount number;
CapitalAccountNumber number;
ChkChashBox number;
ChashBoxAccountNumber number;
NXT_ID number;
MoneyCapitalAmount number;

prmAddOwnerAccount number;

OwnerAccountNumber number;

   c_id number; 
   c_CO_OWNER_NAME FA_COMP_OWNERS.CO_OWNER_NAME%type; 
   c_CO_OWNER_SHARE_VALUE FA_COMP_OWNERS.CO_OWNER_SHARE_VALUE%type;
   
CURSOR c_AddOwnersAccount is 
      SELECT rownum id,
  CO_OWNER_NAME,
  CO_OWNER_SHARE_VALUE
FROM FA_COMP_OWNERS
where CO_DELETED=0 and CC_ID=pc_custID; 


begin

    
  /*  if Pc_Insert_Chart is not NULL then
     Execute Immediate Pc_Insert_Chart ;
    End If;
    */
    
    INSERT
INTO FA_CUSTOMER_CHART_OF_ACCOUNT
  (
    CUSTOMER_ID,
    ACCOUNT_NUMBER,
    ACCOUNT_NAME,
    ACCOUNT_PAIRENT,
    ACCOUNT_CONNECTEDBY
  )SELECT pc_custID,CFA_NUMBER, CFA_NAME, CFA_PAIRENT,ACCOUNT_CONNECTEDBY FROM FA_CHART_OF_ACCOUNTS  ;
  commit;
   
    
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
    'New Insert',
    pc_custID,
    sysdate,
    pc_USER,
    'FA_Customer_Chart_of_Account'
  );



commit;  



FA_Update_Chart_Account_Name(pc_custID);



 OPEN c_AddOwnersAccount; 
   LOOP 
   FETCH c_AddOwnersAccount into  c_id,c_CO_OWNER_NAME,c_CO_OWNER_SHARE_VALUE; 
      EXIT WHEN c_AddOwnersAccount%notfound; 
      FA_InsUpdt_Cust_Account
     (
       pc_custID,
       c_CO_OWNER_NAME,
       '33'||to_char(c_id),
       '33',
       'A',
       pc_USER,
       prmAddOwnerAccount
     );
   END LOOP; 
   CLOSE c_AddOwnersAccount;


SELECT
 count(*) into ChkChashBox
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME='الصندوق';

if ChkChashBox>0 then
SELECT
 count(*) into chkMoneyCapitalAccount
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME='رأس المال';

if chkMoneyCapitalAccount>0 then


SELECT
  ACCOUNT_NUMBER into ChashBoxAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME='الصندوق';

SELECT
  ACCOUNT_NUMBER into CapitalAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME='رأس المال';

select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;


select CC_COMP_MONEY_CAPITAL into MoneyCapitalAmount from FA_CUSTOMER_COMP where CC_ID=pc_custID;

INSERT
INTO FA_JOURNAL
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DATE,
    JOR_DESC
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    trunc(to_date(sysdate,'dd/mm/rrrr')),
    'قيد رأس المال'
  );
  commit;
  
  
  
INSERT
INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_custID and JOR_ID=NXT_ID),
    ChashBoxAccountNumber,
    MoneyCapitalAmount,
    0
  );

commit;


INSERT
INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_custID and JOR_ID=NXT_ID),
    CapitalAccountNumber,
    0,
    MoneyCapitalAmount
  );
  
  
commit;

end if;
end if;

select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;

INSERT
INTO FA_JOURNAL
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DATE,
    JOR_DESC
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    trunc(to_date(sysdate,'dd/mm/rrrr')),
    'قيد رأس المال - حصص الشركاء'
  );
  commit;
  
OPEN c_AddOwnersAccount; 
   LOOP 
   FETCH c_AddOwnersAccount into  c_id,c_CO_OWNER_NAME,c_CO_OWNER_SHARE_VALUE; 
      EXIT WHEN c_AddOwnersAccount%notfound; 
     
     SELECT
  ACCOUNT_NUMBER into OwnerAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME=c_CO_OWNER_NAME;


INSERT
INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_custID and JOR_ID=NXT_ID),
    OwnerAccountNumber,
    c_CO_OWNER_SHARE_VALUE,
    0
  );

commit;

   END LOOP; 
   CLOSE c_AddOwnersAccount;
   
   
   SELECT
  ACCOUNT_NUMBER into CapitalAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_custID and ACCOUNT_NAME='رأس المال';

select CC_COMP_MONEY_CAPITAL into MoneyCapitalAmount from FA_CUSTOMER_COMP where CC_ID=pc_custID;

   INSERT
INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT
  )
  VALUES
  (
    NXT_ID,
    pc_custID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_custID and JOR_ID=NXT_ID),
    CapitalAccountNumber,
    0,
    MoneyCapitalAmount
  );
  
  
commit;
   
prm_id:=pc_custID;

end;