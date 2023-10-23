create or replace 
procedure FA_Get_Customer_Asstes(
  refcur_SYSTEM_Customer_Asstes OUT sys_refcursor,
  pc_Where in varchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Customer_Asstes
--Date written	   : 3-07-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data tabs for customer asstes
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
 
 Sql_Statement := 'SELECT CA_ASSEST_ACCOUNT_NUMBER,CA_ID AssestID,
  Fn_get_Account_Name(CA_ASSEST_ACCOUNT_NUMBER,CA_CUSTOMER_ID) Assest_Pairent,
  CA_ASSEST_NAME Assest_Name,
  CA_ASSEST_COST_WITH_TAX Total_Cost,
   CA_TAX_PERSANTAGE Tax_Persantage,
   decode(CA_TAXABLE,1,''ضريبي'',2,''غير ضريبي'',''-'') Taxable_Status,
   decode(CA_ACTIVE,1,''نشط'',2,''موقوف'',''-'') Assest_Status,
  case when length(CA_ASSEST_WORKING_DATE)> 0 then
  to_char(to_date(CA_ASSEST_WORKING_DATE,''dd/mm/rrrr''),''dd/mm/yyyy'') 
  else
  ''-----''
  end ASSEST_WORKING_DATE,
  CA_INVOICE_NUMBER INVOICE_NUMBER,
  CA_INVOICE_DATE INVOICE_DATE,
  decode(CA_ROCURMENT_TYPE,1,''نقدا'',2,'' بنك'',3,'' أجل'') ROCURMENT_TYPE,
   Fn_get_Account_Name(CA_SUPPLIER_NUMBER,CA_CUSTOMER_ID) Supplier_Name
FROM FA_CUSTOMER_ASSESTS 
where  1=1   
     '||pc_Where||' ';  
 open refcur_SYSTEM_Customer_Asstes for Sql_Statement;
 
end if;

 end;