drop table FA_Assests_Expenses cascade constraints;

CREATE TABLE FA_Assests_Expenses 
   (	
   Customer_ID NUMBER NOT NULL ENABLE, 
	INV_ID NUMBER NOT NULL ENABLE, 
  Exp_id number not null enable,
  Exp_AMOUNT NUMBER NOT NULL ENABLE,
  Exp_DESC varchar2(1000)  NOT NULL ENABLE,
  ASSEST_ID number  NOT NULL ENABLE,
  s_Status NUMBER default 0,
	 CONSTRAINT FA_Assests_Expenses_PK PRIMARY KEY (Customer_ID, INV_ID,Exp_id)
   );


 COMMENT ON COLUMN FA_Assests_Expenses.s_Status  IS '0 : General Asesst Exp,1 :Added to Assest Amount';


drop public synonym FA_Assests_Expenses;

create public synonym FA_Assests_Expenses for FA_Assests_Expenses;