/*
CREATE TABLE default_glue_catalog.database_16e61b.postgres_transformed_data(partition_date date)
    PARTITIONED BY partition_date;

Transform and insert into the output table

-- 6. Create a streaming job to read from the staging table, apply business logic transformations and insert the results into the output table.
CREATE SYNC JOB transform_and_insert_into_athena
    START_FROM = BEGINNING
    ADD_MISSING_COLUMNS = true
    RUN_INTERVAL = 1 MINUTE
    AS INSERT INTO default_glue_catalog.database_16e61b.postgres_transformed_data MAP_COLUMNS_BY_NAME
    -- Use the SELECT statement to choose columns from the source and implement your business logic transformations.
    SELECT
       $event_time AS partition_date,
       COL1,
       SUM(COL2) as sum_column2,
       MAX(COL3) as max_column3,
       LAST(COL4) as last_column4
    FROM default_glue_catalog.database_16e61b.postgres_raw_data
    WHERE $event_time BETWEEN run_start_time() AND run_end_time()
    GROUP BY 1, 2;
*/
SELECT
  $event_time AS partition_date,
  COL1,
  SUM(COL2) as sum_column2,
  MAX(COL3) as max_column3,
  LAST(COL4) as last_column4  
FROM {{ ref(‘postgres_row_data’) }}
WHERE $event_time BETWEEN run_start_time() AND run_end_time()
GROUP BY 1, 2;
