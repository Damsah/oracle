 
drop table FA_COMP_GOALS cascade constraints;

   CREATE TABLE FA_COMP_GOALS 
   (	CG_ID NUMBER NOT NULL ENABLE, 
	CC_ID NUMBER NOT NULL ENABLE, 
	CG_GOAL_NAME VARCHAR2(500 ) NOT NULL ENABLE, 
	CG_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_COMP_GOALS_PK PRIMARY KEY (CG_ID, CC_ID)
   );

   COMMENT ON COLUMN FA_COMP_GOALS.CG_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';


drop public synonym FA_COMP_GOALS;

create public synonym FA_COMP_GOALS for FA_COMP_GOALS;