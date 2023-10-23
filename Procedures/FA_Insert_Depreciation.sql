create or replace 
procedure FA_Insert_Depreciation
     (
       pc_CUSTOMER_ID               in number,
       pc_ASSEST_ACOUNT_NUMBER      in varchar2,
       pc_ASSEST_NAME               in varchar2,
       pc_ASSEST_ID                    in number,
       pc_ASSEST_START_DATE         in varchar2,
       pc_DP_ACCOUNT_NUMBER         in varchar2,
       pc_DP_Complx_ACCOUNT_NUMBER  in varchar2,
       pc_DP_PERSANTAGE             in number,
       pc_ASSEST_TOTAL_COST         in number,
       pc_USER                      in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Depreciation
--Date written	   : 26-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Daily Depreciation                                      
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_Depreciation                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As


vrCalFirstDay number;
vr_DAFTAR_VALUE_DAILY number;

minDafter number;

vDate varchar2(100);
vsStartDate Date;
vsEndDate Date;

vr_DP_AMOUNT_DAILY_COMP number;

last_Day_in_year varchar2(100);
Xcount number;


   chckLAstDateOfYear date;
  NXT_ID number; 
begin


vrCalFirstDay:=(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE)/365;


INSERT
INTO FA_DEPRECIATION
  (
    CUSTOMER_ID,
    ASSEST_ACOUNT_NUMBER,
    ASSEST_NAME,
    ASSEST_ID,
    ASSEST_START_DATE,
    DP_ACCOUNT_NUMBER,
    DP_PERSANTAGE,
    ASSEST_TOTAL_COST,
    DP_DAILY_DATE,
     DP_AMOUNT_DAILY,
    DP_AMOUNT_DAILY_COMP,
    DAFTAR_VALUE_DAILY,
    DP_DELETED
  )
  VALUES
  (
     
       pc_CUSTOMER_ID,
       pc_ASSEST_ACOUNT_NUMBER,
       pc_ASSEST_NAME,
       pc_ASSEST_ID,
       TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')),
       pc_DP_ACCOUNT_NUMBER,
       pc_DP_PERSANTAGE,
       pc_ASSEST_TOTAL_COST,
       TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')),
       vrCalFirstDay,
       vrCalFirstDay,
       (pc_ASSEST_TOTAL_COST-vrCalFirstDay),
       0
      );
  

Commit; 

select TRUNC(add_months(trunc(to_date(to_char(to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),'dd/mm/rrrr'),'dd/mm/yyyy'), 'YEAR'), 12)-1/24/60/60)
into chckLAstDateOfYear
from dual;


if TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr'))=chckLAstDateOfYear then
  
  INSERT
INTO FA_DEPRECIATION_COMPLEX
  (
    CUSTOMER_ID,
    ASSEST_ACOUNT_NUMBER,
    ASSEST_NAME,
    ASSEST_ID,
    ASSEST_START_DATE,
    DP_COMPLEX_ACCOUNT_NUMBER,
    DP_PERSANTAGE,
    ASSEST_TOTAL_COST,
    DP_COMPLEX_YEARLY_DATE,
    DP_COMPLEX_AMOUNT_YEARLY,
    DP_COMPLEX_AMOUNT,
    DAFTAR_VALUE_YEARLY
  )
  VALUES
  (
    pc_CUSTOMER_ID,
    pc_ASSEST_ACOUNT_NUMBER,
    pc_ASSEST_NAME,
    pc_ASSEST_ID,
    trunc(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')),
    pc_DP_Complx_ACCOUNT_NUMBER,
    pc_DP_PERSANTAGE,
    pc_ASSEST_TOTAL_COST,
    to_char(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr'),'dd/mm/yyyy'),
    (pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE),
  (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365))
  );
  
  
end if;

--select to_char(add_months(trunc(to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy'), 'YEAR'), 12)-1/24/60/60,'dd/mm/yyyy') into  last_Day_in_year
--from dual;

select TRUNC(to_date(to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),'DD-MON-YYYY')) into vsStartDate from dual;
select TRUNC(to_date(to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy'),'DD-MON-YYYY')) into vsEndDate from dual;
--vsStartDate :=to_date(to_date('01/11/2021','dd/mm/yyyy'),'DD-MON-YYYY');
--vsEndDate:=to_date(to_date(TO_CHAR(last_Day_in_year,'dd/mm/yyyy'),'dd/mm/yyyy'),'DD-MON-YYYY');

 
 select nvl(max(t1.DP_AMOUNT_DAILY_COMP),0) into vr_DP_AMOUNT_DAILY_COMP from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')) and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;

 loop 
 
 vsStartDate:=vsStartDate+1;
 --if(vsStartDate<=vsEndDate) then
 if((nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365))<=pc_ASSEST_TOTAL_COST) then
 

 INSERT
INTO FA_DEPRECIATION
  (
    CUSTOMER_ID,
    ASSEST_ACOUNT_NUMBER,
    ASSEST_NAME,
    ASSEST_ID,
    ASSEST_START_DATE,
    DP_ACCOUNT_NUMBER,
    DP_PERSANTAGE,
    ASSEST_TOTAL_COST,
    DP_DAILY_DATE,
    DP_AMOUNT_DAILY,
    DP_AMOUNT_DAILY_COMP,
    DAFTAR_VALUE_DAILY,
    DP_DELETED
  ) VALUES
  (
  pc_CUSTOMER_ID,
  pc_ASSEST_ACOUNT_NUMBER,
  pc_ASSEST_NAME,
  pc_ASSEST_ID,
  TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')),
  pc_DP_ACCOUNT_NUMBER,
  pc_DP_PERSANTAGE,
  pc_ASSEST_TOTAL_COST,
  TRUNC(to_date(vsStartDate,'dd/mm/rrrr')),
  (pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365),
  (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  0
);



commit;
select TRUNC(add_months(trunc(to_date(to_char(to_date(vsStartDate,'dd/mm/yyyy'),'dd/mm/rrrr'),'dd/mm/yyyy'), 'YEAR'), 12)-1/24/60/60)
into chckLAstDateOfYear
from dual;

if vsStartDate=chckLAstDateOfYear then

INSERT
INTO FA_DEPRECIATION_COMPLEX
  (
    CUSTOMER_ID,
    ASSEST_ACOUNT_NUMBER,
    ASSEST_NAME,
    ASSEST_ID,
    ASSEST_START_DATE,
    DP_COMPLEX_ACCOUNT_NUMBER,
    DP_PERSANTAGE,
    ASSEST_TOTAL_COST,
    DP_COMPLEX_YEARLY_DATE,
    DP_COMPLEX_AMOUNT_YEARLY,
    DP_COMPLEX_AMOUNT,
    DAFTAR_VALUE_YEARLY
  )
  VALUES
  (
    pc_CUSTOMER_ID,
    pc_ASSEST_ACOUNT_NUMBER,
    pc_ASSEST_NAME,
    pc_ASSEST_ID,
    trunc(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')),
    pc_DP_Complx_ACCOUNT_NUMBER,
    pc_DP_PERSANTAGE,
    pc_ASSEST_TOTAL_COST,
    to_char(to_date(vsStartDate,'dd/mm/rrrr'),'dd/mm/yyyy'),
    (pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE),
  (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365))
  );
  

  
  commit;
  
  select FA_JOURNAL_seq_no.NEXTVAL into NXT_ID from dual;
  
  insert into FA_JOURNAL
  (
  JOR_ID,
  JOR_CUSTOMER_ID,
  JOR_DATE,
  JOR_DESC
  )
  values
  (
   NXT_ID,
   pc_CUSTOMER_ID,
   trunc(to_date(vsStartDate,'dd/mm/rrrr')),
   ' قيد إهلاك السنة '||to_char(trunc(to_date(vsStartDate,'dd/mm/rrrr')),'YYYY')||' للأصل '||pc_ASSEST_NAME||' رقم '||pc_ASSEST_ID
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
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    pc_DP_ACCOUNT_NUMBER,
    (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
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
    pc_CUSTOMER_ID,
    (select nvl(max(JOR_DETAIL_ID),0)+1 from FA_JOURNAL_DETAILS where JOR_CUSTOMER_ID=pc_CUSTOMER_ID and JOR_ID=NXT_ID),
    pc_DP_Complx_ACCOUNT_NUMBER,
    0,
    (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365))
  );
  
end if;



 select nvl(max(t1.DP_AMOUNT_DAILY_COMP),0) into vr_DP_AMOUNT_DAILY_COMP from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=TRUNC(to_date(pc_ASSEST_START_DATE,'dd/mm/rrrr')) and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;


 else
 exit;
 
 end if;
 
 end loop;
 



 
prm_id:=1;


end;