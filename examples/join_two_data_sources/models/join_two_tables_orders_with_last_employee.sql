{{ config( materialized='job',
           START_FROM = 'BEGINNING',
           ADD_MISSING_COLUMNS = true,
           RUN_INTERVAL = '1 MINUTE'
         )
}}

INSERT INTO {{ ref('joined_orders_transformed_data')}} MAP_COLUMNS_BY_NAME
-- Use the SELECT statement to choose columns from the source and implement your business logic transformations.
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
