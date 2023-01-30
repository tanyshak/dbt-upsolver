{{ config( materialized='materializedview', sync=True) }}

SELECT orderid
  FROM default_glue_catalog.database_16e61b.orders_raw_data
GROUP BY orderid;
