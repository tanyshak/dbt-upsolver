{{ config( materialized='job', sync='SYNC', CONTENT_TYPE = 'JSON') }}

COPY FROM S3 upsolver_s3_try BUCKET = 'upsolver-samples' PREFIX = 'orders/'
INTO {{ ref('uptable_test') }};
