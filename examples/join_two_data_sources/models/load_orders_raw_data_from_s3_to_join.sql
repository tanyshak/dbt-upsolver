{{ config( materialized='job', CONTENT_TYPE = 'JSON') }}

COPY FROM S3 {{ ref('upsolver_s3_samples').identifier }}
  BUCKET = 'upsolver-samples'
  PREFIX = 'orders/'
INTO {{ ref('orders_raw_data_to_join') }};
