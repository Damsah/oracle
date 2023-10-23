drop table FA_Sales cascade constraints;

CREATE TABLE FA_Sales 
   (	
   Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
	INV_SUPPLIER_ID NUMBER NOT NULL ENABLE, 
  INV_AMOUNT NUMBER NOT NULL ENABLE,
  INV_DESC varchar2(1000)  NOT NULL ENABLE,
	 s_Status NUMBER, 
	 CONSTRAINT FA_Sales_PK PRIMARY KEY (Customer_ID, INV_ID)
   );
COMMENT ON COLUMN FA_Sales.s_Status IS '1 IS PRocNotDone , 2 IS PRocDone';

drop public synonym FA_Sales;

create public synonym FA_Sales for FA_Sales;