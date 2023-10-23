 
drop table FA_SYSTEM_FORMS cascade constraints;

 CREATE TABLE FA_SYSTEM_FORMS 
   (	SF_ID NUMBER NOT NULL ENABLE, 
	SF_FORM_NAME VARCHAR2(100 ) NOT NULL ENABLE, 
	SF_FORM_AR_NAME VARCHAR2(200 ), 
	SF_FORM_ICON VARCHAR2(50 ) NOT NULL ENABLE, 
	SF_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_SYSTEM_FORMS_PK PRIMARY KEY (SF_ID)
   )  ;

   COMMENT ON COLUMN FA_SYSTEM_FORMS.SF_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';



drop public synonym FA_SYSTEM_FORMS;

create public synonym FA_SYSTEM_FORMS for FA_SYSTEM_FORMS;