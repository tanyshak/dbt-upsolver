{{ config(  materialized='job',
            job_options={
              'START_FROM': 'BEGINNING',
              'ADD_MISSING_COLUMNS': True,
              'RUN_INTERVAL': '1 MINUTE'
            }
         )
}}

INSERT INTO {{ ref('joined_orders_transformed_data')}} MAP_COLUMNS_BY_NAME
-- Use the SELECT statement to choose columns from the source and implement your business logic transformations.
SELECT
   s.orderid,
   mv.employeeid AS employeeid,
   mv.firstname AS firstname,
   mv.lastname AS lastname
FROM {{ ref('orders_raw_data_to_join')}} as s
LEFT JOIN {{ ref('physical_store_orders_materialized_view')}} AS mv
ON mv.orderid = s.orderid
WHERE mv.source = 'Store'
AND $commit_time between run_start_time() AND run_end_time()
