create or replace 
procedure FA_Get_Company_Agreements(
  refcur_SYSTEM_Comp_Agreements OUT sys_refcursor,
  pc_Where Varchar2,
  pc_type number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Company_Agreements
--Date written	   : 22-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data from
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
 
 if pc_type=0 then

 Sql_Statement := 'SELECT Agry.AG_ID,
  Agry.CUSTOMER_ID,
  comp.CC_COMP_NAME,
  comp.CC_COMP_SPECIALIZATION,
  to_char(Agry.AG_AGREMENTDATE,''dd/mm/yyyy'') AG_AGREMENTDATE,
  (Agry.AG_CONTRATETIME||'' ''||prYRM.SP_A_DESCRIPTION) as Contract_interval,
  Agry.AG_TOTALPRICE,
  Agry.AG_ONSING,
  Agry.AG_PAYMENTCOUNT,
  Agry.AG_TIRMINATECONTRACTDAYS||'' يوم '' as AG_TIRMINATECONTRACTDAYS, 
  Agry.CONTRACT_FILE,
  Agry.CONTRACT_SIGNED,
  decode(Agry.CONTRACT_SIGNED,0,''غير معتمد(لم يتم توقيعه بعد)'',1,''معتمد (تم توقيع العقد)'',''غير محدد'') SIGNE_Status,
  to_char(to_date(Agry.AG_CONTRACT_END_DATE,''dd/mm/rrrr''),''dd/mm/yyyy'') AG_CONTRACT_END_DATE,
  Agry.CONTRACT_STATUS CONTRACT_STATUS,
  prAGS.SP_A_DESCRIPTION CONTRACT_STATUS_Desc,
  Agry.VOUCHER_FILE VOUCHER_FILE
FROM FA_COMPAGREMENT Agry
inner join FA_CUSTOMER_COMP comp on Agry.CUSTOMER_ID=comp.CC_ID
inner join FA_SYSTEM_PARAMETERS prYRM on Agry.AG_YEARORMONTH=prYRM.SP_MINOR and prYRM.SP_MAJOR=''AGT''
inner join FA_SYSTEM_PARAMETERS prAGS on Agry.CONTRACT_STATUS=prAGS.SP_MINOR and prAGS.SP_MAJOR=''AGS''
inner join FA_Comp_Agrement_Payment py on Agry.AG_ID=py.AG_ID and py.Payment_Status=0
where Agry.AG_DELETED=0  '||pc_Where;

open refcur_SYSTEM_Comp_Agreements for Sql_Statement;
 
 end if;
 

 end;