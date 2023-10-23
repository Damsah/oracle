 
drop table FA_COMP_OWNERS cascade constraints;

   CREATE TABLE FA_COMP_OWNERS 
   (	CO_ID NUMBER NOT NULL ENABLE, 
	CC_ID NUMBER NOT NULL ENABLE, 
	CO_OWNER_NAME VARCHAR2(500 ) NOT NULL ENABLE, 
	CO_OWNER_NATIO VARCHAR2(100 ) NOT NULL ENABLE, 
	CO_OWNER_DOC_TYPE VARCHAR2(50 ) NOT NULL ENABLE, 
	CO_OWNER_COC_TYPE_NO VARCHAR2(20 ) NOT NULL ENABLE, 
	CO_ONWER_MOBILE VARCHAR2(20 ) NOT NULL ENABLE, 
	CO_OWNER_SHARE_TYPE VARCHAR2(100 ) NOT NULL ENABLE, 
	CO_OWNER_SHARE_VALUE NUMBER NOT NULL ENABLE, 
	CO_OWNER_SHARE_PERSANTAGE VARCHAR2(20 ) NOT NULL ENABLE, 
	CO_OWNER_FILE VARCHAR2(500 ), 
	CO_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_COMP_OWNERS_PK PRIMARY KEY (CO_ID, CC_ID)
   ) ;

   COMMENT ON COLUMN FA_COMP_OWNERS.CO_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';


drop public synonym FA_COMP_OWNERS;

create public synonym FA_COMP_OWNERS for FA_COMP_OWNERS;