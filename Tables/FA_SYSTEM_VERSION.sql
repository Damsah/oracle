 
drop table FA_SYSTEM_VERSION cascade constraints;

  CREATE TABLE FA_SYSTEM_VERSION 
   (	SV_NO VARCHAR2(20 BYTE)
   ) ;



drop public synonym FA_SYSTEM_VERSION;

create public synonym FA_SYSTEM_VERSION for FA_SYSTEM_VERSION;