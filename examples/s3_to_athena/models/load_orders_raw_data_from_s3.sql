{{ config( materialized='job', sync='SYNC', CONTENT_TYPE = 'JSON') }}

COPY FROM S3 {{ ref('upsolver_s3').identifier }} BUCKET = 'upsolver-samples' PREFIX = 'orders/'
INTO {{ ref('orders_raw_data') }};
