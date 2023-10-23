 
drop table FA_SEND_SMS cascade constraints;

  CREATE TABLE FA_SEND_SMS 
   (	SMS_ID NUMBER NOT NULL ENABLE, 
	SMS_TEXT VARCHAR2(4000 ) NOT NULL ENABLE, 
	SMS_MOBILENO VARCHAR2(100 ) NOT NULL ENABLE, 
	SMS_STATUS NUMBER DEFAULT 0 NOT NULL ENABLE, 
	SMS_SENT_DATE DATE, 
	SMS_SOURCE VARCHAR2(500 ), 
        SMS_SENDER VARCHAR2(4000 ) NOT NULL ENABLE, 
        SMS_PASSWORD       VARCHAR2(4000 ) NOT NULL ENABLE, 
        SMS_ACCOUNT_NAME  VARCHAR2(4000 ) NOT NULL ENABLE, 
        URL_ID Number NOT NULL ENABLE, 
	 CONSTRAINT FA_SEND_SMS_PK PRIMARY KEY (SMS_ID)
   );

   COMMENT ON COLUMN FA_SEND_SMS.SMS_STATUS IS '0 IS pending , 1 IS sent';

drop public synonym FA_SEND_SMS;

create public synonym FA_SEND_SMS for FA_SEND_SMS;