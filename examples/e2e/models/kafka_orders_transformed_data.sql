{{ config(  materialized='incremental',
            incremental_strategy='merge', --optional
            job_options={
              'SYNC': True,
              'COMPUTE_CLUSTER': 'Default Compute (Free)'
            },
            unique_key=[{'field':'order_id', 'type':'string'},
                        {'field':'item_id', 'type':'string'}],

            delete_condition='is_delete = true',

            partition_by=[{'field':'partition_date', 'type':'date'}]
          )
}}

--pushdown example
WITH a AS (SELECT *,
                  COALESCE(customer.firstname, 'John') AS firstname,
                  COALESCE(customer.lastname, 'Smith') AS lastname
             FROM {{ ref('kafka_orders_raw') }}
            WHERE __time_filter()
              AND ordertype = 'SHIPPING'),
     b AS (SELECT *, 
                  firstname || ' ' || lastname AS customer_name
             FROM a)
SELECT
  orderid AS order_id,
  MD5(TO_UTF8(customer.email)) AS customer_id,
  customer_name,
  nettotal AS total,
  "$event_time" AS partition_date,
  b.customer_details.*, --unnest record
  c.item_id as item_id,
  c.*
 FROM b
  CROSS JOIN UNNEST(b.items) AS c --unnest array