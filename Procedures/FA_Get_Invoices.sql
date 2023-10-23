create or replace 
procedure FA_Get_Invoices(
  refcur_Invoices OUT sys_refcursor,
  pc_CustomerID in Number,
  pc_where       in varchar2,
  pc_InvoiceID in Number,
  pc_type in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_Invoices
--Date written	   : 11-11-2022
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

 Sql_Statement := 'SELECT  distinct iv.INV_ID,
  iv.INV_NUMBER,
  iv.INV_CUSTOMER_ID,
  to_char(iv.INV_DATE,''dd/mm/yyyy'') INV_DATE,
  iv.INV_SUPPLIER_ID,
  ca.ACCOUNT_NAME SUPPLIER_Name,
  iv.INV_TYPE,
  prPST.SP_A_DESCRIPTION INV_TYPE_Desc,
  case when ivd.INV_GUIDANCE_TYPE=4 then
  case when (select count(rsm.AMOUNT) from RETURN_SALE_AMOUNT rsm where rsm.CUSTOMER_ID=iv.INV_CUSTOMER_ID and rsm.INV_ID=iv.INV_ID)=0 then
  iv.INV_AMOUNT
  else
  (iv.INV_AMOUNT-(select NVL(rsm.AMOUNT,0) from RETURN_SALE_AMOUNT rsm where rsm.CUSTOMER_ID=iv.INV_CUSTOMER_ID and rsm.INV_ID=iv.INV_ID))
  end
  else
  case when (select count(rsm.AMOUNT) from RETURN_PROCUREMENT_AMOUNT rsm where rsm.CUSTOMER_ID=iv.INV_CUSTOMER_ID and rsm.INV_ID=iv.INV_ID)=0 then
  iv.INV_AMOUNT
  else
  (iv.INV_AMOUNT-(select NVL(rsm.AMOUNT,0) from RETURN_PROCUREMENT_AMOUNT rsm where rsm.CUSTOMER_ID=iv.INV_CUSTOMER_ID and rsm.INV_ID=iv.INV_ID))
  end
  end INV_AMOUNT,
  iv.INV_DESC,
  iv.INV_ATTACHMENT,
  iv.INV_TAXABLE_STATUS,
  prIVS.SP_A_DESCRIPTION  INV_TAXABLE_STATUS_Desc,
 ivd.INV_GUIDANCE_TYPE,
  decode(ivd.INV_GUIDANCE_TYPE,1,''Assest'',2,''Expense'',3,''Procurement'',4,''Sales'',''UN'') GUIDANCE_Desc,
  ivd.INV_ACCOUNT_NUMBER Account_Number,
  Fn_get_Account_Name(ivd.INV_ACCOUNT_NUMBER,iv.INV_CUSTOMER_ID) Account_Name,
  ivd.INV_TAX_ACCOUNT_NUMBER TAX_ACCOUNT_NUMBER
FROM FA_INVOICE iv
inner join FA_SYSTEM_PARAMETERS prPST on iv.INV_TYPE=prPST.SP_MINOR and prPST.SP_MAJOR=''PST''
inner join FA_CUSTOMER_CHART_OF_ACCOUNT ca on iv.INV_SUPPLIER_ID=ca.ACCOUNT_NUMBER and ca.CUSTOMER_ID=iv.INV_CUSTOMER_ID
inner join FA_SYSTEM_PARAMETERS prIVS on iv.INV_TAXABLE_STATUS=prIVS.SP_MINOR and prIVS.SP_MAJOR=''IVS''
inner join FA_INVOICE_DETAILS ivd on iv.INV_ID=ivd.INV_ID and iv.INV_CUSTOMER_ID=ivd.INV_CUSTOMER_ID
where ivd.INV_GUIDANCE_TYPE not in (1,2) and iv.INV_TYPE!=4 
 '||pc_where||'
order by 4 ';

open refcur_Invoices for Sql_Statement;

elsif pc_type=1 then

 Sql_Statement := 'SELECT 
  ivd.INV_DETAIL_ID INV_DETAIL_ID,
  substr(ivd.INV_DETAIL_DESC,1,instr(ivd.INV_DETAIL_DESC,''عدد'')-2) Item_Desc,
  (ivd.INV_DETAIL_AMOUNT/to_number(rtrim(ltrim(trim(replace(substr(ivd.INV_DETAIL_DESC,to_number(instr(ivd.INV_DETAIL_DESC,''عدد'')+3)),'' '','''')))))) Unit_Price ,
  to_number(rtrim(ltrim(trim(replace(substr(ivd.INV_DETAIL_DESC,to_number(instr(ivd.INV_DETAIL_DESC,''عدد'')+3)),'' '',''''))))) Item_Count,
  ivd.INV_DETAIL_TAX_PERCENTAGE TAX_PERCENTAGE,
  ivd.INV_DETAIL_AMOUNT Total_Without_TAX,
  ivd.INV_DETAIL_TAX_AMOUNT Total_TAX_AMOUNT,
  ivd.INV_DETAIL_AMOUNT_WITH_TAX Total_AMOUNT_WITH_TAX
FROM FA_INVOICE_DETAILS ivd
where ivd.INV_CUSTOMER_ID='||pc_CustomerID||' and ivd.INV_ID='||pc_InvoiceID||' 
and ivd.INV_DETAIL_ID not in(select INV_DETAILS_ID from FA_SALES_RETURNS where CUSTOMER_ID='||pc_CustomerID||' and INV_ID='||pc_InvoiceID||')
order by ivd.inv_detail_id';

 open refcur_Invoices for Sql_Statement;
 
 
 elsif pc_type=2 then

 Sql_Statement := 'SELECT 
  ivd.INV_DETAIL_ID INV_DETAIL_ID,
  substr(ivd.INV_DETAIL_DESC,1,instr(ivd.INV_DETAIL_DESC,''عدد'')-2) Item_Desc,
  (ivd.INV_DETAIL_AMOUNT/to_number(rtrim(ltrim(trim(replace(substr(ivd.INV_DETAIL_DESC,to_number(instr(ivd.INV_DETAIL_DESC,''عدد'')+3)),'' '','''')))))) Unit_Price ,
  to_number(rtrim(ltrim(trim(replace(substr(ivd.INV_DETAIL_DESC,to_number(instr(ivd.INV_DETAIL_DESC,''عدد'')+3)),'' '',''''))))) Item_Count,
  ivd.INV_DETAIL_TAX_PERCENTAGE TAX_PERCENTAGE,
  ivd.INV_DETAIL_AMOUNT Total_Without_TAX,
  ivd.INV_DETAIL_TAX_AMOUNT Total_TAX_AMOUNT,
  ivd.INV_DETAIL_AMOUNT_WITH_TAX Total_AMOUNT_WITH_TAX
FROM FA_INVOICE_DETAILS ivd
where ivd.INV_CUSTOMER_ID='||pc_CustomerID||' and ivd.INV_ID='||pc_InvoiceID||' 
and ivd.INV_DETAIL_ID not in(select INV_DETAILS_ID from FA_Procurement_Returns where CUSTOMER_ID='||pc_CustomerID||' and INV_ID='||pc_InvoiceID||')
order by ivd.inv_detail_id';

 open refcur_Invoices for Sql_Statement;
 
 end if;
 

 end;