create or replace 
procedure FA_Insert_Agreement_Payments
     (
       pc_Agremeent_Id              in number,
       pc_PayAmount                 in number,
       pc_Recipt_Name               in Varchar2,
       pc_Pay_Type                  in number,
       pc_pay_for                   in varchar2,
       pc_Bank_id                   in number,
       pc_ChequeNo                  in number,
       pc_Operations                in number,
       pc_ReciptMobile              in varchar2,
       pc_USER                      in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Agreement_Payments
--Date written	   : 01-09-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Payments info                                       
--Program Inputs   : 
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_Co_Agrement_Pay_Details                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As

vr_AGP_id number;
vr_Voucher_No number;
vr_seq_no number;
vr_Total_Amount number;
ch_sum_py number;
ch_Payment_Status number;
vr_CustomerId number;
SMSText Varchar2(8000);
vr_customer_mobile varchar2(50);
prm_idOut number;

AgPaymentMaset_id number;
begin

if pc_Operations=0 then
select AGP_id,Total_Amount,Payment_Status,Customer_id into vr_AGP_id,vr_Total_Amount,ch_Payment_Status,vr_CustomerId 
from FA_Comp_Agrement_Payment where AG_ID=pc_agremeent_id;

 select nvl(max(Voucher_No),0)+1 into vr_Voucher_No  from FA_Co_Agrement_Pay_Details  ;
 select nvl(sum(Voucher_Amount),0) into ch_sum_py  from FA_Co_Agrement_Pay_Details  ;
 select CC_CUSTOMER_MOBILE into vr_customer_mobile from FA_CUSTOMER_COMP where CC_ID=vr_CustomerId ;
 
if ch_Payment_Status=0 then
insert into FA_Co_Agrement_Pay_Details 
   (
   AGP_id , 
   Voucher_No , 
  Voucher_Date, 
  Voucher_Amount ,
  Voucher_Desc ,
  Payment_Type,
  Bank_id,
  Cheque_No,
  Recipt_name
  )
  values
  (
  vr_AGP_id,
  vr_Voucher_No,
  trunc(to_date(sysdate,'dd/mm/rrrr')),
  pc_PayAmount,
  pc_pay_for,
  pc_Pay_Type,
  pc_bank_id,
  pc_chequeno,
  pc_recipt_name
  );
  commit;

update FA_COMPAGREMENT
set CONTRACT_SIGNED=1,CONTRACT_STATUS=2
where AG_ID=pc_agremeent_id;
commit;

if ch_sum_py=pc_PayAmount then

update FA_Comp_Agrement_Payment
set Payment_Status=1
where AG_ID=pc_agremeent_id;

commit;

end if;

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
    vr_Voucher_No,
    sysdate,
    pc_USER,
    'سند قبض'
  );
commit;

prm_id:=vr_Voucher_No;

else
prm_id:=-505;
end if;


if prm_id>-505 then

SMSText:='عزيزي العميل نود أن نشكرك على دفعك مبلغ ';
SMSText:=SMSText||'   '||pc_PayAmount||' دينار ';
SMSText:=' '||SMSText||'و ذلك عن عقد رقم ';
SMSText:=SMSText||' '||pc_agremeent_id||'  .  ';
SMSText:=SMSText||' رقم سند القبض '||vr_Voucher_No;
SMSText:=SMSText||' بتاريخ '||to_char(trunc(to_date(sysdate,'dd/mm/rrrr')),'dd/mm/yyyy')||' ';
SMSText:=SMSText||'      '||' لمزيد عن خدماتنا زورو موقعنا على الإنترنت ';
SMSText:=SMSText||' https://suvanajo.com ';


--vr_customer_mobile
 FA_Insert_Send_SMS
     (
       SMSText,
      '0796707173',
      'سند قبض',
      'SUVANA%20TAX',
      'UL5XpfNMcnuB1oDq',
      'suvanatax',
      1,
      prm_idOut
     );
     
     
end if;

elsif pc_Operations=1 then

select nvl(max(Voucher_No),0)+1 into vr_Voucher_No  from FA_Co_Agrement_Pay_Details  ;

select nvl(max(AGP_id),0)+1 into AgPaymentMaset_id  from FA_Comp_Agrement_Payment  ;

insert into FA_Comp_Agrement_Payment
   (
   AGP_id, 
   AG_ID, 
  Customer_id , 
  Total_Amount,
  Payment_Status
   )
   VALUES
   (
   AgPaymentMaset_id,
    0,
  0,
  pc_PayAmount,
  0
   );

Commit; 

insert into FA_Co_Agrement_Pay_Details 
   (
   AGP_id , 
   Voucher_No , 
  Voucher_Date, 
  Voucher_Amount ,
  Voucher_Desc ,
  Payment_Type,
  Bank_id,
  Cheque_No,
  Recipt_name
  )
  values
  (
  AgPaymentMaset_id,
  vr_Voucher_No,
  trunc(to_date(sysdate,'dd/mm/rrrr')),
  pc_PayAmount,
  pc_pay_for,
  pc_Pay_Type,
  pc_bank_id,
  pc_chequeno,
  pc_recipt_name
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
    vr_Voucher_No,
    sysdate,
    pc_USER,
    'سند قبض عام'
  );
commit;

prm_id:=vr_Voucher_No;


SMSText:='عزيزي العميل نود أن نشكرك على دفعك مبلغ ';
SMSText:=SMSText||'   '||pc_PayAmount||' دينار ';
SMSText:=SMSText||'  '||pc_pay_for||'  وذلك عن  ';
SMSText:=SMSText||'  .  ';
SMSText:=SMSText||' رقم سند القبض '||vr_Voucher_No;
SMSText:=SMSText||' بتاريخ '||to_char(trunc(to_date(sysdate,'dd/mm/rrrr')),'dd/mm/yyyy')||' ';
SMSText:=SMSText||'      '||' لمزيد عن خدماتنا زورو موقعنا على الإنترنت ';
SMSText:=SMSText||' https://suvanajo.com ';


--vr_customer_mobile
 FA_Insert_Send_SMS
     (
       SMSText,
      pc_ReciptMobile,
      'سند قبض',
      'SUVANA%20TAX',
      'UL5XpfNMcnuB1oDq',
      'suvanatax',
      1,
      prm_idOut
     );

end if;

end;