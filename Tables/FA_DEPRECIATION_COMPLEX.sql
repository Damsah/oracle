 
drop table FA_DEPRECIATION_COMPLEX cascade constraints;

CREATE TABLE FA_DEPRECIATION_COMPLEX 
   (	CUSTOMER_ID NUMBER NOT NULL ENABLE, 
	ASSEST_ACOUNT_NUMBER VARCHAR2(1000 ) NOT NULL ENABLE, 
	ASSEST_NAME VARCHAR2(1000 ) NOT NULL ENABLE,
        ASSEST_ID NUMBER NOT NULL ENABLE,
	ASSEST_START_DATE DATE NOT NULL ENABLE, 
	DP_COMPLEX_ACCOUNT_NUMBER VARCHAR2(2000 ) NOT NULL ENABLE, 
	DP_PERSANTAGE NUMBER NOT NULL ENABLE, 
	ASSEST_TOTAL_COST NUMBER NOT NULL ENABLE, 
	DP_COMPLEX_YEARLY_DATE VARCHAR2(100 ) NOT NULL ENABLE, 
	DP_COMPLEX_AMOUNT_YEARLY NUMBER, 
	DP_COMPLEX_AMOUNT NUMBER, 
	DAFTAR_VALUE_YEARLY NUMBER, 
	DP_COMPLEX_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_DEPRECIATION_COMPLEX_PK PRIMARY KEY (CUSTOMER_ID, ASSEST_ACOUNT_NUMBER, ASSEST_NAME, DP_COMPLEX_YEARLY_DATE,ASSEST_ID)
   );

   COMMENT ON COLUMN FA_DEPRECIATION_COMPLEX.DP_COMPLEX_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';
   
drop public synonym FA_DEPRECIATION_COMPLEX;

create public synonym FA_DEPRECIATION_COMPLEX for FA_DEPRECIATION_COMPLEX;