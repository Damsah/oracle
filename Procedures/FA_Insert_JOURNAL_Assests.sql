create or replace 
procedure FA_Insert_JOURNAL_Assests
     (
       pc_CUSTOMER_ID    	   in NUMBER,
       pc_pay_Type           in number,
       pc_JOR_ACCOUNTNO      in varchar2,
       pc_Amount_with_Tax    in number,
       pc_JOR_TAX_PERSANTAGE in number,
       pc_supplier_AcountNo  in number,
       pc_Assest_Name        in VARCHAR2,
       pc_JOR_INVOICE_ID	   in number,
       pc_JOR_INVOICE_DATE   in VARCHAR2,
       pc_JOR_ATTACHMENT	   in VARCHAR2,
       pc_AllTaxableStatus   in number,
       pc_AssestID           in number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_JOURNAL_Assests
--Date written	   : 01-07-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts JOURNAL Assests                                   
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

NXT_ID number;
MoneyCapitalAmount number;



ChkChashBox number;
ChashBoxAccountNumber number;

ChkBank number;
BankAccountNumber number;

vrAmountWithoutTax number;
vrTaxAmount number;
vrTaxAccountNo number;
begin

vrAmountWithoutTax:=pc_Amount_with_Tax/(pc_JOR_TAX_PERSANTAGE+1);
vrTaxAmount:=pc_Amount_with_Tax-vrAmountWithoutTax;

select  to_number(CC_COM_TAX_NO) into vrTaxAccountNo from FA_CUSTOMER_COMP where CC_ID=pc_CUSTOMER_ID;


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
    ' قيد شراء أصل '||pc_Assest_Name ||' رقم '||pc_AssestID,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
  
  
  if pc_AllTaxableStatus=1 then
   
INSERT
INTO FA_JOURNAL_DETAILS
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
    pc_JOR_ACCOUNTNO,
    vrAmountWithoutTax,
    0,
    pc_JOR_TAX_PERSANTAGE
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
    JOR_CREDIT_AMOUNT,
    JOR_TAX_PERSANTAGE
  )
  VALUES
  (
    NXT_ID,
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    vrTaxAccountNo,
    vrTaxAmount,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
   
   
else

   INSERT
INTO FA_JOURNAL_DETAILS
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
    pc_JOR_ACCOUNTNO,
    pc_Amount_with_Tax,
    0,
    0.0
  );
  
   commit;
end if;


if pc_pay_Type=1 then

 select count(*) into ChkChashBox
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';

if ChkChashBox>0 then


SELECT
  ACCOUNT_NUMBER into ChashBoxAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';

  INSERT
INTO FA_JOURNAL_DETAILS
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
    pc_Amount_with_Tax,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
   
end if;

elsif pc_pay_Type=2 then


 select count(*) into ChkBank
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='البنك';


if ChkBank>0 then

SELECT
  ACCOUNT_NUMBER into BankAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='البنك';



  INSERT
INTO FA_JOURNAL_DETAILS
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
    BankAccountNumber,
    0,
    pc_Amount_with_Tax,
    pc_JOR_TAX_PERSANTAGE
  );
  
  commit;
  
end if;


elsif pc_pay_Type=3 then


  INSERT
INTO FA_JOURNAL_DETAILS
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
    pc_supplier_AcountNo,
    0,
    pc_Amount_with_Tax,
    pc_JOR_TAX_PERSANTAGE
  );
  
  commit;
  


end if;


end;