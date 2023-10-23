 
drop table FA_OWER_EMPLOYEE cascade constraints;

   CREATE TABLE FA_OWER_EMPLOYEE 
   (	OE_ID NUMBER NOT NULL ENABLE, 
	OE_EMP_NAME VARCHAR2(200 ) NOT NULL ENABLE, 
	OE_EMP_MARITAL_STATUS NUMBER NOT NULL ENABLE, 
	OE_EMP_GENDER NUMBER NOT NULL ENABLE, 
	OE_EMP_NATIONALITY NUMBER NOT NULL ENABLE, 
	OE_EMP_BAITHDATE DATE NOT NULL ENABLE, 
	OE_EMP_DOCTYPE NUMBER NOT NULL ENABLE, 
	OE_EMP_DOCTYPENO VARCHAR2(50 ) NOT NULL ENABLE, 
	OE_EMP_EDUCATION NUMBER NOT NULL ENABLE, 
	OE_EMP_SPICIALIST NUMBER NOT NULL ENABLE, 
	OE_EMP_JOINDATE DATE NOT NULL ENABLE, 
	OE_EMP_JOBTITLE NUMBER NOT NULL ENABLE, 
	OE_EMP_SOCIALGOVNO VARCHAR2(200 ) NOT NULL ENABLE, 
	OE_EMP_ADDRESS VARCHAR2(200 ) NOT NULL ENABLE, 
	OE_EMP_MOBILE VARCHAR2(20 ) NOT NULL ENABLE, 
	OE_EMP_EMAIL VARCHAR2(50 ) NOT NULL ENABLE, 
	OE_EMP_SALARY NUMBER NOT NULL ENABLE, 
	OE_EMP_FILE VARCHAR2(200 ) NOT NULL ENABLE, 
	OE_EMP_PHOTO VARCHAR2(200 ) NOT NULL ENABLE, 
	OE_STATUS NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_OWER_EMPLOYEE_PK PRIMARY KEY (OE_ID)
   );
   COMMENT ON COLUMN FA_OWER_EMPLOYEE.OE_STATUS IS '0 IS WORKE ,1 IS SUSPEND ,2 IS TERMINATED';


drop public synonym FA_OWER_EMPLOYEE;

create public synonym FA_OWER_EMPLOYEE for FA_OWER_EMPLOYEE;