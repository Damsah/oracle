create or replace 
procedure FA_Get_Months_between(
  pc_from_date varchar2,
  pc_to_date varchar2,
  pc_CUSTOMER_ID in NUMBER,
  pc_pay_Type in number,
  pc_JOR_ACCOUNTNO  in varchar2,
  pc_AllTaxableStatus  in number,
  pc_pay_monthly  in number,
  pc_JOR_TAX_PERSANTAGE in number,
  pc_Procurements_Desc in VARCHAR2,
  pc_supplier_AcountNo in number,
  pc_JOR_INVOICE_ID in number,
  pc_JOR_ATTACHMENT in VARCHAR2
) 
as
vrAmountWithoutTax number;
vrTaxAmount number;

NXT_ID number;

ChkChashBox number;
ChashBoxAccountNumber number;

ChkBank number;
BankAccountNumber number;

vrTaxAccountNo number;

vrCoundDays number;

type Nested_table is table of varchar2(10);

Months Nested_table;

  
  
begin
/*
vrAmountWithoutTax:=pc_pay_monthly/(nvl(pc_JOR_TAX_PERSANTAGE,0)+1);
vrTaxAmount:=pc_pay_monthly-vrAmountWithoutTax;

select  to_number(CC_COM_TAX_NO) into vrTaxAccountNo from FA_CUSTOMER_COMP where CC_ID=pc_CUSTOMER_ID;
*/
if to_char(to_date(pc_from_date,'dd/mm/yyyy'),'mm')!=to_char(to_date(pc_to_date,'dd/mm/yyyy'),'mm') and to_char(to_date(pc_from_date,'dd/mm/yyyy'),'yyyy')!=to_char(to_date(pc_to_date,'dd/mm/yyyy'),'yyyy')  then


select to_char(to_date(to_char(add_months(trunc(to_date(pc_from_date,'dd/mm/yyyy'),'mm'),rownum),'dd/mm/yyyy'),'dd/mm/yyyy'),'dd/mm/yyyy') bulk collect into Months
 from dual
 connect by level<CEIL(months_between(to_date(pc_to_date,'dd/mm/yyyy'),to_date(pc_from_date,'dd/mm/yyyy'))) ;
 

 for i in 1..Months.count
 
 loop
    
  
   
   if i<Months.count and i!=1 then
   
   
   --dbms_output.put_line ('after i= '||i||' '||Months(i));
   
  FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(i),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
   
   else
   if i=1 then
   
   if  trunc(to_date(pc_from_date,'dd/mm/yyyy'),'mm')=to_date(pc_from_date,'dd/mm/yyyy') then
   
  
 
   --dbms_output.put_line ('after i= 0 '||pc_from_date);
   
   FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_from_date,
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
 
   
   --dbms_output.put_line ('after i= '||i||' '||Months(i));
  
   
   FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(i),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
     
   else
   if (trunc(Last_day(to_date(pc_from_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd'))!=0 then
  
  -- dbms_output.put_line ('Days from  '||pc_from_date||'  '||(trunc(Last_day(to_date(pc_from_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd')));
   --dbms_output.put_line ('Days from '||pc_from_date||'  '||to_char(to_number(to_char(Last_day(to_date(pc_from_date,'dd/mm/yyyy')),'dd'))-(trunc(Last_day(to_date(pc_from_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd'))));
   vrCoundDays:=to_number((trunc(Last_day(to_date(pc_from_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd')));
   
  if to_number(to_char(trunc(to_date(pc_from_date,'dd/mm/yyyy')),'dd'))=to_number(to_char(trunc(to_date(pc_to_date,'dd/mm/yyyy')),'dd')) then
   vrCoundDays:=vrCoundDays+1;
  end if;
  
 FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_from_date,
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       vrCoundDays
     );


    --dbms_output.put_line ('after i= '||i||' '||Months(i));
    
    FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(i),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );

    
   else
   
    --dbms_output.put_line ('after i= '||i||' '||Months(i));
    
  FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(i),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
    
   end if;
 end if;
   else
   
   if Last_day(to_date(Months(Months.count),'dd/mm/yyyy'))=Last_day(to_date(pc_to_date,'dd/mm/yyyy')) then
   
   if (trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))!=0 then
   
   --dbms_output.put_line ('Days form '||pc_to_date||' '||to_char(to_number(to_char(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd'))-(trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))));
   
   vrCoundDays:=to_number(to_char(to_number(to_char(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd'))-(trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))));
  
  FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_to_date,
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       vrCoundDays
     );
    
   else
   --dbms_output.put_line ('after i= '||Months.count||' '||Months(Months.count));
   
  
  FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(Months.count),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
     
   end if;
   
   else
   --dbms_output.put_line ('after i= '||Months.count||' '||Months(Months.count));
   

  FA_Insert_JOURNAL_Exp_Monthly
     (
       Months(Months.count),
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       31
     );
  
    
    if (trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))!=0 then
   
   --dbms_output.put_line ('Days form '||pc_to_date||' '||to_char(to_number(to_char(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd'))-(trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))));
   
   vrCoundDays:=to_number(to_char(to_number(to_char(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd'))-(trunc(Last_day(to_date(pc_to_date,'dd/mm/yyyy')),'dd')-trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd'))));
  
  if vrCoundDays!=1 then
   FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_to_date,
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       vrCoundDays
     );
     
     end if;
     
   
   end if;
   
   end if;
   
   
   
   end if;
   
    end if;
    
   end loop;
   
   else
   
   --dbms_output.put_line ('Days from '||pc_from_date||' to '||pc_to_date||' '||to_char(to_number((trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd')))+1));
   
   vrCoundDays:=to_number(to_char(to_number((trunc(to_date(pc_to_date,'dd/mm/yyyy'),'dd')-trunc(to_date(pc_from_date,'dd/mm/yyyy'),'dd')))+1));
   
     FA_Insert_JOURNAL_Exp_Monthly
     (
       pc_from_date,
       pc_CUSTOMER_ID,
       pc_pay_Type,
       pc_JOR_ACCOUNTNO,
       pc_JOR_TAX_PERSANTAGE,
       pc_Procurements_Desc,
       pc_JOR_INVOICE_ID,
       pc_JOR_ATTACHMENT,
       pc_AllTaxableStatus,
       pc_pay_monthly,
       vrCoundDays
     );
    
  end if;
   
 end;