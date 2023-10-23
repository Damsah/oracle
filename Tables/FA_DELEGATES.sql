 
drop table FA_DELEGATES cascade constraints;

CREATE TABLE FA_DELEGATES 
   (	CUSTOMER_ID NUMBER NOT NULL ENABLE, 
	DELEGATE_ID NUMBER NOT NULL ENABLE, 
	DELEGATE_NAME VARCHAR2(500 ) NOT NULL ENABLE, 
	DELEGATE_DESC VARCHAR2(500 ) NOT NULL ENABLE, 
	DELETED NUMBER DEFAULT 0 NOT NULL ENABLE
   );

   COMMENT ON COLUMN FA_DELEGATES.DELETED IS '0 IS not Deleted ,1 IS Deleted ';
   
drop public synonym FA_DELEGATES;

create public synonym FA_DELEGATES for FA_DELEGATES;