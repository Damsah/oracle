 
drop table FA_DEPRECIATION cascade constraints;

CREATE TABLE FA_DEPRECIATION 
   (	CUSTOMER_ID NUMBER NOT NULL ENABLE, 
	ASSEST_ACOUNT_NUMBER VARCHAR2(1000 ) NOT NULL ENABLE,
        ASSEST_ID NUMBER NOT NULL ENABLE,
	ASSEST_NAME VARCHAR2(1000 ) NOT NULL ENABLE, 
	ASSEST_START_DATE DATE NOT NULL ENABLE, 
	DP_ACCOUNT_NUMBER VARCHAR2(2000 ) NOT NULL ENABLE, 
	DP_PERSANTAGE NUMBER NOT NULL ENABLE, 
	ASSEST_TOTAL_COST NUMBER NOT NULL ENABLE, 
	DP_DAILY_DATE DATE NOT NULL ENABLE, 
	DP_AMOUNT_DAILY NUMBER, 
	DP_AMOUNT_DAILY_COMP NUMBER, 
	DAFTAR_VALUE_DAILY NUMBER, 
	DP_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_DEPRECIATION_PK PRIMARY KEY (CUSTOMER_ID, ASSEST_ACOUNT_NUMBER, ASSEST_NAME, DP_DAILY_DATE,ASSEST_ID)
   );

   COMMENT ON COLUMN FA_DEPRECIATION.DP_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';
   
drop public synonym FA_DEPRECIATION;

create public synonym FA_DEPRECIATION for FA_DEPRECIATION;