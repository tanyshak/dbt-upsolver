{{ config(  materialized='table')}}

SELECT
  *
FROM default_glue_catalog.database_16e61b.orders_raw_data limit 10
