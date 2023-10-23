drop table FA_Expenses cascade constraints;

CREATE TABLE FA_Expenses 
   (	
   Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
	INV_SUPPLIER_ID NUMBER NOT NULL ENABLE, 
  INV_AMOUNT NUMBER NOT NULL ENABLE,
  INV_DESC varchar2(1000)  NOT NULL ENABLE, 
	 CONSTRAINT FA_Expenses_PK PRIMARY KEY (Customer_ID, INV_ID)
   );


drop public synonym FA_Expenses;

create public synonym FA_Expenses for FA_Expenses;