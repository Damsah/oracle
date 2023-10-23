create or replace 
Function Fn_get_Account_Number
    ( 
     pc_AccountName 	in Varchar2,
     pc_CUSTOMER_ID     in number
     ) 

Return number
---------------------------------------------------------------------
--	  BreakPoints, 2022
--versions No.	   : 1
--Program name     : Fn_get_Account_Number
--Date written	   : 02/07/2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Al Damsah
--Approved By          : Mohammad Al Damsah
--Platform	   : RISC
--Location	   : Local server
--Description	   :                                        
--Program Inputs   : 
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :                                              
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
is
    
      VrAccountNumber  number;

    begin

     
SELECT
  ACCOUNT_NUMBER into VrAccountNumber
FROM FA_CUSTOMER_CHART_OF_ACCOUNT 
where CUSTOMER_ID=pc_CUSTOMER_ID and ACCOUNT_NAME=pc_AccountName;

      return VrAccountNumber ;

end Fn_get_Account_Number;