drop table FA_Sales_Part_Money cascade constraints;

CREATE TABLE FA_Sales_Part_Money 
   (	
   Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
  paid_id number NOT NULL ENABLE, 
	SUPPLIER_ID NUMBER NOT NULL ENABLE, 
  AMOUNT NUMBER NOT NULL ENABLE,
  Total_Amount NUMBER NOT NULL ENABLE,
  INV_DESC varchar2(1000)  NOT NULL ENABLE,
	 s_Status NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_Sales_Part_Money_PK PRIMARY KEY (Customer_ID, INV_ID,paid_id,SUPPLIER_ID)
   );


drop public synonym FA_Sales_Part_Money;

create public synonym FA_Sales_Part_Money for FA_Sales_Part_Money;