create or replace 
procedure FA_Get_Emp_incom_Tax_years(
  refcur_SYSTEM_incom_Tax_years OUT sys_refcursor,
  pc_Where Varchar2,
  pc_Tax_Year number,
  pc_Emp_Name Varchar2,
  pc_type number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Emp_incom_Tax_years
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

 Sql_Statement := 'SELECT 
 d.EMP_ID EMP_ID,
  d.DETAILS_ID DETAILS_ID,
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
  d.INCOM_FILE INCOM_FILE,
  d.WIFE_AGREE_FILE,
  d.EMP_ANNUAL_SALARY_ATTACH,
  d.WIFE_ANNUAL_SALARY_ATTACH,
  d.TOTAL_RETIREMENT_ATTACH,
  d.COUNT_DISABLED_CHILDREN_ATTACH,
  d.ANNUAL_EMP_EXPENSES_ATTACH,
  d.ANNUAL_WIFE_EXPENSES_ATTACH,
  d.C_1_LEARNING_EXPENSE_ATTACH,
  d.C_2_LEARNING_EXPENSE_ATTACH,
  d.C_3_LEARNING_EXPENSE_ATTACH,
  d.COUNT_DEPENDENTS_ATTACH,
  d.DONATIONS_TO_GOVERNMENT_ATTACH,
  d.DONATIONS_SOCIAL_ATTACH,
  d.SALARY_DEDUCTIONS_ATTACH,
  d.CAR_CUSTOMS_FEES_ATTACH,
  d.RETIREMENT_DEDUCTIONS_ATTACH
FROM FA_COMP_EMP_SAL_TAX m
inner join FA_SYSTEM_PARAMETERS prNAT on m.EST_EMP_NATIONALITY=prNAT.SP_MINOR and prNAT.SP_MAJOR=''NAT''
inner join FA_SYSTEM_PARAMETERS prEmpDoc on m.EST_EMP_IDENTIFIED_TYPE=prEmpDoc.SP_MINOR and prEmpDoc.SP_MAJOR=''DOC''
inner join FA_SYSTEM_PARAMETERS prMar on m.EST_EMP_MARITAL_STATUS=prMar.SP_MINOR and prMar.SP_MAJOR=''MRS''
inner join FA_SYSTEM_PARAMETERS prGen on m.EST_EMP_GENDER=prGen.SP_MINOR and prGen.SP_MAJOR=''GND''
inner join FA_SYSTEM_PARAMETERS prDpt on m.EST_EMP_TAX_DEPARTMENT=prDpt.SP_MINOR and prDpt.SP_MAJOR=''DPT''
inner join FA_Banks bnk on m.EST_EMP_BANK=bnk.BANK_ID
inner join FA_BANK_BRANCH bnkBr on m.EST_EMP_BANK=bnkBr.BANK_ID and m.EST_EMP_BANK_BRANCH=bnkBr.BANK_BRANCH_ID
inner join FA_COMP_EMP_SAL_TAX_DETAILS d on m.EST_ID=d.EMP_ID and d.TAX_YEAR='||pc_Tax_Year||' 
 where m.EST_EMP_NAME like ''%'||pc_Emp_Name||'%'' and m.EST_STATUS=0 and d.DELETED=0 '||pc_Where||' ';

open refcur_SYSTEM_incom_Tax_years for Sql_Statement;
 
 elsif pc_type=1 then
 
 Sql_Statement := 'SELECT 
 d.EMP_ID EMP_ID,
  d.TAX_YEAR,
  m.EST_EMP_TAXNO,
  m.EST_EMP_NAME,
  prGen.SP_A_DESCRIPTION as GENDER,
  prMar.SP_A_DESCRIPTION as MARITAL_STATUS,
  m.EST_EMP_MOBILE,
  DECODE (m.EST_EMP_WORKPLACE_TYPE,0, ''قطاع عام'', 1, ''قطاع خاص'',''غير معروف'') as WorkPlace_Type,
  case when m.EST_EMP_WORKPLACE_TYPE=0 then 
  (Select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS prEmpWType
  where m.EST_EMP_WORKPLACE=prEmpWType.SP_MINOR and prEmpWType.SP_MAJOR=''WOG'' )
  else
  (Select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS prEmpWType
  where m.EST_EMP_WORKPLACE=prEmpWType.SP_MINOR and prEmpWType.SP_MAJOR=''WOS'' )
  end as Emp_WrokPlace, 
  prDpt.SP_A_DESCRIPTION as Tax_Dept,
  d.INCOM_FILE INCOM_FILE
FROM FA_COMP_EMP_SAL_TAX m
inner join FA_SYSTEM_PARAMETERS prNAT on m.EST_EMP_NATIONALITY=prNAT.SP_MINOR and prNAT.SP_MAJOR=''NAT''
inner join FA_SYSTEM_PARAMETERS prEmpDoc on m.EST_EMP_IDENTIFIED_TYPE=prEmpDoc.SP_MINOR and prEmpDoc.SP_MAJOR=''DOC''
inner join FA_SYSTEM_PARAMETERS prMar on m.EST_EMP_MARITAL_STATUS=prMar.SP_MINOR and prMar.SP_MAJOR=''MRS''
inner join FA_SYSTEM_PARAMETERS prGen on m.EST_EMP_GENDER=prGen.SP_MINOR and prGen.SP_MAJOR=''GND''
inner join FA_SYSTEM_PARAMETERS prDpt on m.EST_EMP_TAX_DEPARTMENT=prDpt.SP_MINOR and prDpt.SP_MAJOR=''DPT''
inner join FA_Banks bnk on m.EST_EMP_BANK=bnk.BANK_ID
inner join FA_BANK_BRANCH bnkBr on m.EST_EMP_BANK=bnkBr.BANK_ID and m.EST_EMP_BANK_BRANCH=bnkBr.BANK_BRANCH_ID
inner join FA_COMP_EMP_SAL_TAX_DETAILS d on m.EST_ID=d.EMP_ID  
 where m.EST_STATUS=0 and d.DELETED=0 '||pc_Where;

open refcur_SYSTEM_incom_Tax_years for Sql_Statement;
 
 end if;
 

 end;