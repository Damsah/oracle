create or replace 
procedure FA_Insert_JOURNAL_Procurements
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
       pc_MoneyPart          in number,
       pc_invSer             in number,
       pc_PRocDontStatus     in number
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


cursor TaxInDetatils is 
SELECT 
  INV_DETAIL_TAX_PERCENTAGE as DT_Tax_PERCENTAGE,
  sum(INV_DETAIL_TAX_AMOUNT) as DT_Tax_amount
FROM FA_INVOICE_DETAILS
where INV_CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=pc_invSer
 and INV_GUIDANCE_TYPE=3
 group by INV_DETAIL_TAX_PERCENTAGE;
 
 
begin

if pc_GUIDANCE_TYPE=3 then



pc_AllTaxableStatus2:=pc_AllTaxableStatus;

vrAmountWithoutTax:=pc_Amount_with_Tax/(pc_JOR_TAX_PERSANTAGE+1);
vrTaxAmount:=pc_Amount_with_Tax-vrAmountWithoutTax;

select  to_number(CC_COM_TAX_NO) into vrTaxAccountNo from FA_CUSTOMER_COMP where CC_ID=pc_CUSTOMER_ID;


select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;
  
  
-----------عربون  قيد رئيسي------------
  
  if pc_pay_Type=4 then

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
    trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
    ' قيد مشتريات - عربون - '||pc_Procurements_Desc,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
  
 else

 
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
    trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),--sysdate
    ' قيد مشتريات '||pc_Procurements_Desc,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
 


 end if;
  
----------------نهاية عربون قيد رئيسي -------
  
-------------------عربون قيود تفصيلية-------------

if pc_pay_Type=4 then

vrMoneyPartWithoutTax:=pc_MoneyPart/(pc_JOR_TAX_PERSANTAGE+1);
vrMoneyPartTaxAmount:=pc_MoneyPart-vrMoneyPartWithoutTax;


 select count(*) into ChkChashBox
FROM FA_CUSTOMER_CHART_OF_ACCOUNT
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME='الصندوق';



---------------------------قيد صندوق عربون----


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
    pc_MoneyPart,
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
   
end if;


--------نهاية قيد صندوق عربون----------


------------------قيد الخاص بالجانب الاخر لصندوق عربون----------
if pc_AllTaxableStatus=1 then

---------------------------قيد جانب اخر عربون ضريبي-----------------------
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
    pc_MoneyPart,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
  
  
  commit;
  

   ---------------------------------- لعربون نهاية قيد الجانب الاخر ضريبي--------------
   
   
   ------------------------قيد التسليم ضريبي----------
   if pc_PRocDontStatus=2 then
   
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
    ' قيد مشتريات - إثبات تسليم - '||pc_Procurements_Desc,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
  
  
  
  -----------------------------قيد التسليم للجانب الاخر ضريبي تفصيل------------
   
   
   --------------------------------------قيد الجانب المدين للعميل-----------------------------
   
   
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
  
   
   ---------------------------------------------نهاية الجانب المدين للعميل----------------
   
   ------------------------------------------قيد الجانب الدائن لتسليم المشتريات ضريبي-------------------------------
   
    SELECT 
sum(INV_DETAIL_AMOUNT) into DT_Total_Amount_Without_Tax
FROM FA_INVOICE_DETAILS
where INV_CUSTOMER_ID=pc_CUSTOMER_ID and INV_ID=pc_invSer
 and INV_GUIDANCE_TYPE=3
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
   
   pc_AllTaxableStatus2:=2;
   
   end if;
   -------------------------------------------------------إنهاء قيد الجانب الدائن لتسليم المشتريات ضريبي-----------------------------
   
   
   --------------------------------------------------نهاية قيد التسليم الجانب الاخر تفصيلي------------------------
   
   -------------------------------نهاية قيد التسليم ضريبي--------------
   
ELSE


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
    pc_MoneyPart,
    0,
    pc_JOR_TAX_PERSANTAGE
  );
  
  
  
  commit;

if pc_PRocDontStatus=2 then
----------------------------قيد تسليم غير ضريبي ---------------------

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
    ' قيد مشتريات - إثبات تسليم - '||pc_Procurements_Desc,
     pc_JOR_INVOICE_ID,
     trunc(to_date(pc_JOR_INVOICE_DATE,'dd/mm/rrrr')),
     pc_JOR_ATTACHMENT,
     pc_pay_Type
  );
  commit;
  
  
  -----------------------قيد تسليم غير ضريبي تفصيلي----------------------------
  
  
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
    pc_JOR_TAX_PERSANTAGE
  );
  
   commit;
   
   end if;
  ----------------------------------------نهاية قيد تسليم غير ضريبي تفصيلي--------------------

------------------------------------نهاية قيد تسليم غير ضريبي---------------

end if;



---------------------------نهاية القيد الخاص بالجانب الاخر لصندوق عربون------------------

-------------------ليس عربوننن----------------------


else


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
 and INV_GUIDANCE_TYPE=3
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
  
  end if;


end if;


----------------------------نهاية قيود عربون تفصيلي---------------


--------------------------------------- 









end if;








end;