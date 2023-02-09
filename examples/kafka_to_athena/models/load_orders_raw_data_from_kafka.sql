{{ config(  materialized='job',
            job_options={
              'CONTENT_TYPE': 'JSON',
              'COMPUTE_CLUSTER': '"Default Compute (Free)"'
            }
          )
}}

COPY FROM KAFKA upsolver_kafka_samples TOPIC = 'orders'
INTO {{ ref('kafka_orders_raw_data') }}
