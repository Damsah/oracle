create or replace 
procedure FA_Get_SYSTEM_SubTabMenu(
  refcur_SYSTEM_SubTabsMenu OUT sys_refcursor,
  pc_user in nvarchar2
)
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : FA_Get_SYSTEM_SubTabMenu
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   : This procedures get data sub tabs and Menu for user
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
 

 
 Sql_Statement :=  'select sg.SG_GROUP_TITLE,subg.SSG_NAME btnName,subg.SSG_IMAGE btnImage,sf.SF_FORM_NAME FormName,sf.SF_FORM_AR_NAME FormTitle, 
                         sf.SF_FORM_ICON FormIcon ,subg.SSG_TITLE btnTitle 
                          from FA_SYSTEM_USER_PRIVILEGE priv 
                          inner join fa_system_users us on priv.SU_ID=us.SU_USER_ID 
                          inner join fa_system_form_group sfg on priv.SFG_ID=sfg.SFG_SUBGFORM_ID 
                          inner join fa_system_groups sg on sfg.SFG_GROUP_ID=sg.SG_ID 
                          inner join fa_system_subg_form subgf on sfg.SFG_SUBGFORM_ID=subgf.SSGF_ID 
                          inner join FA_SYSTEM_SUB_GROUP subg on subgf.SSGF_SUB_G_ID=subg.SSG_ID 
                          inner join fa_system_forms sf on subgf.SSGF_FORM_ID=sf.SF_ID 
                          where priv.SUP_DELETED=0 and us.su_status=''a'' and sfg.SFG_DELETED=0 
                          and sg.SG_GROUP_DELETED=0 
                          and subgf.SSGF_DELETED=0 and subg.SSG_DELETED=0 and sf.SF_DELETED=0 
                          and upper(us.SU_USER)=upper('''||pc_user||''') 
                          order by SF.SF_ID ';
 open refcur_SYSTEM_SubTabsMenu for Sql_Statement;
 

 end;