CREATE EXTERNAL TABLE booksales.system_b(
business_day string,
book_sales ARRAY<
    struct<
        qty: bigint,
        isbn: string
        >
>
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://your-bucket-name-here/system-b/'
