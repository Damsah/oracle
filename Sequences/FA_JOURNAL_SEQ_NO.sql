drop sequence FA_JOURNAL_SEQ_NO
/
   create sequence  FA_JOURNAL_SEQ_NO  minvalue 1 maxvalue 999999999999999999999999999
   increment by 1 
   start with 1 
   nocache  
   order  nocycle  
/
drop public synonym FA_JOURNAL_SEQ_NO
/
create public synonym FA_JOURNAL_SEQ_NO for FA_JOURNAL_SEQ_NO
/
