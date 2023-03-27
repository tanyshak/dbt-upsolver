{{ config(  materialized='incremental',
            sync=True,
            source = 'S3',
        	  options={
          	'CONTENT_TYPE': 'JSON',
            'LOCATION': 's3://upsolver-samples/orders/'
            },
        	partition_by=[{'field':'$event_date'}]
      	)
}}

SELECT * FROM {{ ref('s3_connection_2') }}
