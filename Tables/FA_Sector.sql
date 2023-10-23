 
drop table FA_Sector cascade constraints;

CREATE TABLE FA_Sector 
   (
   Sector_ID NUMBER NOT NULL ENABLE, 
	 Sector_NAME VARCHAR2(500) NOT NULL ENABLE, 
   Sector_Tax_Persantage NUMBER NOT NULL ENABLE, 
	 CO_DELETED NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT FA_Sector_PK PRIMARY KEY (Sector_ID), 
	 CONSTRAINT FA_Sector_UK UNIQUE (Sector_NAME)
   ) ;

   COMMENT ON COLUMN FA_Sector.CO_DELETED IS '0 IS NOT DELETED , 1 IS DELETED';

drop public synonym FA_Sector;

create public synonym FA_Sector for FA_Sector;