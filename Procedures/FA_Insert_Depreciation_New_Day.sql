create or replace 
procedure FA_Insert_Depreciation_New_Day
     (
       pc_CUSTOMER_ID               in number,
       pc_ASSEST_ACOUNT_NUMBER      in varchar2,
       pc_ASSEST_NAME               in varchar2,
       pc_ASSEST_ID                 in number,
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
xdt date;
begin


 select count(*) into Xcount from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=PC_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=PC_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=PC_ASSEST_NAME and
t1.ASSEST_START_DATE= trunc(to_date(PC_ASSEST_START_DATE,'dd/mm/rrrr')) and
t1.DP_ACCOUNT_NUMBER=PC_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE= PC_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=PC_ASSEST_TOTAL_COST
and t1.DP_DAILY_DATE= trunc(to_date(sysdate,'dd/mm/rrrr'));

if Xcount=0 then


 select nvl(max(t1.DP_AMOUNT_DAILY_COMP),0) into vr_DP_AMOUNT_DAILY_COMP from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=PC_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=PC_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=PC_ASSEST_NAME and
t1.ASSEST_START_DATE= trunc(to_date(PC_ASSEST_START_DATE,'dd/mm/rrrr')) and
t1.DP_ACCOUNT_NUMBER=PC_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE= PC_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=PC_ASSEST_TOTAL_COST;


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
       TRUNC(to_date(sysdate,'dd/mm/rrrr')),--to_date(to_char(sysdate,'dd/mm/rrrr'),'dd/mm/rrrr'),
       vrCalFirstDay,
       vrCalFirstDay+vr_DP_AMOUNT_DAILY_COMP,
       pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+vrCalFirstDay),
       0
      );
  

Commit;



select TRUNC(add_months(trunc(to_date(to_char(to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/rrrr'),'dd/mm/rrrr'),'dd/mm/yyyy'), 'YEAR'), 12)-1/24/60/60)
into chckLAstDateOfYear
from dual;


select TRUNC(to_date(sysdate,'dd/mm/rrrr')) into xdt from dual;
--if TRUNC(to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/rrrr'))=chckLAstDateOfYear then
if xdt=chckLAstDateOfYear then


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
    to_char(to_date(xdt,'dd/mm/rrrr'),'dd/mm/yyyy'),
    (pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE),
  (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365))
  );

end if;


end if;



prm_id:=1;


end;