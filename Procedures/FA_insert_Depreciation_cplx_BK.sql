create or replace 
procedure FA_insert_Depreciation_cplx_BK
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
       pc_start_year                in boolean,
       pc_USER                      in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_insert_Depreciation_complex
--Date written	   : 26-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Yearly Depreciation                                      
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_Depreciation_complex                                           
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

vr_DAFTAR_VALUE_YEARLY number;
vr_DP_COMPLEX_AMOUNT number;
begin

if pc_start_year=true then



INSERT
INTO FA_Depreciation_complex
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
DAFTAR_VALUE_YEARLY
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
       to_date((select trunc(To_date(pc_DP_DAILY_DATE,'dd/mm/yyyy'),'YEAR')  from dual),'dd/mm/yyyy'), 
       pc_ASSEST_TOTAL_COST
      );
  

Commit; 

else

 select min(t1.DAFTAR_VALUE_YEARLY) into vr_DAFTAR_VALUE_YEARLY from FA_Depreciation_complex t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_COMPLEX_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;


 select nvl(max(DP_COMPLEX_AMOUNT),0) into vr_DP_COMPLEX_AMOUNT from FA_Depreciation_complex t1
where t1.CUSTOMER_ID=pc_CUSTOMER_ID and
t1.ASSEST_ACOUNT_NUMBER=pc_ASSEST_ACOUNT_NUMBER and
t1.ASSEST_NAME=pc_ASSEST_NAME and
t1.ASSEST_START_DATE=to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy') and
t1.DP_COMPLEX_ACCOUNT_NUMBER=pc_DP_ACCOUNT_NUMBER and
t1.DP_PERSANTAGE=pc_DP_PERSANTAGE and
t1.ASSEST_TOTAL_COST=pc_ASSEST_TOTAL_COST;

vrCalFirstDay:=(pc_ASSEST_TOTAL_COST*pc_DP_PERSANTAGE);

INSERT
INTO FA_Depreciation_complex
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
       to_date(pc_ASSEST_START_DATE,'dd/mm/yyyy'),
       pc_DP_ACCOUNT_NUMBER,
       pc_DP_PERSANTAGE,
       pc_ASSEST_TOTAL_COST,
       to_date((select add_months(trunc(To_date(pc_DP_DAILY_DATE,'dd/mm/yyyy'),'YEAR'),12)-1  from dual),'dd/mm/yyyy'), 
       vrCalFirstDay,
       (vrCalFirstDay+vr_DP_COMPLEX_AMOUNT),
      ( pc_ASSEST_TOTAL_COST-(vrCalFirstDay+vr_DP_COMPLEX_AMOUNT))
      );

end if;
 
prm_id:=1;


end;