drop sequence EMP_SAL_TAX_DETAILS_SEQ_NO
/
   create sequence  EMP_SAL_TAX_DETAILS_SEQ_NO  minvalue 1 maxvalue 999999999999999999999999999
   increment by 1 
   start with 1 
   nocache  
   order  nocycle  
/
drop public synonym EMP_SAL_TAX_DETAILS_SEQ_NO
/
create public synonym EMP_SAL_TAX_DETAILS_SEQ_NO for EMP_SAL_TAX_DETAILS_SEQ_NO
/
