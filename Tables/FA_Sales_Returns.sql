drop table FA_Sales_Returns cascade constraints;

CREATE TABLE FA_Sales_Returns 
   (	
  Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
	INV_SUPPLIER_ID NUMBER NOT NULL ENABLE, 
  INV_Details_id NUMBER NOT NULL ENABLE,
  Return_Date varchar2(10) NOT NULL ENABLE,
	 CONSTRAINT FA_Sales_returns_PK PRIMARY KEY (Customer_ID, INV_ID,INV_Details_id)
   );

drop public synonym FA_Sales_Returns;

create public synonym FA_Sales_Returns for FA_Sales_Returns;