create or replace 
procedure FA_Insert_JOURNAL_Expenses
     (
       pc_CUSTOMER_ID    	   in NUMBER,
       pc_GUIDANCE_TYPE      in number,
       pc_pay_Type           in number,
       pc_JOR_ACCOUNTNO      in varchar2,
       pc_Amount_with_Tax    in number,
       pc_JOR_TAX_PERSANTAGE in number,
       pc_supplier_AcountNo  in number,
       pc_Procurements_Desc  in VARCHAR2,
       pc_JOR_INVOICE_ID	   in number,
       pc_JOR_INVOICE_DATE   in VARCHAR2,
       pc_JOR_ATTACHMENT	   in VARCHAR2,
       pc_AllTaxableStatus   in number,
       pc_invSer             in number,
       pc_Assest_id          in number,
       pc_pay_monthly        in number,
       pc_to_date            in varchar2
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_JOURNAL_Procurements
--Date written	   : 01-10-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts JOURNAL for Procurements                                
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

vrMoneyPartWithoutTax number;
vrMoneyPartTaxAmount number;

pc_AllTaxableStatus2 number;
DT_Total_Amount_Without_Tax number;

chfCountDays number;
chLCountDays number;

invStartDate varchar2(100);
invEndDate varchar2(100);
 monthly_cursor sys_refcursor;
 
 vMonthDate varchar2(100);
 
 VTax_Per number;
 
cursor TaxInDetatils is 
SELECT 
  INV_DETAIL_TAX_PERCENTAGE as DT_Tax_PERCENTAGE,
  sum(INV_DETAIL_TAX_AMOUNT) as DT_Tax_amount
FROM FA_INVOICE_DETAILS
where INV_CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=pc_invSer
 and INV_GUIDANCE_TYPE=2
 group by INV_DETAIL_TAX_PERCENTAGE;
 
 
begin




if pc_GUIDANCE_TYPE=2 then

pc_AllTaxableStatus2:=pc_AllTaxableStatus;

vrAmountWithoutTax:=pc_Amount_with_Tax/(pc_JOR_TAX_PERSANTAGE+1);
vrTaxAmount:=pc_Amount_with_Tax-vrAmountWithoutTax;

select  to_number(CC_COM_TAX_NO) into vrTaxAccountNo from FA_CUSTOMER_COMP where CC_ID=pc_CUSTOMER_ID;


if pc_to_date is not null then


 

SELECT 
  INV_DETAIL_TAX_PERCENTAGE into VTax_Per
FROM FA_INVOICE_DETAILS
where INV_CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=pc_invSer
 and INV_GUIDANCE_TYPE=2;
 
 
 
FA_Get_Months_between(
  pc_JOR_INVOICE_DATE,
  pc_to_date,
  pc_CUSTOMER_ID,
  pc_pay_Type,
  pc_JOR_ACCOUNTNO,
  pc_AllTaxableStatus2,
  pc_pay_monthly,
  VTax_Per,
  pc_Procurements_Desc,
  pc_supplier_AcountNo,
  pc_JOR_INVOICE_ID,
  pc_JOR_ATTACHMENT
) ;


else




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
    ' قيد مصروفات '||pc_Procurements_Desc,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
 

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



  if pc_AllTaxableStatus=1 then
  
  SELECT 
sum(INV_DETAIL_AMOUNT) into DT_Total_Amount_Without_Tax
FROM FA_INVOICE_DETAILS
where INV_CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=pc_invSer
 and INV_GUIDANCE_TYPE=2
 group by INV_CUSTOMER_ID,INV_ID,INV_GUIDANCE_TYPE;
   
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
    DT_Total_Amount_Without_Tax,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
   
   if pc_Assest_id>0 then
   
   INSERT
INTO FA_ASSESTS_EXPENSES
  (
    CUSTOMER_ID,
    INV_ID,
    EXP_ID,
    EXP_AMOUNT,
    EXP_DESC,
    S_STATUS,
    ASSEST_ID
  )
  VALUES
  (
    pc_CUSTOMER_ID,
    pc_JOR_INVOICE_ID,
    1,
    DT_Total_Amount_Without_Tax,
    pc_Procurements_Desc,
    1,
    pc_Assest_id
  );
  
  commit;
  
  end if;
  
   for cr_TaxInDetatils in TaxInDetatils
   
   loop
   
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
    cr_TaxInDetatils.DT_Tax_amount,
    0,
    cr_TaxInDetatils.DT_Tax_PERCENTAGE
  );
  
   commit;
   
   end loop;
   
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
    vrAmountWithoutTax,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
  
  
  if pc_Assest_id>0 then
  
   INSERT
INTO FA_ASSESTS_EXPENSES
  (
    CUSTOMER_ID,
    INV_ID,
    EXP_ID,
    EXP_AMOUNT,
    EXP_DESC,
    S_STATUS,
    ASSEST_ID
  )
  VALUES
  (
    pc_CUSTOMER_ID,
    pc_JOR_INVOICE_ID,
    1,
    vrAmountWithoutTax,
    pc_Procurements_Desc,
    1,
    pc_Assest_id
  );
  
  commit;
  
  end if;
  
  end if;








end if;

end if;








end;