{{ config(  materialized='job',
            job_options={
              'CONTENT_TYPE': 'JSON'
            }
          )
}}

COPY FROM S3 upsolver_s3_samples
  BUCKET = 'upsolver-samples'
  PREFIX = 'sales_info/'
INTO {{ ref('sales_info_raw_data') }}
