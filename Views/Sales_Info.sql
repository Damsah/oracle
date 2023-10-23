Create View Sales_Info as
SELECT 
  to_char(J.JOR_DATE,'mm/yyyy') JOR_DATE,
  JD.JOR_CUSTOMER_ID,
  JD.JOR_ACCOUNTNO,
  CA.ACCOUNT_NAME,
 sum(JD.JOR_DEPIT_AMOUNT) JOR_DEPIT_AMOUNT,
  sum(JD.JOR_CREDIT_AMOUNT) JOR_CREDIT_AMOUNT --sum(JD.JOR_DEPIT_AMOUNT)
FROM FA_JOURNAL_DETAILS JD
inner join FA_JOURNAL J on JD.JOR_ID=J.JOR_ID
inner join FA_CUSTOMER_CHART_OF_ACCOUNT CA on JD.JOR_CUSTOMER_ID=CA.CUSTOMER_ID and JD.JOR_ACCOUNTNO=CA.ACCOUNT_NUMBER
where /*JD.JOR_CUSTOMER_ID=47 and*/ CA.ACCOUNT_NAME like '%مبيعات%'
--and to_date(to_char(J.JOR_DATE,'dd/mm/yyyy'),'dd/mm/yyyy') between to_date('01/12/2022','dd/mm/yyyy') and to_date('31/12/2022','dd/mm/yyyy')
group by JD.JOR_CUSTOMER_ID,to_char(J.JOR_DATE,'mm/yyyy'),JD.JOR_ACCOUNTNO,CA.ACCOUNT_NAME
/*having sum(JD.JOR_CREDIT_AMOUNT)!=0*/;