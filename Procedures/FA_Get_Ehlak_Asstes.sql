create or replace 
procedure FA_Get_Ehlak_Asstes(
  refcur_SYSTEM_Ehlak_Asstes OUT sys_refcursor,
  pc_Where in varchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Ehlak_Asstes
--Date written	   : 3-07-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs for customer Ehlak asstes
--                                                            
--Program Inputs   : refer to the parameter list.
--Program outputs  : get data
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

 as
 Sql_Statement Varchar2(8000);
 
 begin
 
 if pc_Where!=' ' then
 

 Sql_Statement := 'SELECT 
   Fn_get_Account_Name(DP_ACCOUNT_NUMBER,CUSTOMER_ID) Ehlak_Account,
  ASSEST_NAME,
  ASSEST_ID,
   to_char(to_date(ASSEST_START_DATE,''dd/mm/rrrr''),''dd/mm/yyyy'') Started_Date,
    ASSEST_TOTAL_COST,
  DP_PERSANTAGE,
  to_char(to_date(DP_DAILY_DATE,''dd/mm/rrrr''),''dd/mm/yyyy'') Daily_Date,
  trunc(DP_AMOUNT_DAILY,10) DP_AMOUNT_DAILY,
  trunc(DP_AMOUNT_DAILY_COMP,20) DP_AMOUNT_DAILY_COMP,
  trunc(DAFTAR_VALUE_DAILY,20) DAFTAR_VALUE_DAILY
FROM FA_DEPRECIATION
 where DP_DELETED=0  
     '||pc_Where||'   order by to_date(DP_DAILY_DATE,''dd/mm/rrrr'')';  
 open refcur_SYSTEM_Ehlak_Asstes for Sql_Statement;
 
end if;

 end;