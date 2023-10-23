 
drop table FA_MESSAGE_EMAILS cascade constraints;

 CREATE TABLE FA_MESSAGE_EMAILS 
   (	MAIL_MESSAGE_ID NUMBER NOT NULL ENABLE, 
	MESSAGE_TEXT VARCHAR2(4000), 
	DELETED NUMBER DEFAULT 0
   );

   COMMENT ON COLUMN FA_MESSAGE_EMAILS.DELETED IS '0 IS NOT Deleted , 1 IS Deleted';


drop public synonym FA_MESSAGE_EMAILS;

create public synonym FA_MESSAGE_EMAILS for FA_MESSAGE_EMAILS;