import boto3

database = 'booksales'
query_totals_by_month = 'SELECT * FROM "booksales"."book_sales_total_by_month"'
query_totals_by_year = 'SELECT * FROM "booksales"."book_sales_total_by_year"'
output_bucket='s3://your-bucket-name-here'
output_dir='query-results/lambda-triggered'

def lambda_handler(event, context):
    client = boto3.client('athena')

    # Specify the kind of query aggregation level - either by month or by year
    query_by = event['queryBy']
    query_string = ""
    if query_by == 'month':
        query_string = query_totals_by_month
    elif query_by == 'year':
        query_string = query_totals_by_year
    else:
        raise ValueError(f"The specified aggregation level '{query_by}' is not recognized. Please specify a valid aggregation level ('month'; 'year').")
        
    # Input is ok, fire off the Athena query
    response = client.start_query_execution(
        QueryString=query_string,
        QueryExecutionContext={
            'Database': database
        },
        ResultConfiguration={
            'OutputLocation': "{}/{}".format(output_bucket, output_dir)
        }
    )

    return response
