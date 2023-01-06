/*
-- 2. Create an empty table to use as staging for the raw data.
CREATE TABLE default_glue_catalog.database_16e61b.orders_raw_data()
    PARTITIONED BY $event_date;

-- 3. Create a streaming job to ingest data from the sample bucket into the staging table.
CREATE SYNC JOB load_orders_raw_data_from_s3
    CONTENT_TYPE = JSON
    AS COPY FROM S3 upsolver_s3_samples BUCKET = 'upsolver-samples' PREFIX = 'orders/'
    INTO default_glue_catalog.database_16e61b.orders_raw_data;
*/

SELECT *
FROM
  {{ ref(‘s3_connection’) }}
