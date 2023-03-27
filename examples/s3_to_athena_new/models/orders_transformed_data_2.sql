{{ config(  materialized='incremental',
            incremental_strategy='insert',
            sync=True,
            map_columns_by_name=True,
            options={
              	'START_FROM': 'BEGINNING',
                'ADD_MISSING_COLUMNS': True,
                'RUN_INTERVAL': '1 MINUTE'
            	},
            primary_key=[{'field':'partition_date', 'type':'date'}]
          )
}}

SELECT
  orderid AS order_id,
  MD5(customer.email) AS customer_id,
  customer_name,
  nettotal AS total,
  $event_time AS partition_date

 FROM {{ ref('orders_raw_data_2')}}
 LET customer_name = customer.firstname || ' ' || customer.lastname
 WHERE ordertype = 'SHIPPING'
 AND $event_time BETWEEN run_start_time() AND run_end_time()
