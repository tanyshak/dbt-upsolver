{{ config( materialized='job', sync='SYNC', CONTENT_TYPE = 'JSON') }}

COPY FROM S3 upsolver_s3 BUCKET = 'upsolver-samples' PREFIX = 'orders/'
INTO {{ ref('orders_raw_data') }};
