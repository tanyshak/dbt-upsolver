{{ config( materialized='job', sync=true) }}


START_FROM = BEGINNING
ADD_MISSING_COLUMNS = true
RUN_INTERVAL = 1 MINUTE
AS INSERT INTO {{ ref('uptable_test2')}} MAP_COLUMNS_BY_NAME
-- Use the SELECT statement to choose columns from the source and implement your business logic transformations.
SELECT
  orderid AS order_id,
  MD5(customer.email) AS customer_id, -- hash or mask columns using built-in functions
  customer_name,  -- computed field defined later in the query
  nettotal AS total,
  $event_time AS partition_date
FROM {{ ref('uptable_test')}}
LET customer_name = customer.firstname || ' ' || customer.lastname -- create a computed column
WHERE ordertype = 'SHIPPING'
AND $event_time BETWEEN run_start_time() AND run_end_time();
