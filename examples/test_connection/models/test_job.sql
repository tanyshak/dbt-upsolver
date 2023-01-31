{{ config( materialized='job', sync=True) }}

CONTENT_TYPE = JSON
AS COPY FROM S3 upsolver_s3_try BUCKET = 'upsolver-samples' PREFIX = 'orders/'
INTO {{ ref('uptable_test') }};
