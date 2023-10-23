drop table FA_Procurement_Discount cascade constraints;

CREATE TABLE FA_Procurement_Discount 
   (	
  Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
  INV_Details_id NUMBER NOT NULL ENABLE,
	INV_SUPPLIER_ID NUMBER NOT NULL ENABLE, 
  Discount_Amount NUMBER NOT NULL ENABLE,
  Discount_Date varchar2(10) NOT NULL ENABLE,
	 CONSTRAINT FA_Procurement_Discount_PK PRIMARY KEY (Customer_ID, INV_ID,INV_Details_id)
   );

drop public synonym FA_Procurement_Discount;

create public synonym FA_Procurement_Discount for FA_Procurement_Discount;