create or replace 
procedure FA_Get_COMP_OWNERS(
  refcur_SYSTEM_COMP_Owners OUT sys_refcursor,
  pc_CompId     in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_COMP_OWNERS
--Date written	   : 10-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get Owners of Comp
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
 
 Sql_Statement := 'SELECT CO_ID,
  CO_OWNER_NAME,
  CO_OWNER_NATIO,
  CO_OWNER_DOC_TYPE,
  CO_OWNER_COC_TYPE_NO,
  CO_ONWER_MOBILE,
  CO_OWNER_SHARE_TYPE,
  CO_OWNER_SHARE_VALUE,
  ''%''||CO_OWNER_SHARE_PERSANTAGE CO_OWNER_SHARE_PERSANTAGE,
  CO_OWNER_FILE
FROM FA_COMP_OWNERS
where CO_DELETED=0 and CC_ID='||pc_CompId;

 open refcur_SYSTEM_COMP_Owners for Sql_Statement;
 

 end;