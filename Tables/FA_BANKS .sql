 
drop table FA_BANKS cascade constraints;

CREATE TABLE FA_BANKS 
   (	BANK_ID NUMBER NOT NULL ENABLE, 
	BANK_NAME VARCHAR2(500) NOT NULL ENABLE, 
	CO_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_BANKS_PK PRIMARY KEY (BANK_ID), 
	 CONSTRAINT FA_BANKS_UK UNIQUE (BANK_NAME)
   ) ;

   COMMENT ON COLUMN FA_BANKS.CO_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';

drop public synonym FA_BANKS;

create public synonym FA_BANKS for FA_BANKS;