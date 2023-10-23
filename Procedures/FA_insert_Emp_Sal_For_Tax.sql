create or replace 
procedure FA_insert_Emp_Sal_For_Tax
     (
     ------Master------------
     pc_emp_id                  in number,
    pc_EST_EMP_NAME             in varchar2,
    pc_EST_EMP_TAXNO            in varchar2,
    pc_EST_EMP_NATIONALITY      in number,
    pc_EST_EMP_IDENTIFIED_TYPE  in number,
    pc_EST_EMP_IDENTIFIED_NO    in varchar2,
    pc_EST_EMP_ADDRESS          in varchar2,
    pc_EST_EMP_MOBILE           in varchar2,
    pc_EST_EMP_EMAIL            in varchar2,
    pc_EST_EMP_WORKPLACE        in number,
    pc_EST_EMP_WORKPLACE_TYPE   in number,
    pc_EST_EMP_MARITAL_STATUS   in number,
    pc_EST_EMP_GENDER           in number,
    pc_EST_EMP_BIRTHDATE        in varchar2,
    pc_EST_EMP_BANK             in number,
    pc_EST_EMP_BANK_BRANCH      in number,
    pc_EST_EMP_IBAN             in varchar2,
    pc_EST_EMP_TAX_DEPARTMENT   in number,
    ---------End Master-----------
    -----------Details------------
    pc_TAX_YEAR                 in number,
    pc_INDIVIDUAL_MERGE         in number,
    pc_WIFE_WORK_STATUS         in number,
    pc_WIFE_NAME                in varchar2,
    pc_WIFE_NATIONALITY_ID      in varchar2,
    pc_WIFE_TAX_ACCOUNT_NO      in varchar2,
    pc_WIFE_AGREE_FILE          in varchar2,
    pc_EMP_ANNUAL_SALARY        in number,
    pc_EMP_ANNUAL_SALARY_ATTACH in varchar2,
    pc_WIFE_ANNUAL_SALARY       in number,
    pc_WIFE_ANNUAL_SALARY_ATTACH in varchar2,
    pc_COUNT_DISABLED_CHILDREN   in number,
    pc_COUNT_DISABLED_ATTACH in varchar2,
    pc_Annual_Emp_expenses         in number,
    pc_Annual_Emp_expenses_Attach  in varchar2,
    pc_Annual_Wife_expenses      in number,
    pc_Annual_Wife_expenses_Attach    in varchar2,
    pc_C_1_LEARNING_EXPENSE            in number,
    pc_C_1_LEARNING_EXPENSE_ATTACH     in varchar2,
    pc_C_2_LEARNING_EXPENSE            in number,
    pc_C_2_LEARNING_EXPENSE_ATTACH     in varchar2,
    pc_C_3_LEARNING_EXPENSE            in number,
    pc_C_3_LEARNING_EXPENSE_ATTACH     in varchar2,
    pc_COUNT_DEPENDENTS                in number,
    pc_COUNT_DEPENDENTS_ATTACH         in varchar2,
    pc_DONATIONS_TO_GOVERNMENT         in number,
    pc_DONATIONS_TO_GOV_ATTACH  in varchar2,
    pc_DONATIONS_SOCIAL                in number,
    pc_DONATIONS_SOCIAL_ATTACH         in varchar2,
    pc_SALARY_DEDUCTIONS               in number,
    pc_SALARY_DEDUCTIONS_ATTACH        in varchar2,
    pc_CAR_CUSTOMS_FEES                in number,
    pc_CAR_CUSTOMS_FEES_ATTACH         in varchar2,
    pc_Total_3307                      in number,
    pc_Total_9027                      in number,
    pc_Total_9028                      in number,
    pc_Total_9029                      in number,
    ------End Details--------------
    Pc_Insert_Dependance  in  Clob,
    pc_USER                in varchar2,
    prm_id                 out number
     )
---------------------------------------------------------------------
--	  BreakPoints,2022
--versions No.	   : 1
--Program name     : FA_insert_Customer_Company
--Date written	   : 30-05-2022
--Program Language : PL/SQL                                                     
--Written by           : Mohammad Aldamsah
--Approved By          : Mohammad Aldamsah
--Platform	   : 
--Location	   : Local server
--Description	   : This procedures inserts new Customer and company info                                          
--Program Inputs   : major , desc,user
--Program outputs  : none
--Return Code	   : flag
--		        0 : successful
--                      1 :
--Tables read	   :
--Tables updated   :   FA_CUSTOMER_COMP                                           
--Called from Module :                                                          
--Module called	   : none                                                       
--modifications	   :           
--                                                 
--   Date       Mod. by      Approved by	Modification description
--   ----       -------      -----------        ------------------------          
------------------------------------------------------------------------------
As
vr_EST_ID  number;
vr_seq_no number;
Plsql_Dependance Varchar2(8000);

prm_idOut  number;

total_993104_toCheck number;
total_993104_to23000JD number;

v_DONATIONS_SOCIAL_25 number;
chk_Total_0_25 number;

v_Total_99130 number;
v2_Total_99130 number;
v_Total_99130Net number ;

vF_Total_99130 number;
vS_Total_99130 number;


Cursor crTax is
SELECT 
SLICE_ID,
SLICE_AMOUNT,
SLICE_PERCANTAGE 
FROM FA_SALARY_TAX_Slice
where SLICE_FROM_YEAR<=pc_TAX_YEAR and ( SLICE_TO_YEAR>=pc_TAX_YEAR or SLICE_TO_YEAR is null)
order by SLICE_ID;

begin

if pc_emp_id=0 then

select nvl(max(EST_ID),0)+1 into vr_EST_ID  from FA_COMP_EMP_SAL_TAX  ;



INSERT
INTO FA_COMP_EMP_SAL_TAX
  (
    EST_ID,
    EST_EMP_NAME,
    EST_EMP_TAXNO,
    EST_EMP_NATIONALITY,
    EST_EMP_IDENTIFIED_TYPE,
    EST_EMP_IDENTIFIED_NO,
    EST_EMP_ADDRESS,
    EST_EMP_MOBILE,
    EST_EMP_EMAIL,
    EST_EMP_WORKPLACE,
    EST_EMP_WORKPLACE_TYPE,
    EST_EMP_MARITAL_STATUS,
    EST_EMP_GENDER,
    EST_EMP_BIRTHDATE,
    EST_EMP_BANK,
    EST_EMP_BANK_BRANCH,
    EST_EMP_IBAN,
    EST_EMP_TAX_DEPARTMENT
  )
  VALUES
  (
    vr_EST_ID,
    pc_EST_EMP_NAME,
    pc_EST_EMP_TAXNO,
    pc_EST_EMP_NATIONALITY,
    pc_EST_EMP_IDENTIFIED_TYPE,
    pc_EST_EMP_IDENTIFIED_NO,
    pc_EST_EMP_ADDRESS,
    pc_EST_EMP_MOBILE,
    pc_EST_EMP_EMAIL,
    pc_EST_EMP_WORKPLACE,
    pc_EST_EMP_WORKPLACE_TYPE,
    pc_EST_EMP_MARITAL_STATUS,
    pc_EST_EMP_GENDER,
    trunc(to_date(pc_EST_EMP_BIRTHDATE,'dd/mm/rrrr')),
    pc_EST_EMP_BANK,
    pc_EST_EMP_BANK_BRANCH,
    pc_EST_EMP_IBAN,
    pc_EST_EMP_TAX_DEPARTMENT
  );

Commit; 

else
vr_EST_ID:=pc_emp_id;


update FA_COMP_EMP_SAL_TAX
set EST_EMP_NAME=pc_EST_EMP_NAME
    , EST_EMP_TAXNO=pc_EST_EMP_TAXNO
    , EST_EMP_NATIONALITY=pc_EST_EMP_NATIONALITY
    , EST_EMP_IDENTIFIED_TYPE=pc_EST_EMP_IDENTIFIED_TYPE
    , EST_EMP_IDENTIFIED_NO=pc_EST_EMP_IDENTIFIED_NO
    , EST_EMP_ADDRESS=pc_EST_EMP_ADDRESS
    , EST_EMP_MOBILE=pc_EST_EMP_MOBILE
    , EST_EMP_EMAIL=pc_EST_EMP_EMAIL
    , EST_EMP_WORKPLACE=pc_EST_EMP_WORKPLACE
    , EST_EMP_WORKPLACE_TYPE=pc_EST_EMP_WORKPLACE_TYPE
    , EST_EMP_MARITAL_STATUS=pc_EST_EMP_MARITAL_STATUS
    , EST_EMP_GENDER=pc_EST_EMP_GENDER
    , EST_EMP_BIRTHDATE=trunc(to_date(pc_EST_EMP_BIRTHDATE,'dd/mm/rrrr'))
    , EST_EMP_BANK=pc_EST_EMP_BANK
    , EST_EMP_BANK_BRANCH=pc_EST_EMP_BANK_BRANCH
    , EST_EMP_IBAN=pc_EST_EMP_IBAN
    , EST_EMP_TAX_DEPARTMENT=pc_EST_EMP_TAX_DEPARTMENT
    where EST_ID=vr_EST_ID;

commit;

DELETE
FROM FA_COMP_DEPENDENTS
WHERE EMP_ID=vr_EST_ID;

commit;


DELETE
FROM FA_COMP_EMP_SAL_TAX_DETAILS
WHERE EMP_ID=vr_EST_ID
AND TAX_YEAR=pc_TAX_YEAR;

commit;

end if;


total_993104_toCheck:=nvl(pc_Total_9027,0)+nvl(pc_Total_9028,0)+nvl(pc_Total_9029,0);

if total_993104_toCheck>=23000 then
 
 total_993104_to23000JD:=23000;
 
 else
 total_993104_to23000JD:=total_993104_toCheck;
 
 end if;
 


chk_Total_0_25:=(((pc_EMP_ANNUAL_SALARY+nvl(pc_WIFE_ANNUAL_SALARY,0))-pc_Total_3307)-(total_993104_to23000JD+nvl(pc_DONATIONS_TO_GOVERNMENT,0)))*0.25;

if pc_DONATIONS_SOCIAL<=chk_Total_0_25 then
v_DONATIONS_SOCIAL_25:=pc_DONATIONS_SOCIAL;
else
v_DONATIONS_SOCIAL_25:=chk_Total_0_25;
end if;

v_Total_99130:=(((pc_EMP_ANNUAL_SALARY+nvl(pc_WIFE_ANNUAL_SALARY,0))-pc_Total_3307)-(total_993104_to23000JD+nvl(pc_DONATIONS_TO_GOVERNMENT,0)))-v_DONATIONS_SOCIAL_25;
v2_Total_99130:=v_Total_99130;
v_Total_99130Net:=0;

--vF_Total_99130 :=0;
vS_Total_99130 :=0;
for r_Tax_Slice in crTax
loop


if v2_Total_99130>0 then

if v2_Total_99130<=r_Tax_Slice.SLICE_AMOUNT then

v_Total_99130Net:=v_Total_99130Net+(v2_Total_99130*r_Tax_Slice.SLICE_PERCANTAGE);

v2_Total_99130:=0;

Exit;

else
v_Total_99130Net:=v_Total_99130Net+(r_Tax_Slice.SLICE_AMOUNT*r_Tax_Slice.SLICE_PERCANTAGE);

v2_Total_99130:=v2_Total_99130-r_Tax_Slice.SLICE_AMOUNT;


end if;

else

Exit;

end if;

end loop;

/*
for r_Tax_Slice in
(
SELECT 
SLICE_ID,
SLICE_AMOUNT,
SLICE_PERCANTAGE 
FROM FA_SALARY_TAX_Slice
where SLICE_FROM_YEAR<=pc_TAX_YEAR and ( SLICE_TO_YEAR>=pc_TAX_YEAR or SLICE_TO_YEAR is null)
order by SLICE_ID
)
loop

if v2_Total_99130>0 then
vF_Total_99130:=v2_Total_99130;

if v2_Total_99130<=r_Tax_Slice.SLICE_AMOUNT then

v_Total_99130Net:=v_Total_99130Net+(v2_Total_99130*r_Tax_Slice.SLICE_PERCANTAGE);

v2_Total_99130:=0;

Exit;

else
v_Total_99130Net:=v_Total_99130Net+(r_Tax_Slice.SLICE_AMOUNT*r_Tax_Slice.SLICE_PERCANTAGE);

v2_Total_99130:=v2_Total_99130-r_Tax_Slice.SLICE_AMOUNT;


end if;

else

Exit;

end if;



end loop;

*/
insert into FA_COMP_EMP_SAL_TAX_DETAILS
(
EMP_ID,
DETAILS_ID,
TAX_YEAR,
INDIVIDUAL_MERGE,
WIFE_WORK_STATUS,
WIFE_NAME,
WIFE_NATIONALITY_ID,
WIFE_TAX_ACCOUNT_NO,
WIFE_AGREE_FILE,
EMP_ANNUAL_SALARY,
EMP_ANNUAL_SALARY_ATTACH,
WIFE_ANNUAL_SALARY,
WIFE_ANNUAL_SALARY_ATTACH,
COUNT_DISABLED_CHILDREN,
COUNT_DISABLED_CHILDREN_ATTACH,
Annual_Emp_expenses,
Annual_Emp_expenses_Attach,
Annual_Wife_expenses,
Annual_Wife_expenses_Attach,
C_1_LEARNING_EXPENSE,
C_1_LEARNING_EXPENSE_ATTACH,
C_2_LEARNING_EXPENSE,
C_2_LEARNING_EXPENSE_ATTACH,
C_3_LEARNING_EXPENSE,
C_3_LEARNING_EXPENSE_ATTACH,
COUNT_DEPENDENTS,
COUNT_DEPENDENTS_ATTACH,
DONATIONS_TO_GOVERNMENT,
DONATIONS_TO_GOVERNMENT_ATTACH,
DONATIONS_SOCIAL,
DONATIONS_SOCIAL_ATTACH,
SALARY_DEDUCTIONS,
SALARY_DEDUCTIONS_ATTACH,
CAR_CUSTOMS_FEES,
CAR_CUSTOMS_FEES_ATTACH,
TOTAL_3303,
Total_3307,
Total_339,
Total_9027,
Total_9028,
Total_9029,
Total_993104,
Total_99310,
total_99110,
total_991201,
total_99130,
total_99510,
SAL_TAX_NEED

)
  VALUES
  (
  vr_EST_ID,
  Emp_SAL_TAX_DETAILS_seq_no.NEXTVAL,
  pc_TAX_YEAR,
  pc_INDIVIDUAL_MERGE,
pc_WIFE_WORK_STATUS,
pc_WIFE_NAME,
pc_WIFE_NATIONALITY_ID,
pc_WIFE_TAX_ACCOUNT_NO,
pc_WIFE_AGREE_FILE,
pc_EMP_ANNUAL_SALARY,
pc_EMP_ANNUAL_SALARY_ATTACH,
pc_WIFE_ANNUAL_SALARY,
pc_WIFE_ANNUAL_SALARY_ATTACH,
pc_COUNT_DISABLED_CHILDREN,
pc_COUNT_DISABLED_ATTACH,
pc_Annual_Emp_expenses,
pc_Annual_Emp_expenses_Attach,
pc_Annual_Wife_expenses,
pc_Annual_Wife_expenses_Attach,
pc_C_1_LEARNING_EXPENSE,
pc_C_1_LEARNING_EXPENSE_ATTACH,
pc_C_2_LEARNING_EXPENSE,
pc_C_2_LEARNING_EXPENSE_ATTACH,
pc_C_3_LEARNING_EXPENSE,
pc_C_3_LEARNING_EXPENSE_ATTACH,
pc_COUNT_DEPENDENTS,
pc_COUNT_DEPENDENTS_ATTACH,
pc_DONATIONS_TO_GOVERNMENT,
pc_DONATIONS_TO_GOV_ATTACH,
pc_DONATIONS_SOCIAL,
pc_DONATIONS_SOCIAL_ATTACH,
pc_SALARY_DEDUCTIONS,
pc_SALARY_DEDUCTIONS_ATTACH,
pc_CAR_CUSTOMS_FEES,
pc_CAR_CUSTOMS_FEES_ATTACH,
pc_EMP_ANNUAL_SALARY+nvl(pc_WIFE_ANNUAL_SALARY,0),
pc_Total_3307,
(pc_EMP_ANNUAL_SALARY+nvl(pc_WIFE_ANNUAL_SALARY,0))-pc_Total_3307,
pc_Total_9027,
pc_Total_9028,
pc_Total_9029,
total_993104_to23000JD,
(total_993104_to23000JD+nvl(pc_DONATIONS_TO_GOVERNMENT,0)),
((pc_EMP_ANNUAL_SALARY+nvl(pc_WIFE_ANNUAL_SALARY,0))-pc_Total_3307)-(total_993104_to23000JD+nvl(pc_DONATIONS_TO_GOVERNMENT,0)),
v_DONATIONS_SOCIAL_25,
v_Total_99130,
v_Total_99130Net,
(v_Total_99130Net-nvl(pc_SALARY_DEDUCTIONS,0)-nvl(pc_CAR_CUSTOMS_FEES,0))
  );

Commit;


Plsql_Dependance:=replace(Pc_Insert_Dependance,'@@@@@',vr_EST_ID); 
    if Plsql_Dependance is not NULL then
     Execute Immediate Plsql_Dependance;
   
Commit;

end if;


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
    vr_EST_ID,
    sysdate,
    pc_USER,
    'FA_COMP_EMP_SAL_TAX'
  );



commit;  

prm_id:=vr_EST_ID;



     

end;