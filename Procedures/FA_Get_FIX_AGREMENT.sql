create or replace 
procedure FA_Get_FIX_AGREMENT(
  refcur_SYSTEM_AGREMENT OUT sys_refcursor
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_FIX_AGREMENT
--Date written	   : 01-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data from FA_FIX_AGREMENT
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
 
 Sql_Statement := 'SELECT FXG_ID,
  FXG_COMP_NAME,
  FXG_COMP_LOGO,
  FXG_COMP_ADDRESS,
  FXG_REPRENTER_NAME,
  FXG_COMP_DESC,
  FXG_ITEM1,
  FXG_ITEM2,
  FXG_ITEM3,
  FXG_ITEM4,
  FXG_ITEM5,
  FXG_ITEM6,
  FXG_ITEM7,
  FXG_ITEM8,
  FXG_ITEM9,
  FXG_ITEM10,
  FXG_ITEM11,
  FXG_ITEM12,
  FXG_ITEM13,
  FXG_ITEM14,
  FXG_ITEM15,
  FXG_FOOTER
FROM FA_FIX_AGREMENT 
where FXG_DELETED=0';

 open refcur_SYSTEM_AGREMENT for Sql_Statement;
 

 end;