CREATE OR REPLACE VIEW "book_sales_total_by_month" AS 
SELECT
  month
, isbn
, "sum"(number_sold) number_sold_total
FROM
  (
(
      SELECT
        "date_format"(CAST("date_parse"(transaction_date, '%Y-%m-%dT%H:%i:%s') AS date), '%Y-%m') month
      , product_info.isbn
      , "sum"(qty) number_sold
      FROM
        system_a
      WHERE (product_info.type = 'book')
      GROUP BY product_info.isbn, "date_format"(CAST("date_parse"(transaction_date, '%Y-%m-%dT%H:%i:%s') AS date), '%Y-%m')
   ) UNION ALL (
      SELECT
        "date_format"("date_parse"(business_day, '%Y-%m-%d'), '%Y-%m') month
      , book_sale.isbn
      , "sum"(book_sale.qty) number_sold
      FROM
        (system_b
      CROSS JOIN UNNEST(book_sales) t (book_sale))
      GROUP BY "date_format"("date_parse"(business_day, '%Y-%m-%d'), '%Y-%m'), book_sale.isbn
   ) ) 
GROUP BY month, isbn
ORDER BY 1 DESC
