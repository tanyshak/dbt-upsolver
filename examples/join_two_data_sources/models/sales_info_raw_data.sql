/*
-- 2. Create empty table to use as staging for sales.

CREATE TABLE default_glue_catalog.database_16e61b.sales_info_raw_data()
    PARTITIONED BY $event_date;

-- 3. Create streaming job to ingest raw sales into the staging tables..

    CREATE JOB load_sales_info_raw_data_from_s3
       CONTENT_TYPE = JSON
       AS COPY FROM S3 upsolver_s3_samples
          BUCKET = 'upsolver-samples'
          PREFIX = 'sales_info/'
       INTO default_glue_catalog.database_16e61b.sales_info_raw_data;
*/

SELECT *
FROM
  {{ ref('s3_connection') }}
