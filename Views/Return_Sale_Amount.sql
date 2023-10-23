create view Return_Sale_Amount as
SELECT sr.CUSTOMER_ID,
  sr.INV_ID,
  sum(ivd.INV_DETAIL_AMOUNT_WITH_TAX) amount
FROM FA_SALES_RETURNS sr
inner join FA_INVOICE_DETAILS ivd on sr.INV_ID=ivd.INV_ID
and sr.INV_DETAILS_ID=ivd.INV_DETAIL_ID and sr.CUSTOMER_ID=ivd.INV_CUSTOMER_ID
group by sr.CUSTOMER_ID,sr.INV_ID;