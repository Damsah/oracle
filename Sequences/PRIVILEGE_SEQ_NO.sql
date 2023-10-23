drop sequence PRIVILEGE_SEQ_NO
/
   create sequence  PRIVILEGE_SEQ_NO  minvalue 1 maxvalue 999999999999999999999999999
   increment by 1 
   start with 1 
   nocache  
   order  nocycle  
/
drop public synonym PRIVILEGE_SEQ_NO
/
create public synonym PRIVILEGE_SEQ_NO for PRIVILEGE_SEQ_NO
/