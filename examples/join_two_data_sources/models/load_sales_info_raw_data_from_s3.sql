{{ config( materialized='job', CONTENT_TYPE = 'JSON') }}

COPY FROM S3 {{ ref('upsolver_s3_samples').identifier }}
  BUCKET = 'upsolver-samples'
  PREFIX = 'sales_info/'
INTO {{ ref('sales_info_raw_data') }};
