SELECT
  orderid AS order_id,
  MD5(customer.email) AS customer_id,
  customer_name,
  nettotal AS total,
  $event_time AS partition_date
FROM {{ ref(‘orders_row_data’) }}
LET customer_name = customer.firstname || ' ' || customer.lastname
WHERE ordertype = 'SHIPPING'
AND $event_time BETWEEN run_start_time() AND run_end_time();

/*
-- 5. Create an output table in AWS Glue Data Catalog. The table will be accessible in Athena once data has been added.

CREATE TABLE default_glue_catalog.database_16e61b.orders_transformed_data(partition_date date)
    PARTITIONED BY partition_date;

-- 6. Create a streaming job to read from the staging table, apply business logic transformations and insert the results into the output table.
CREATE SYNC JOB transform_orders_and_insert_into_athena
    START_FROM = BEGINNING
    ADD_MISSING_COLUMNS = true
    RUN_INTERVAL = 1 MINUTE
    AS INSERT INTO default_glue_catalog.database_16e61b.orders_transformed_data MAP_COLUMNS_BY_NAME
    -- Use the SELECT statement to choose columns from the source and implement your business logic transformations.
    SELECT
      orderid AS order_id,
      MD5(customer.email) AS customer_id, -- hash or mask columns using built-in functions
      customer_name,  -- computed field defined later in the query
      nettotal AS total,
      $event_time AS partition_date
    FROM default_glue_catalog.database_16e61b.orders_raw_data
    LET customer_name = customer.firstname || ' ' || customer.lastname -- create a computed column
    WHERE ordertype = 'SHIPPING'
    AND $event_time BETWEEN run_start_time() AND run_end_time();
*/
