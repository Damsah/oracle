create or replace 
procedure FA_insert_Customer_Company
     (
    pc_CUSTOMER_NAME       in varchar2,
    pc_CUSTOMER_NATIO      in number,
    pc_CUSTOMER_DOCTYPE    in number,
    pc_CUSTOMER_DOCTYPENO  in varchar2,
    pc_CUSTOMER_FILE       in varchar2,
    pc_CUSTOMER_MOBILE     in varchar2,
    pc_COMP_TYPE           in number,
    pc_COMP_SUBTYPE        in number,
    pc_COMP_NAME           in varchar2,
    pc_COMP_ESTABLISH_DATE in varchar2,
    pc_COMP_COMER_NO       in varchar2,
    pc_COM_TAX_NO          in varchar2,
    pc_COMP_NATIO_ID       in varchar2,
    pc_COMP_MONEY_CAPITAL  in number,
    pc_COMP_ADDRESS        in varchar2,
    pc_COMP_PHONE          in varchar2,
    pc_COMP_EMAIL          in varchar2,
    pc_SECTOR_ID           in number,
    pc_SALES_TAXABLE       in number,
    pc_EHLAK_STATUS        in number,
    pc_ACTIVITES_STATUS    in number,
    pc_KEEPING_ACCOUNT_STATUS  in number,
    pc_COMP_SPECIALIZATION in varchar2,
    pc_DelegateName        in varchar2,
    pc_DelegateCategory    in varchar2,
    pc_InsertDelegates     in  Varchar2,
    Pc_Insert_Goals        in  Varchar2,
    Pc_Insert_Owners       in  Varchar2,
    pc_USER                in varchar2,
    prm_id                 out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_insert_Customer_Company
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Customer and company info                                          
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
vr_CustCompID  varchar2(20);
vr_seq_no number;
Plsql_Delegates Varchar2(8000);
Plsql_Goals Varchar2(8000);
Plsql_Owners Varchar2(8000);
prm_idOut  number;
prm_idC number;
SMSText Varchar2(8000);
begin




 select nvl(max(CC_ID),0)+1 into vr_CustCompID  from FA_CUSTOMER_COMP  ;

INSERT
INTO FA_CUSTOMER_COMP
  (
    CC_ID,
    CC_CUSTOMER_NAME,
    CC_CUSTOMER_NATIO,
    CC_CUSTOMER_DOCTYPE,
    CC_CUSTOMER_DOCTYPENO,
    CC_CUSTOMER_FILE,
    CC_CUSTOMER_MOBILE,
    CC_COMP_TYPE,
    CC_COMP_SUBTYPE,
    CC_COMP_NAME,
    CC_COMP_ESTABLISH_DATE,
    CC_COMP_COMER_NO,
    CC_COM_TAX_NO,
    CC_COMP_NATIO_ID,
    CC_COMP_MONEY_CAPITAL,
    CC_COMP_ADDRESS,
    CC_COMP_PHONE,
    CC_COMP_EMAIL,
    CC_COMP_SPECIALIZATION,
    SECTOR_ID,
    SALES_TAXABLE,
    EHLAK_STATUS,
    ACTIVITES_STATUS,
    KEEPING_ACCOUNT_STATUS,
    CC_DELETED
  )
  VALUES
  (
   vr_CustCompID,
   pc_CUSTOMER_NAME,
    pc_CUSTOMER_NATIO,
    pc_CUSTOMER_DOCTYPE,
    pc_CUSTOMER_DOCTYPENO,
    pc_CUSTOMER_FILE,
    pc_CUSTOMER_MOBILE,
    pc_COMP_TYPE     ,
    pc_COMP_SUBTYPE  ,
    pc_COMP_NAME    ,
    to_date(pc_COMP_ESTABLISH_DATE,'dd/mm/yyyy'),
    pc_COMP_COMER_NO,
    pc_COM_TAX_NO   ,
    pc_COMP_NATIO_ID,
    pc_COMP_MONEY_CAPITAL,
    pc_COMP_ADDRESS ,
    pc_COMP_PHONE   ,
    pc_COMP_EMAIL   ,
    pc_COMP_SPECIALIZATION,
    pc_SECTOR_ID,
    pc_SALES_TAXABLE,
    pc_EHLAK_STATUS,
    pc_ACTIVITES_STATUS,
    pc_KEEPING_ACCOUNT_STATUS,
    0
  );
Commit; 



Plsql_Delegates:=replace(pc_InsertDelegates,'@@@@@',vr_CustCompID); 
    if Plsql_Delegates is not NULL then
     Execute Immediate Plsql_Delegates;
    End If;
Commit;



    Plsql_Goals:=replace(Pc_Insert_Goals,'@@@@@',vr_CustCompID); 
    if Plsql_Goals is not NULL then
     Execute Immediate Plsql_Goals;
    End If;
Commit;



    Plsql_Owners:=replace(Pc_Insert_Owners,'@@@@@',vr_CustCompID); 
    if Plsql_Owners is not NULL then
     Execute Immediate Plsql_Owners;
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
    vr_CustCompID,
    sysdate,
    pc_USER,
    'FA_CUSTOMER_COMP'
  );



commit;  

prm_id:=vr_CustCompID;

FA_Insert_Cust_Chart_Account
     (
    vr_CustCompID,
    pc_USER,
    prm_idC
     );

SMSText:='عزيزي العميل لقد تم تسجيل';

if pc_COMP_TYPE=1 then

SMSText:=SMSText||' '|| ' شركتكم ' ||pc_COMP_NAME ;
elsif pc_COMP_TYPE=2 then

SMSText:=SMSText||' '||' مؤسستكم ' ||pc_COMP_NAME ;

end if;

SMSText:=SMSText||' '|| ' بنجاح لدى سوفانا للإستشارات و تطوير المشاريع الإقتصادية , و نمتى لكم المزيد من التقدم و النجاح ';
SMSText:=SMSText||' '||' لمزيد عن خدماتنا زورو موقعنا على الإنترنت ';



SMSText:=SMSText||' https://suvanajo.com ';

 FA_Insert_Send_SMS
     (
       SMSText,
      pc_CUSTOMER_MOBILE,
      'عميل جديد',
      'SUVANA%20TAX',
      'UL5XpfNMcnuB1oDq',
      'suvanatax',
      1,
      prm_idOut
     );
     
    

end;