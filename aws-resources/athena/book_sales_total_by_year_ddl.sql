CREATE OR REPLACE VIEW "book_sales_total_by_year" AS 
SELECT
  "date_format"("date_parse"(month, '%Y-%m'), '%Y') year
, isbn
, "sum"(number_sold_total) number_sold_total
FROM
  "booksales"."book_sales_total_by_month"
GROUP BY "date_format"("date_parse"(month, '%Y-%m'), '%Y'), isbn
ORDER BY 1 DESC
