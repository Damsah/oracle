create or replace 
procedure FA_Insert_Ower_Employee
     (
    pc_Emp_NAME                in varchar2,
    pc_Emp_Marital_Status      in number,
    pc_Emp_Gender              in number,
    pc_Emp_Nationality         in number,
    pc_EMP_BAITHDATE           in varchar2,
    pc_EMP_DOCTYPE             in number,
    pc_EMP_DOCTYPENO           in varchar2,
    pc_Emp_EDUCATION           in number,
    pc_Emp_SPICIALIST          in number,
    pc_EMP_JOINDATE            in varchar2,
    pc_Emp_JOBTITLE            in number,
    pc_EMP_SocialGovNo         in varchar2,
    pc_EMP_ADDRESS             in varchar2,
    pc_EMP_MOBILE              in varchar2,
    pc_EMP_EMAIL               in varchar2,
    pc_Emp_SALARY              in number,
    pc_EMP_FILE                in varchar2,
    pc_EMP_PHOTO               in varchar2,
    pc_USER                in varchar2,
    prm_id                     out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_Insert_Ower_Employee
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Employee info                                          
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_Ower_Employee                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As
vr_EmployeeID    varchar2(20);
vr_seq_no number;
vr_SU_USER_ID number;
begin


 select nvl(max(OE_ID),0)+1 into vr_EmployeeID  from FA_Ower_Employee  ;

INSERT
INTO FA_Ower_Employee
  (
OE_ID,
OE_EMP_NAME,
OE_EMP_MARITAL_STATUS,
OE_EMP_GENDER,
OE_EMP_NATIONALITY,
OE_EMP_BAITHDATE,
OE_EMP_DOCTYPE,
OE_EMP_DOCTYPENO,
OE_EMP_EDUCATION,
OE_EMP_SPICIALIST,
OE_EMP_JOINDATE,
OE_EMP_JOBTITLE,
OE_EMP_SOCIALGOVNO,
OE_EMP_ADDRESS,
OE_EMP_MOBILE,
OE_EMP_EMAIL,
OE_EMP_SALARY,
OE_EMP_FILE,
OE_EMP_PHOTO,
OE_STATUS
  )
  VALUES
  (
   vr_EmployeeID,
  pc_Emp_NAME,
    pc_Emp_Marital_Status,
    pc_Emp_Gender,
    pc_Emp_Nationality,
     to_date(pc_EMP_BAITHDATE,'dd/mm/yyyy'),
    pc_EMP_DOCTYPE,
    pc_EMP_DOCTYPENO,
    pc_Emp_EDUCATION ,
    pc_Emp_SPICIALIST,
    to_date(pc_EMP_JOINDATE,'dd/mm/yyyy'),
    pc_Emp_JOBTITLE,
    pc_EMP_SocialGovNo,
    pc_EMP_ADDRESS,
    pc_EMP_MOBILE,
    pc_EMP_EMAIL,
    pc_Emp_SALARY,
    pc_EMP_FILE,
    pc_EMP_PHOTO,
    0
  );
Commit; 

 select nvl(max(SU_USER_ID),0)+1 into vr_SU_USER_ID from FA_SYSTEM_USERS  ;

insert into FA_SYSTEM_USERS
(
SU_USER_ID,
SU_A_NAME,
SU_STATUS,
SU_USER,
SU_USER_PASSWORD,
EMP_ID
)
values
(
vr_SU_USER_ID,
pc_Emp_NAME,
'a',
substr(pc_EMP_EMAIL,1,to_number(instr(pc_EMP_EMAIL,'@'))-1),
'123',
vr_EmployeeID
);
commit;

select nvl(max(AT_SEQ_NO),0)+1 into vr_seq_no from FA_AUDIT_TRAILS;

 INSERT INTO FA_AUDIT_TRAILS
  (
    AT_SEQ_NO,
    AT_TRXN_TYPE,
    AT_NEW_DATA,
    ENT_DATE,
    AT_USER,
    TABLE_NAME
  )
  VALUES
  (
    vr_seq_no,
    'New Insert',
    vr_EmployeeID,
    sysdate,
    pc_USER,
    'FA_Ower_Employee'
  );



commit;  

prm_id:=vr_EmployeeID;


end;