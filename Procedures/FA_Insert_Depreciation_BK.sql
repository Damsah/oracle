create or replace 
procedure FA_Insert_Depreciation_BK

     (
       pc_CUSTOMER_ID               in number,
       pc_ASSEST_ACOUNT_NUMBER      in varchar2,
       pc_ASSEST_NAME               in varchar2,
       pc_ASSEST_ID                 in number,
       pc_ASSEST_START_DATE         in varchar2,
       pc_DP_ACCOUNT_NUMBER         in varchar2,
       pc_DP_PERSANTAGE             in number,
       pc_ASSEST_TOTAL_COST         in number,
       pc_DP_DAILY_DATE             in varchar2,
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
begin


 select count(*) into Xcount from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.DP_DAILY_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;


if Xcount=0 then
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
       to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),
       pc_DP_ACCOUNT_NUMBER,
       pc_DP_PERSANTAGE,
       pc_ASSEST_TOTAL_COST,
       to_date(pc_DP_DAILY_DATE,'dd/mm/yyyy'),
       vrCalFirstDay,
       vrCalFirstDay,
       (pc_ASSEST_TOTAL_COST-vrCalFirstDay),
       0
      );
  

Commit; 

end if;

select to_char(add_months(trunc(to_date(pc_DP_DAILY_DATE,'dd/mm/yyyy'), 'YEAR'), 12)-1/24/60/60,'dd/mm/yyyy') into  last_Day_in_year
from dual;

--vsStartDate :=to_date(to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),'DD-MON-YYYY');
vsStartDate :=to_date(to_date(pc_DP_DAILY_DATE,'dd/mm/yyyy'),'DD-MON-YYYY');
vsEndDate:=to_date(to_date(last_Day_in_year,'dd/mm/yyyy'),'DD-MON-YYYY');


--vsEndDate:=to_date(to_date(sysdate,'dd/mm/yyyy'),'DD-MON-YYYY');


 --select DAFTAR_VALUE_DAILY into vr_DAFTAR_VALUE_DAILY from FA_DEPRECIATION
 --where CUSTOMER_ID=pc_CUSTOMER_ID and ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and ASSEST_NAME=pc_ASSEST_NAME;
 /*
 select min(t1.DAFTAR_VALUE_DAILY) into vr_DAFTAR_VALUE_DAILY from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;
 */
 
 select nvl(max(t1.DP_AMOUNT_DAILY_COMP),0) into vr_DP_AMOUNT_DAILY_COMP from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;

 loop 
 
 vsStartDate:=vsStartDate+1;
 if(vsStartDate<=vsEndDate) then
 
 

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
  to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),
  pc_DP_ACCOUNT_NUMBER,
  pc_DP_PERSANTAGE,
  pc_ASSEST_TOTAL_COST,
  to_date(vsStartDate,'dd/mm/yyyy'),
  (pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365),
  (nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  pc_ASSEST_TOTAL_COST-(nvl(vr_DP_AMOUNT_DAILY_COMP,0)+(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE/365)),
  0
);

commit;

/*
 select min(t1.DAFTAR_VALUE_DAILY) into vr_DAFTAR_VALUE_DAILY from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;
*/


 select nvl(max(t1.DP_AMOUNT_DAILY_COMP),0) into vr_DP_AMOUNT_DAILY_COMP from FA_DEPRECIATION t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;


 else
 exit;
 
 end if;
 
 end loop;
 
 
 
 /*
 INSERT
INTO FA_DEPRECIATION
  (
    CUSTOMER_ID,
    ASSEST_ACOUNT_NUMBER,
    ASSEST_NAME,
    ASSEST_START_DATE,
    DP_ACCOUNT_NUMBER,
    DP_PERSANTAGE,
    ASSEST_TOTAL_COST,
    DP_DAILY_DATE,
    DP_AMOUNT_DAILY,
    DP_DELETED
  )
 select pc_CUSTOMER_ID,pc_ASSEST_ACOUNT_NUMBER,pc_ASSEST_NAME,
  to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),pc_DP_ACCOUNT_NUMBER,pc_DP_PERSANTAGE,
  pc_ASSEST_TOTAL_COST,
  to_char(to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') + level -1,'dd/mm/yyyy')
  ,vrCalFirstDay,0
from dual
connect by level <=
(  to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') -  to_date(''''||vDate||'''','yyyy-mm-dd') + 1 );


commit;

 */
prm_id:=1;


end;