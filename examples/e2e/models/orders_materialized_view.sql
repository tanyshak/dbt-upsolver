{{ config(  materialized='materializedview',
            options={
              'SYNC': True,
              'COMPUTE_CLUSTER': 'Default Compute (Free)',
              'WINDOW_SIZE'='1 day'
            }
          )
}}

--this is a theoretical pushdown example, but we don't currently have a good way to implement it
WITH a AS (SELECT *,
                  customer.firstname || ' ' || customer.lastname AS customer_name
             FROM {{ ref('kafka_orders_raw') }}
            WHERE ordertype = 'SHIPPING')

SELECT
  MD5(TO_UTF8(customer.email)) AS customer_id,
  ARBITRARY(customer_name) AS customer_name,
  SUM(nettotal) AS total_purchases
 FROM a
GROUP BY customer_id