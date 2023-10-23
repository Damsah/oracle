create or replace 
procedure FA_Insert_COMPAGREMENT
     (
       pc_CUSTOMER_ID               in number,
       pc_AG_AGREMENTDATE           in varchar2,
       pc_AG_CONTRATETIME           in number,
       pc_AG_YEARORMONTH            in number,
       pc_AG_TOTALPRICE             in number,
       pc_AG_ONSING                 in number,
       pc_AG_PAYMENTCOUNT           in number,
       pc_AG_TIRMINATECONTRACTDAYS  in number,
       pc_AG_NOTES                  in varchar2,
       Pc_Insert_Services           in varchar2,
       pc_USER                      in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_COMPAGREMENT
--Date written	   : 15-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Agement info                                       
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_COMPAGREMENT                                           
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
ch_is_created_before number;
getAG_id number;
ch_is_created_beforeSig number;

chExistData number;

AgPaymentMaset_id number;
begin

select count(CUSTOMER_ID) into chExistData from FA_COMPAGREMENT
where CUSTOMER_ID=pc_CUSTOMER_ID and AG_AGREMENTDATE=to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy');

select count(CUSTOMER_ID) into ch_is_created_before from FA_COMPAGREMENT
where CUSTOMER_ID=pc_CUSTOMER_ID and AG_AGREMENTDATE=to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy') and CONTRACT_SIGNED=0;

select count(CUSTOMER_ID) into ch_is_created_beforeSig from FA_COMPAGREMENT
where CUSTOMER_ID=pc_CUSTOMER_ID and AG_AGREMENTDATE=to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy') and CONTRACT_SIGNED=1;

if chExistData=0 then

update FA_COMPAGREMENT
set AG_DELETED=1
where CUSTOMER_ID=pc_CUSTOMER_ID;
commit;

select FXG_ID into vr_FXG_ID from FA_FIX_AGREMENT where FXG_DELETED=0;
 select nvl(max(AG_ID),0)+1 into vr_AgrementID  from FA_COMPAGREMENT  ;

INSERT
INTO FA_COMPAGREMENT
  (
AG_ID,
CUSTOMER_ID,
FXG_ID,
AG_AGREMENTDATE,
AG_CONTRATETIME,
AG_YEARORMONTH,
AG_TOTALPRICE,
AG_ONSING,
AG_PAYMENTCOUNT,
AG_TIRMINATECONTRACTDAYS,
AG_NOTES,
AG_AGRMENTWRITENDATE,
Ag_Contract_end_date,
AG_DELETED
  )
  VALUES
  (
   vr_AgrementID,
  pc_CUSTOMER_ID,
    vr_FXG_ID,
    to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),
    pc_AG_CONTRATETIME,
    pc_AG_YEARORMONTH,
    pc_AG_TOTALPRICE,
    pc_AG_ONSING,
    pc_AG_PAYMENTCOUNT,
    pc_AG_TIRMINATECONTRACTDAYS,
    pc_AG_NOTES,
    to_date(sysdate,'dd/mm/yyyy'),
     case when pc_AG_YEARORMONTH=1 then 
  (Select add_months(to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),pc_AG_CONTRATETIME*12) from dual )
  else
  (Select add_months(to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),pc_AG_CONTRATETIME) from dual )
  end, 
    0
  );
Commit; 


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
    vr_AgrementID,
  pc_CUSTOMER_ID,
  pc_AG_TOTALPRICE,
  0
   );

Commit; 

 Plsql_Services:=replace(Pc_Insert_Services,'@@@@@',vr_AgrementID); 
    if Plsql_Services is not NULL then
     Execute Immediate Plsql_Services;
    End If;


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
    vr_AgrementID,
    sysdate,
    pc_USER,
    'FA_COMPAGREMENT'
  );



commit;  

prm_id:=vr_AgrementID;


else


if ch_is_created_beforeSig=1 then

prm_id:=-505;

ELSE

select AG_ID into getAG_id from FA_COMPAGREMENT
where CUSTOMER_ID=pc_CUSTOMER_ID and AG_AGREMENTDATE=to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy') and CONTRACT_SIGNED=0;

DELETE
FROM FA_COMPAGREMENTSERVICES
WHERE  AG_ID=getAG_id;
commit;

DELETE
FROM FA_COMPAGREMENT
WHERE  CUSTOMER_ID=pc_CUSTOMER_ID
AND AG_AGREMENTDATE=to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy');
commit;

update FA_COMPAGREMENT
set AG_DELETED=1
where CUSTOMER_ID=pc_CUSTOMER_ID;
commit;

select FXG_ID into vr_FXG_ID from FA_FIX_AGREMENT where FXG_DELETED=0;
 select nvl(max(AG_ID),0)+1 into vr_AgrementID  from FA_COMPAGREMENT  ;

INSERT
INTO FA_COMPAGREMENT
  (
AG_ID,
CUSTOMER_ID,
FXG_ID,
AG_AGREMENTDATE,
AG_CONTRATETIME,
AG_YEARORMONTH,
AG_TOTALPRICE,
AG_ONSING,
AG_PAYMENTCOUNT,
AG_TIRMINATECONTRACTDAYS,
AG_NOTES,
AG_AGRMENTWRITENDATE,
Ag_Contract_end_date,
AG_DELETED
  )
  VALUES
  (
   vr_AgrementID,
  pc_CUSTOMER_ID,
    vr_FXG_ID,
    to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),
    pc_AG_CONTRATETIME,
    pc_AG_YEARORMONTH,
    pc_AG_TOTALPRICE,
    pc_AG_ONSING,
    pc_AG_PAYMENTCOUNT,
    pc_AG_TIRMINATECONTRACTDAYS,
    pc_AG_NOTES,
    to_date(sysdate,'dd/mm/yyyy'),
     case when pc_AG_YEARORMONTH=1 then 
  (Select add_months(to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),pc_AG_CONTRATETIME*12) from dual )
  else
  (Select add_months(to_date(pc_AG_AGREMENTDATE,'dd/mm/yyyy'),pc_AG_CONTRATETIME) from dual )
  end, 
    0
  );
Commit; 



Plsql_Services:=replace(Pc_Insert_Services,'@@@@@',vr_AgrementID); 
    if Plsql_Services is not NULL then
     Execute Immediate Plsql_Services;
    End If;


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
    'New Insert Oveload',
    vr_AgrementID,
    sysdate,
    pc_USER,
    'FA_COMPAGREMENT'
  );



commit;  

prm_id:=vr_AgrementID;

end if;


end if;






end;