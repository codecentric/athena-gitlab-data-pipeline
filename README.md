# book-sales-athena

This sample project explores the possibilities of merging two semi-structured json datasets using AWS Athena and deliver the result on a set of static GitLab pages.

**Please note:** This GitHub project provides an overview over the resources needed to build the solution. It isn't in itself runnable and requires an AWS account as well as a GitLab instance. If you'd like to build this yourself though, this repo should provide a good starting point.

## Sample use case

A made-up company, AmazingBooks, Inc., merges with a competitor, MediocreBooks, Inc. For the launch of their new, merged online book store, the most popular books of both companies will be part of a special launch offer. The marketing folks now need to merge the book sales data of both companies. The problem is: We can't access any databases directly and all the IT staff of both companies can provide us with is a bunch of (incompatible) JSON exports with book sales data.

In order for the marketing team to work on campaigns for the most popular books, they need to have a full view on the data:

- What are the most popular books overall?

To answer the question, we need to merge the data from both the AmazingBooks and the MediocreBooks systems. Athena to the rescue!

## Technologies used

- GitLab CI/CD
- GitLab Pages with MkDocs
- AWS Athena
- AWS Lambda
- AWS S3
- docker and a number of shell tools such as `jq` and the AWS CLI

## How it works

The data pipeline is held together by a GitLab CI/CD pipeline (see `gitlab-ci.yaml`) and looks as follows:

1. Data is delivered by the source systems (subsequently referred to as `system a` and `system b`) in json format and stored to `s3://your-bucket-name-here/data-delivery/`.
2. The data is sanatized (in this case, brought into json lines format) and stored in separate s3 directories (`s3://your-bucket-name-here/system-a/`; `s3://your-bucket-name-here/system-b/`) for Athena to pick up
3. A lambda function is invoked to trigger an Athena query (this assumes that the required Athena database, tables, and views are present to generate the report)
4. Upon triggering, the result file is retrieved from the results directory (`s3://your-bucket-name-here/query-results/lambda-triggered/`)
5. MkDocs generation is triggered and the result file is copied over to the static website directory once the build is finished

## Athena Resources

Please find DDL statements for the required Athena resources in the `aws-recources/athena` subdirectory.

## Lambda resources

Please find the code for the Lambda function in the `aws-recources/lambda` subdirectory.

## Sample data

Please find the JSON sample data in the `testdata` subdirectory.

## IAM Resources

The following IAM Resources are required for things to work:

- IAM Exec Role for the lambda function
    - Policy for Athena Execution
    - Policy for s3 access
- IAM User for GitLab with a set of AWS access credentials for GitLab to use
    - Policy for S3 access
    - Policy for Lambda invocation
