create or replace 
procedure FA_insert_Invoices
     (
    pc_CUSTOMER_id         in number,
    pc_INV_NUMBER          in varchar2,
    pc_INV_DATE            in varchar2,
    pc_PRECURMENT_DATE     in varchar2,
    pc_INV_SUPPLIER_ID     in number,
    pc_INV_TYPE            in number,
    pc_INV_AMOUNT          in number,
    pc_INV_DESC            in varchar2,
    pc_INV_ATTACHMENT      in varchar2,
    pc_AssestAccountNumber in varchar2,
    pc_TAX_PERSANTAGE      in number,
    pc_INV_GUIDANCE_TYPE   in number,
    
    pc_COUNT               in number,
    pc_ASSEST_WORKING_DATE in varchar2,
    pc_ELHALKPERCANTAGE    in number,
    pc_EHLAKACCOUNT        in varchar2,
    pc_COMPLEXEHLAKACCOUNT in varchar2,
    pc_InvTaxableStatus    in number,
    pc_AssestStatus        in number,
    
    pc_CustomerTaxableStatus in number,
    pc_CustomerEhlakStatus in number,
    pc_CustomerActivitesStatus in number,
    pc_MoneyPart          in number,
    
    pc_PRocDontStatus     in number,
    pc_InsertExp          in Varchar2,
    pc_USER                in varchar2,
    Pc_Inv_Details         in  Varchar2,
    prm_id                 out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_insert_Invoices
--Date written	   : 29-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new invoice                                        
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
Plsql_Details Varchar2(8000);
Plsql_Exp Varchar2(8000);
Plsql_Owners Varchar2(8000);
invSer number;
AllTaxableStatus number;

PartPaidId number;
vACCOUNT_NUMBER number;
ChashBoxAccountNumber number;
NXT_ID number;
SUMeXpAmount number;

vAssestID number;

prm_idDepr number;

vAssestNetAmount number;
begin

if pc_CustomerTaxableStatus=2 then
AllTaxableStatus:=2;

else

if pc_InvTaxableStatus=2 then
AllTaxableStatus:=2;
else
AllTaxableStatus:=1;
end if;

end if;



select FA_INVOICE_seq_no.NEXTVAL into invSer from dual;

INSERT
INTO FA_INVOICE
  (
    INV_ID,
    INV_NUMBER,
    INV_CUSTOMER_ID,
    INV_DATE,
    INV_PRECURMENT_DATE,
    INV_SUPPLIER_ID,
    INV_TYPE,
    INV_AMOUNT,
    INV_DESC,
    INV_ATTACHMENT,
    INV_TAXABLE_STATUS
  )
  VALUES
  (
    invSer,
    pc_INV_NUMBER,
    pc_CUSTOMER_id,
    trunc(to_date(pc_INV_DATE,'dd/mm/rrrr')),
    trunc(to_date(pc_PRECURMENT_DATE,'dd/mm/rrrr')),
    pc_INV_SUPPLIER_ID,
    pc_INV_TYPE,
    pc_INV_AMOUNT,
    pc_INV_DESC,
    pc_INV_ATTACHMENT,
    AllTaxableStatus
  );
 
Commit; 

    Plsql_Details:=replace(Pc_Inv_Details,'@@@@@',invSer); 
    if Plsql_Details is not NULL then
     Execute Immediate Plsql_Details;
    End If;
Commit;


if pc_InsertExp is not NULL  then
  Plsql_Exp:=replace(pc_InsertExp,'@@@@@',invSer); 
    if Plsql_Exp is not NULL then
     Execute Immediate Plsql_Exp;
    End If;
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
    'New Insert',
    invSer,
    sysdate,
    pc_USER,
    'FA_INVOICE'
  );



commit;  

prm_id:=invSer;


if pc_INV_GUIDANCE_TYPE=1 then


select FA_CUSTOMER_ASSESTS_seq_no.NEXTVAL into vAssestID from dual;
INSERT
INTO FA_CUSTOMER_ASSESTS
  (
    CA_ID,
    CA_CUSTOMER_ID,
    CA_ASSEST_ACCOUNT_NUMBER,
    CA_ASSEST_NAME,
    CA_ASSEST_COST_WITH_TAX,
    CA_TAX_PERSANTAGE,
    CA_COUNT,
    CA_ASSEST_WORKING_DATE,
    CA_INVOICE_NUMBER,
    CA_INVOICE_DATE,
    CA_ROCURMENT_TYPE,
    CA_SUPPLIER_NUMBER,
    CA_ELHALKPERCANTAGE,
    CA_EHLAKACCOUNT,
    CA_COMPLEXEHLAKACCOUNT,
    CA_ATTACHMENT,
    CA_TAXABLE,
    CA_ACTIVE
  )
  VALUES
  (
    vAssestID,
    pc_CUSTOMER_id,
    pc_AssestAccountNumber,
    trim( Replace(pc_INV_DESC,' شراء أصل ','')),
    pc_INV_AMOUNT,
    pc_TAX_PERSANTAGE,
    pc_COUNT,
    trunc(to_date(pc_ASSEST_WORKING_DATE,'dd/mm/rrrr')),
    pc_INV_NUMBER,
    pc_INV_DATE,
    pc_INV_TYPE,
    pc_INV_SUPPLIER_ID,
    pc_ELHALKPERCANTAGE,
    pc_EHLAKACCOUNT,
    pc_COMPLEXEHLAKACCOUNT,
    pc_INV_ATTACHMENT,
    AllTaxableStatus,
    pc_AssestStatus
  );
  
  commit;
  
  update FA_ASSESTS_EXPENSES
  set ASSEST_ID=vAssestID
  where CUSTOMER_ID=pc_CUSTOMER_id and INV_ID=invSer;
  
  commit;
  
FA_Insert_JOURNAL_Assests
     (
       pc_CUSTOMER_id,
       pc_INV_TYPE,
       pc_AssestAccountNumber,
       pc_INV_AMOUNT,
       pc_TAX_PERSANTAGE,
       pc_INV_SUPPLIER_ID,
      trim( Replace(pc_INV_DESC,' شراء أصل ','')),
       invSer,
       pc_INV_DATE,
       pc_INV_ATTACHMENT,
       AllTaxableStatus,
       vAssestID
     );

commit;
if pc_AssestAccountNumber!=121 then

if pc_CustomerEhlakStatus=1 and pc_AssestStatus=1 then

if AllTaxableStatus=1 then 

vAssestNetAmount:=pc_INV_AMOUNT/(pc_TAX_PERSANTAGE+1);

else

vAssestNetAmount:=pc_INV_AMOUNT;
end if;

 FA_Insert_Depreciation
     (
       pc_CUSTOMER_id,
       pc_AssestAccountNumber,
       trim( Replace(pc_INV_DESC,' شراء أصل ','')),
       vAssestID,
       trunc(to_date(pc_ASSEST_WORKING_DATE,'dd/mm/rrrr')),
       pc_EHLAKACCOUNT,
       pc_COMPLEXEHLAKACCOUNT,
       pc_ELHALKPERCANTAGE,
       vAssestNetAmount,
       pc_USER,
       prm_idDepr
     );
     
     commit;
     
     end if;
     
     end if;
     
     
select nvl(sum(EXP_AMOUNT),0) into SUMeXpAmount from FA_ASSESTS_EXPENSES
  where CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=invSer;

  if SUMeXpAmount>0 then
  
select ACCOUNT_NUMBER into vACCOUNT_NUMBER
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID=pc_CUSTOMER_id and ACCOUNT_NAME='مصاريف المشتريات') 
 and CUSTOMER_ID=pc_CUSTOMER_id;
 
 
 SELECT
  ACCOUNT_NUMBER into ChashBoxAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';

select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;


INSERT
INTO FA_JOURNAL
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DATE,
    JOR_DESC,
    JOR_INVOICE_ID,
    JOR_INVOICE_DATE,
    JOR_ATTACHMENT,
    JOR_PAID_TYPE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    trunc(to_date(sysdate,'dd/mm/rrrr')),
    'قيد مصاريف على مشتريات الأصول',
     invSer,
     trunc(to_date(pc_INV_DATE,'dd/mm/rrrr')),
     pc_INV_ATTACHMENT,
     1
  );
  commit;
  
 
    
INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    vACCOUNT_NUMBER,
    SUMeXpAmount,
    0,
    0
  );
  
   commit;

INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    ChashBoxAccountNumber,
    0,
    SUMeXpAmount,
    0
  );
  
   commit;
   
   
   end if;

----end assest--
elsif pc_INV_GUIDANCE_TYPE=4 then

INSERT
INTO FA_SALES
  (
    CUSTOMER_ID,
    INV_ID,
    INV_SUPPLIER_ID,
    INV_AMOUNT,
    INV_DESC,
    S_STATUS
  )
  VALUES
  (
    pc_CUSTOMER_id,
    invSer,
    pc_INV_SUPPLIER_ID,
    pc_INV_AMOUNT,
    pc_INV_DESC,
    pc_PRocDontStatus
  );

Commit;

if pc_MoneyPart>0 then

SELECT 
   nvl(max(PAID_ID),0)+1 into PartPaidId
FROM FA_SALES_PART_MONEY 
where CUSTOMER_ID=pc_CUSTOMER_id and INV_ID=invSer and SUPPLIER_ID=pc_INV_SUPPLIER_ID and S_STATUS=0;

INSERT
INTO FA_SALES_PART_MONEY
  (
    CUSTOMER_ID,
    INV_ID,
    PAID_ID,
    SUPPLIER_ID,
    AMOUNT,
    TOTAL_AMOUNT,
    INV_DESC,
    S_STATUS
  )
  VALUES
  (
    pc_CUSTOMER_id,
    invSer,
    PartPaidId,
    pc_INV_SUPPLIER_ID,
    pc_MoneyPart,
    pc_INV_AMOUNT,
    pc_INV_DESC,
    0
  );

commit;

end if;

FA_Insert_JOURNAL_General
     (
       pc_CUSTOMER_id,
       4,
       pc_INV_TYPE,
       pc_AssestAccountNumber,
       pc_INV_AMOUNT,
       pc_TAX_PERSANTAGE,
       pc_INV_SUPPLIER_ID,
       pc_INV_DESC,
       invSer,
       pc_INV_DATE,
       pc_INV_ATTACHMENT,
       AllTaxableStatus,
       pc_MoneyPart,
       invSer,
       pc_PRocDontStatus
     );

commit;

 select  nvl(sum(EXP_AMOUNT),0) into SUMeXpAmount from FA_Sales_EXPENSES
  where CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=invSer;
  
 if SUMeXpAmount>0 then
 
select ACCOUNT_NUMBER into vACCOUNT_NUMBER
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID=pc_CUSTOMER_id and ACCOUNT_NAME='مصاريف البيع والتسويق') 
 and CUSTOMER_ID=pc_CUSTOMER_id;
 
 
 SELECT
  ACCOUNT_NUMBER into ChashBoxAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';

select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;


INSERT
INTO FA_JOURNAL
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DATE,
    JOR_DESC,
    JOR_INVOICE_ID,
    JOR_INVOICE_DATE,
    JOR_ATTACHMENT,
    JOR_PAID_TYPE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    trunc(to_date(sysdate,'dd/mm/rrrr')),
    'قيد مصاريف على المبيعات',
     invSer,
     trunc(to_date(pc_INV_DATE,'dd/mm/rrrr')),
     pc_INV_ATTACHMENT,
     1
  );
  commit;
  
 
    
INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    vACCOUNT_NUMBER,
    SUMeXpAmount,
    0,
    0
  );
  
   commit;

INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    ChashBoxAccountNumber,
    0,
    SUMeXpAmount,
    0
  );
  
   commit;
   
end if;

elsif pc_INV_GUIDANCE_TYPE=3 then

INSERT
INTO FA_PROCUREMENTS
  (
    CUSTOMER_ID,
    INV_ID,
    INV_SUPPLIER_ID,
    INV_AMOUNT,
    INV_DESC,
    S_STATUS
  )
  VALUES
  (
    pc_CUSTOMER_id,
    invSer,
    pc_INV_SUPPLIER_ID,
    pc_INV_AMOUNT,
    pc_INV_DESC,
    pc_PRocDontStatus
  );
  
  commit;
  
  if pc_MoneyPart>0 then

SELECT 
   nvl(max(PAID_ID),0)+1 into PartPaidId
FROM FA_Procurements_Part_Money 
where CUSTOMER_ID=pc_CUSTOMER_id and INV_ID=invSer and SUPPLIER_ID=pc_INV_SUPPLIER_ID and S_STATUS=0;

INSERT
INTO FA_Procurements_Part_Money
  (
    CUSTOMER_ID,
    INV_ID,
    PAID_ID,
    SUPPLIER_ID,
    AMOUNT,
    TOTAL_AMOUNT,
    INV_DESC,
    S_STATUS
  )
  VALUES
  (
    pc_CUSTOMER_id,
    invSer,
    PartPaidId,
    pc_INV_SUPPLIER_ID,
    pc_MoneyPart,
    pc_INV_AMOUNT,
    pc_INV_DESC,
    0
  );

commit;

end if;

  FA_Insert_JOURNAL_Procurements
     (
       pc_CUSTOMER_id,
       3,
       pc_INV_TYPE,
       pc_AssestAccountNumber,
       pc_INV_AMOUNT,
       pc_TAX_PERSANTAGE,
       pc_INV_SUPPLIER_ID,
       pc_INV_DESC,
       invSer,
       pc_INV_DATE,
       pc_INV_ATTACHMENT,
       AllTaxableStatus,
       pc_MoneyPart,
       invSer,
       pc_PRocDontStatus
     );

commit;


 select nvl(sum(EXP_AMOUNT),0) into SUMeXpAmount from FA_PROCUREMENT_EXPENSES
  where CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=invSer;

  if SUMeXpAmount>0 then
  
select ACCOUNT_NUMBER into vACCOUNT_NUMBER
from FA_CUSTOMER_CHART_OF_ACCOUNT
where ACCOUNT_NUMBER in(
SELECT 
  ACCOUNT_NUMBER
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID=pc_CUSTOMER_id and ACCOUNT_NAME='مصاريف المشتريات') 
 and CUSTOMER_ID=pc_CUSTOMER_id;
 
 
 SELECT
  ACCOUNT_NUMBER into ChashBoxAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';

select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;


INSERT
INTO FA_JOURNAL
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DATE,
    JOR_DESC,
    JOR_INVOICE_ID,
    JOR_INVOICE_DATE,
    JOR_ATTACHMENT,
    JOR_PAID_TYPE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    trunc(to_date(sysdate,'dd/mm/rrrr')),
    'قيد مصاريف على المشتريات',
     invSer,
     trunc(to_date(pc_INV_DATE,'dd/mm/rrrr')),
     pc_INV_ATTACHMENT,
     1
  );
  commit;
  
 
    
INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    vACCOUNT_NUMBER,
    SUMeXpAmount,
    0,
    0
  );
  
   commit;

INSERT INTO FA_JOURNAL_DETAILS
  (
    JOR_ID,
    JOR_CUSTOMER_ID,
    JOR_DETAIL_ID,
    JOR_ACCOUNTNO,
    JOR_DEPIT_AMOUNT,
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    ChashBoxAccountNumber,
    0,
    SUMeXpAmount,
    0
  );
  
   commit;
   
   
   end if;
  
  
  
  
  elsif pc_INV_GUIDANCE_TYPE=2 then

if pc_MoneyPart=0 then

INSERT
INTO FA_Expenses
  (
    CUSTOMER_ID,
    INV_ID,
    INV_SUPPLIER_ID,
    INV_AMOUNT,
    INV_DESC
  )
  VALUES
  (
    pc_CUSTOMER_id,
    invSer,
    pc_INV_SUPPLIER_ID,
    pc_INV_AMOUNT,
    pc_INV_DESC
  );
  
  commit;
  
  
  
  end if;
  
   FA_Insert_JOURNAL_Expenses
     (
       pc_CUSTOMER_id,
       2,
       pc_INV_TYPE,
       pc_AssestAccountNumber,
       pc_INV_AMOUNT,
       pc_TAX_PERSANTAGE,
       pc_INV_SUPPLIER_ID,
       pc_INV_DESC,
       invSer,
       pc_INV_DATE,
       pc_INV_ATTACHMENT,
       AllTaxableStatus,
       invSer,
       pc_MoneyPart,
       pc_ELHALKPERCANTAGE,
       pc_PRECURMENT_DATE
     );

commit;


end if;


end;