create or replace 
procedure FA_chk_SYSTEM_user(
  pc_user in nvarchar2,
  prim out number
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_chk_SYSTEM_user
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures to ckeck about user
--                                                            
--Program Inputs   : refer to the parameter list.
--Program outputs  : get data
--Return Code	   : flag
--		        1 : successful
--                      0 : not pass
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
 chk number;
 
 begin
 
 
SELECT   count(*) into chk
FROM FA_SYSTEM_USER_PRIVILEGE prv
inner join fa_system_users us on prv.SU_ID=us.SU_USER_ID
inner join fa_system_form_group sfg on prv.SFG_ID=sfg.SFG_ID
inner join FA_SYSTEM_GROUPS sg on sfg.SFG_GROUP_ID=sg.SG_ID
where upper(us.SU_USER)=upper(''||pc_user||'') and prv.SUP_DELETED=0 and sfg.SFG_DELETED=0 and sg.SG_GROUP_DELETED=0;
 
 prim:=chk;

 end;