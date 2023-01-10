/*
-- 5. Create an output table in AWS Glue Data Catalog. The table will be accessible in Athena once data has been added.
CREATE TABLE default_glue_catalog.database_16e61b.joined_orders_transformed_data;


CREATE JOB join_two_tables_orders_with_last_employee
    START_FROM = BEGINNING
    ADD_MISSING_COLUMNS = TRUE
    RUN_INTERVAL = 1 MINUTE
    AS INSERT INTO default_glue_catalog.database_16e61b.joined_orders_transformed_data MAP_COLUMNS_BY_NAME
    -- Use the SELECT statement below to choose your columns and performed the desired transformations.
    -- In this example, we join the orders with the sales data to enrich each order with the last store employee that managed the order.
    SELECT
       s.orderid,
       mv.employeeid AS employeeid,
       mv.firstname AS firstname,
       mv.lastname AS lastname
    FROM default_glue_catalog.database_16e61b.orders_raw_data as s
    LEFT JOIN default_glue_catalog.database_16e61b.physical_store_orders_materialized_view AS mv
    ON mv.orderid = s.orderid
    WHERE mv.source = 'Store'
    AND $commit_time between run_start_time() AND run_end_time();
*/

SELECT
   s.orderid,
   mv.employeeid AS employeeid,
   mv.firstname AS firstname,
   mv.lastname AS lastname
FROM {{ ref(‘orders_raw_data’) }} as s
LEFT JOIN {{ ref(‘physical_store_orders_materialized_view’) }} AS mv
ON mv.orderid = s.orderid
WHERE mv.source = 'Store'
AND $commit_time between run_start_time() AND run_end_time();
