create or replace 
procedure FA_Get_Customers(
  refcur_SYSTEM_Customers OUT sys_refcursor,
  pc_Where in varchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Customers
--Date written	   : 5-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs for user
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
 Ch_Delegate number;
 vCustomerID number;
 begin
 
 if pc_Where!=' ' then
 
 select instr(pc_Where,'FA_DELEGATES') into Ch_Delegate
from dual;

if Ch_Delegate=0 then

 Sql_Statement := 'SELECT CC_ID,
  CC_CUSTOMER_NAME, 
  (select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS where SP_MAJOR=''NAT'' and SP_MINOR=CC_CUSTOMER_NATIO) as  Nationality,
  (select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS where SP_MAJOR=''DOC'' and SP_MINOR=CC_CUSTOMER_DOCTYPE) as CC_CUSTOMER_DOCTYPE_mane,
  CC_CUSTOMER_DOCTYPENO,
  CC_CUSTOMER_FILE,
  CC_CUSTOMER_MOBILE,
  (select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS where SP_MAJOR=''COT'' and SP_MINOR=CC_COMP_TYPE) as CC_COMP_TYPE_mane,
  (select SP_A_DESCRIPTION from FA_SYSTEM_PARAMETERS where SP_MAJOR=decode(CC_COMP_TYPE,1,''co'',''fm'') and SP_MINOR=CC_COMP_SUBTYPE) as CC_COMP_SUBTYPE_mane,
  CC_COMP_NAME,
  to_char(CC_COMP_ESTABLISH_DATE,''dd/mm/yyyy'') CC_COMP_ESTABLISH_DATE ,
  CC_COMP_COMER_NO,
  CC_COM_TAX_NO,
  CC_COMP_NATIO_ID,
  CC_COMP_MONEY_CAPITAL,
  CC_COMP_ADDRESS,
  CC_COMP_PHONE,
  CC_COMP_EMAIL,
  CC_COMP_SPECIALIZATION,
  SALES_TAXABLE,
  EHLAK_STATUS,
  ACTIVITES_STATUS
FROM FA_CUSTOMER_COMP 
where  CC_DELETED=0   
    '||pc_Where||' ';  
    
 open refcur_SYSTEM_Customers for Sql_Statement;
 
 else
 
 select to_number(replace(pc_Where,'FA_DELEGATES','')) into vCustomerID from dual;
 
  Sql_Statement :='SELECT DELEGATE_NAME||'' بصفته ''||DELEGATE_DESC as Represent
FROM FA_DELEGATES
where CUSTOMER_ID='||vCustomerID||' and DELETED=0';

open refcur_SYSTEM_Customers for Sql_Statement;

 end if;
 
end if;

 end;