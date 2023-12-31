 
drop table FA_INVOICE cascade constraints;


  CREATE TABLE FA_INVOICE 
   (	INV_ID NUMBER NOT NULL ENABLE, 
	INV_NUMBER VARCHAR2(500 ) NOT NULL ENABLE, 
	INV_CUSTOMER_ID NUMBER NOT NULL ENABLE, 
	INV_DATE DATE NOT NULL ENABLE, 
	INV_PRECURMENT_DATE DATE NOT NULL ENABLE, 
	INV_SUPPLIER_ID NUMBER NOT NULL ENABLE, 
	INV_TYPE NUMBER NOT NULL ENABLE, 
	INV_AMOUNT NUMBER, 
	INV_DESC VARCHAR2(500 ) NOT NULL ENABLE, 
	INV_ATTACHMENT VARCHAR2(500 ), 
        INV_TAXABLE_STATUS number,
	 CONSTRAINT FA_INVOICE_PK PRIMARY KEY (INV_ID, INV_NUMBER, INV_CUSTOMER_ID)
   );

   COMMENT ON COLUMN FA_INVOICE.INV_TYPE IS '1 is Cash ,2 is check Bank, 3 is PostPaid ,';




drop public synonym FA_INVOICE;

create public synonym FA_INVOICE for FA_INVOICE;