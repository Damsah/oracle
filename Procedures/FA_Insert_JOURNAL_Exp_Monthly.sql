create or replace 
procedure FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_date               in varchar2,
       pc_CUSTOMER_ID    	   in NUMBER,
       pc_pay_Type           in number,
       pc_JOR_ACCOUNTNO      in varchar2,
       pc_JOR_TAX_PERSANTAGE in number,
       pc_Procurements_Desc  in VARCHAR2,
       pc_JOR_INVOICE_ID	   in number,
       pc_JOR_ATTACHMENT	   in VARCHAR2,
       pc_AllTaxableStatus   in number,
       pc_pay_monthly        in number,
       pc_count_day          in number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_JOURNAL_Expenses_Monthly
--Date written	   : 07-11-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts JOURNAL for Exp monthly                                
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
 

 vAmountDaily number;
 
begin



vAmountDaily:=((pc_pay_monthly/31)*pc_count_day);
--vAmountDaily:=trunc(((pc_pay_monthly/31)*pc_count_day),2);


pc_AllTaxableStatus2:=pc_AllTaxableStatus;

vrAmountWithoutTax:=vAmountDaily/(nvl(pc_JOR_TAX_PERSANTAGE,0)+1);
vrTaxAmount:=vAmountDaily-vrAmountWithoutTax;

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
    trunc(to_date(pc_date,'dd/mm/rrrr')),
    ' قيد مصروفات '||pc_Procurements_Desc||' عن شهر '||pc_date ||' عدد الايام '||pc_count_day,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_date,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
 

  if  to_number(to_char(to_date(pc_date,'dd/mm/yyyy'),'yyyy'))<=to_number(to_char(to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy'),'yyyy')) then
   
  
 

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
    vAmountDaily,
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
    vAmountDaily,
    pc_JOR_TAX_PERSANTAGE
  );
  
  commit;
  
end if;


end if;


  
   

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
    vrAmountWithoutTax,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
  
 
  
  end if;



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
    117,
    vAmountDaily,
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
    pc_JOR_ACCOUNTNO,
    0,
    vAmountDaily,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;

end if;















end;