 
drop table FA_COMP_EMP_SAL_TAX cascade constraints;

    CREATE TABLE FA_COMP_EMP_SAL_TAX 
   (	EST_ID NUMBER NOT NULL ENABLE, 
	EST_EMP_NAME VARCHAR2(500 ) NOT NULL ENABLE, 
	EST_EMP_TAXNO VARCHAR2(100 ) NOT NULL ENABLE, 
	EST_EMP_NATIONALITY NUMBER NOT NULL ENABLE, 
	EST_EMP_IDENTIFIED_TYPE NUMBER NOT NULL ENABLE, 
	EST_EMP_IDENTIFIED_NO VARCHAR2(20 ) NOT NULL ENABLE, 
	EST_EMP_ADDRESS VARCHAR2(500 ), 
	EST_EMP_MOBILE VARCHAR2(20 ), 
	EST_EMP_EMAIL VARCHAR2(500 ), 
	EST_EMP_WORKPLACE NUMBER NOT NULL ENABLE, 
	EST_EMP_WORKPLACE_TYPE NUMBER NOT NULL ENABLE, 
	EST_EMP_MARITAL_STATUS NUMBER NOT NULL ENABLE, 
	EST_EMP_GENDER NUMBER NOT NULL ENABLE, 
	EST_EMP_BIRTHDATE DATE, 
	EST_EMP_BANK NUMBER, 
	EST_EMP_BANK_BRANCH NUMBER, 
	EST_EMP_IBAN VARCHAR2(100 ), 
	EST_EMP_TAX_DEPARTMENT NUMBER, 
	EST_STATUS NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_COMP_EMP_SAL_TAX_PK PRIMARY KEY (EST_ID)
   );

   COMMENT ON COLUMN FA_COMP_EMP_SAL_TAX.EST_STATUS IS '0 IS Active , 1 IS not Active, 2 is Deleted';


drop public synonym FA_COMP_EMP_SAL_TAX;

create public synonym FA_COMP_EMP_SAL_TAX for FA_COMP_EMP_SAL_TAX;