create or replace 
procedure FA_Update_emp_incom_file
     (
       pc_Emp_ID                    in number,
       pc_Year                      in number,
       pc_File_name                 in varchar2,
       prm_id                       out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Depreciation
--Date written	   : 28-08-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures Update file for incoming Tax Emp                                      
--Program Inputs   : 
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_COMP_EMP_SAL_TAX_DETAILS                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As


 
begin

if pc_Year>0 then
update FA_COMP_EMP_SAL_TAX_DETAILS
set INCOM_FILE=pc_File_name
where EMP_ID=pc_Emp_ID and TAX_YEAR=pc_Year;


commit;

else

if pc_Year=-500 then

update FA_COMPAGREMENT
set VOUCHER_FILE=pc_File_name
where AG_ID=pc_Emp_ID;

commit;

else

UPDATE FA_COMPAGREMENT
SET CONTRACT_FILE=pc_File_name
WHERE AG_ID=pc_Emp_ID
AND AG_DELETED=0;

commit;

end if;

end if;
         
 
prm_id:=1;


end;