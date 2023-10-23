 
drop table FA_INVOICE_DETAILS cascade constraints;

  CREATE TABLE FA_INVOICE_DETAILS 
   (	INV_ID NUMBER NOT NULL ENABLE, 
	INV_DETAIL_ID NUMBER NOT NULL ENABLE, 
	INV_CUSTOMER_ID NUMBER NOT NULL ENABLE, 
	INV_DETAIL_DESC VARCHAR2(500 ) NOT NULL ENABLE, 
	INV_DETAIL_AMOUNT NUMBER NOT NULL ENABLE, 
	INV_DETAIL_TAX_PERCENTAGE NUMBER, 
	INV_DETAIL_TAX_AMOUNT NUMBER, 
	INV_DETAIL_AMOUNT_WITH_TAX NUMBER NOT NULL ENABLE, 
	INV_ACCOUNT_NUMBER NUMBER NOT NULL ENABLE, 
	INV_TAX_ACCOUNT_NUMBER NUMBER NOT NULL ENABLE, 
	INV_GUIDANCE_TYPE NUMBER NOT NULL ENABLE, 
	 CONSTRAINT FA_INVOICE_DETAILS_PK PRIMARY KEY (INV_ID, INV_DETAIL_ID, INV_CUSTOMER_ID)
   );

   COMMENT ON COLUMN FA_INVOICE_DETAILS.INV_GUIDANCE_TYPE IS '1 is Asesst , 2 is Expense ,3 is Procurement ,4 is Sales';


drop public synonym FA_INVOICE_DETAILS;

create public synonym FA_INVOICE_DETAILS for FA_INVOICE_DETAILS;