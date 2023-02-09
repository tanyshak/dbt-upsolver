{{ config(  materialized='job',
            job_options={
              'CONTENT_TYPE': 'JSON'
            }
          )
}}

COPY FROM S3 upsolver_s3_samples
  BUCKET = 'upsolver-samples'
  PREFIX = 'orders/'
INTO {{ ref('orders_raw_data_to_join') }}
