create or replace 
procedure FA_Get_TAX_Items(
  refcur_SYSTEM_TAX_Items OUT sys_refcursor,
  pc_type number,
  pc_Tax_Year number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_TAX_Items
--Date written	   : 22-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data from FA_TAX_Items
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
 Sql_Statement := 'SELECT EST_TAX_ITEMS_ID,
  EST_TAX_ITEMS_NUMBER,
  EST_TAX_ITEMS_DESC
FROM FA_TAX_ITEMS
where EST_DELETED=0
order by 1';

 open refcur_SYSTEM_TAX_Items for Sql_Statement;
 
 else
 
 Sql_Statement := 'SELECT 
  m.EST_EMP_NAME,
  m.EST_EMP_TAXNO,
  d.TAX_YEAR,
  prNAT.SP_A_DESCRIPTION as Nationality_Desc,
  prEmpDoc.SP_A_DESCRIPTION as Emp_Doc_Desc,
  m.EST_EMP_IDENTIFIED_NO,
  m.EST_EMP_ADDRESS,
  m.EST_EMP_MOBILE,
  m.EST_EMP_EMAIL,
  DECODE (m.EST_EMP_WORKPLACE_TYPE,0, ''قطاع عام'', 1, ''قطاع خاص'',''غير معروف'') as WorkPlace_Type,
  case when m.EST_EMP_WORKPLACE_TYPE=0 then 
  (Select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS prEmpWType
  where m.EST_EMP_WORKPLACE=prEmpWType.SP_MINOR and prEmpWType.SP_MAJOR=''WOG'' )
  else
  (Select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS prEmpWType
  where m.EST_EMP_WORKPLACE=prEmpWType.SP_MINOR and prEmpWType.SP_MAJOR=''WOS'' )
  end as Emp_WrokPlace, 
  prMar.SP_A_DESCRIPTION as MARITAL_STATUS,
  prGen.SP_A_DESCRIPTION as GENDER,
  to_char(m.EST_EMP_BIRTHDATE,''dd/mm/yyyy'') as Emp_BirthDate,
  bnk.BANK_NAME as Bank_Name,
  bnkBr.BANK_BRANCH_NAME as Bank_Branch,
  m.EST_EMP_IBAN,
  prDpt.SP_A_DESCRIPTION as Tax_Dept,
  d.TOTAL_339 as i_339,
  d.TOTAL_3303 as  i_3303,
  d.TOTAL_3307 as i_3307,
  d.TOTAL_99310 as i_99310,
  d.TOTAL_993104 as i_993104,
  d.TOTAL_9027 as i_9027,
  d.TOTAL_9028 as i_9028,
  d.TOTAL_9029 as i_9029,
  d.DONATIONS_TO_GOVERNMENT as i_993105,
  d.TOTAL_99110 as i_99110,
  d.DONATIONS_SOCIAL as i_991201,
  d.TOTAL_99130 as i_99130,
  d.TOTAL_99510 as i_99510,
  d.SALARY_DEDUCTIONS as i_995201,
  d.CAR_CUSTOMS_FEES as i_995211,
  d.SAL_TAX_NEED as i_99540
FROM FA_COMP_EMP_SAL_TAX m
inner join FA_SYSTEM_PARAMETERS prNAT on m.EST_EMP_NATIONALITY=prNAT.SP_MINOR and prNAT.SP_MAJOR=''NAT''
inner join FA_SYSTEM_PARAMETERS prEmpDoc on m.EST_EMP_IDENTIFIED_TYPE=prEmpDoc.SP_MINOR and prEmpDoc.SP_MAJOR=''DOC''
inner join FA_SYSTEM_PARAMETERS prMar on m.EST_EMP_MARITAL_STATUS=prMar.SP_MINOR and prMar.SP_MAJOR=''MRS''
inner join FA_SYSTEM_PARAMETERS prGen on m.EST_EMP_GENDER=prGen.SP_MINOR and prGen.SP_MAJOR=''GND''
inner join FA_SYSTEM_PARAMETERS prDpt on m.EST_EMP_TAX_DEPARTMENT=prDpt.SP_MINOR and prDpt.SP_MAJOR=''DPT''
inner join FA_Banks bnk on m.EST_EMP_BANK=bnk.BANK_ID
inner join FA_BANK_BRANCH bnkBr on m.EST_EMP_BANK=bnkBr.BANK_ID and m.EST_EMP_BANK_BRANCH=bnkBr.BANK_BRANCH_ID
inner join FA_COMP_EMP_SAL_TAX_DETAILS d on m.EST_ID=d.EMP_ID and d.TAX_YEAR='||pc_Tax_Year||' 
 where m.EST_ID='||pc_type||' and m.EST_STATUS=0 and d.DELETED=0';

open refcur_SYSTEM_TAX_Items for Sql_Statement;
 
 end if;
 

 end;