CREATE EXTERNAL TABLE booksales.system_a(
transaction_date string,
qty bigint,
product_info struct<
    type: string,
    isbn: string,
    title: string>
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://your-bucket-name-here/system-a/'
