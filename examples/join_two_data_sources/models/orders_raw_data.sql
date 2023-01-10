/*
-- 2. Create empty table to use as staging for orders.
CREATE TABLE default_glue_catalog.database_16e61b.orders_raw_data()
    PARTITIONED BY $event_date;

-- 3. Create streaming job to ingest raw orders into the staging tables..
CREATE JOB load_orders_raw_data_from_s3
   CONTENT_TYPE = JSON
   AS COPY FROM S3 upsolver_s3_samples
      BUCKET = 'upsolver-samples'
      PREFIX = 'orders/'
   INTO default_glue_catalog.database_16e61b.orders_raw_data;
*/

SELECT *
FROM
  {{ ref('s3_connection') }}
