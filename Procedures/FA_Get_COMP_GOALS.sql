create or replace 
procedure FA_Get_COMP_GOALS(
  refcur_SYSTEM_COMP_GOALS OUT sys_refcursor,
  pc_CompId     in number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_COMP_GOALS
--Date written	   : 10-06-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get Goals of Comp
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
 
 Sql_Statement := 'SELECT CG_ID, CG_GOAL_NAME
FROM FA_COMP_GOALS 
where CG_DELETED=0 and CC_ID='||pc_CompId;

 open refcur_SYSTEM_COMP_GOALS for Sql_Statement;
 

 end;