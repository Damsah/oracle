create or replace 
procedure FA_Get_PROCUREMENTS(
  refcur_SYSTEM_PROCUREMENTS OUT sys_refcursor,
  pc_Where Varchar2,
  pc_type number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_PROCUREMENTS
--Date written	   : 02-10-2022
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

 Sql_Statement := 'SELECT pr.CUSTOMER_ID,
  pr.INV_ID,
  inv.INV_NUMBER,
  to_char(inv.INV_DATE,''dd/mm/yyyy'') invoice_date,
  inv.INV_TYPE Pay_Type_code,
  prPST.SP_A_DESCRIPTION Pay_Type_Desc,
  inv.INV_TAXABLE_STATUS Tax_Status_Code,
  prIVS.SP_A_DESCRIPTION Tax_Status_Desc,
  pr.INV_SUPPLIER_ID,
  pr.INV_AMOUNT,
  pr.INV_DESC,
  inv.INV_ATTACHMENT,
  pr.S_STATUS Status_Code,
  decode(pr.S_STATUS,1,''لم يتم إستلام البضاعة'',2,''تم إستلام البضاعة'') Status_Desc
FROM FA_PROCUREMENTS pr 
inner join FA_INVOICE inv on pr.INV_ID=inv.INV_ID
inner join FA_SYSTEM_PARAMETERS prPST on inv.INV_TYPE=prPST.SP_MINOR and prPST.SP_MAJOR=''PST''
inner join FA_SYSTEM_PARAMETERS prIVS on inv.INV_TAXABLE_STATUS=prIVS.SP_MINOR and prIVS.SP_MAJOR=''IVS''
where 1=1 '||pc_Where;

open refcur_SYSTEM_PROCUREMENTS for Sql_Statement;
 
 end if;
 

 end;