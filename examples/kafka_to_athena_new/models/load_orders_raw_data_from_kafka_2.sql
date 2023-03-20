{{ config(  materialized='incremental',
            source = 'KAFKA',
        	  options={
              'CONTENT_TYPE': 'JSON',
              'COMPUTE_CLUSTER': '"Default Compute (Free)"'
            },
            source_options={'TOPIC': "'orders'"},
            partition_by=[{'field':'$event_date'}]
      	)
}}

SELECT * FROM {{ ref('upsolver_kafka_samples_2') }}
