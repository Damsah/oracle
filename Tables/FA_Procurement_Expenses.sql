drop table FA_Procurement_Expenses cascade constraints;

CREATE TABLE FA_Procurement_Expenses 
   (	
   Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
  Exp_id number not null enable,
  Exp_AMOUNT NUMBER NOT NULL ENABLE,
  Exp_DESC varchar2(1000)  NOT NULL ENABLE,
  s_Status NUMBER default 0, 
	 CONSTRAINT FA_Procurement_Expenses_PK PRIMARY KEY (Customer_ID, INV_ID,Exp_id)
   );


drop public synonym FA_Procurement_Expenses;

create public synonym FA_Procurement_Expenses for FA_Procurement_Expenses;