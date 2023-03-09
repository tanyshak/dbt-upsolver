{{ config(  materialized='incremental',
            sync=True,
            connectiont_type = 'S3',
        	  options={
          	'CONTENT_TYPE': 'JSON'
        	   },
            connection_options={
              'BUCKET': "'upsolver-samples'",
              'PREFIX': "'orders/'"
            },
        	partition_by=[{'field':'$event_date'}]
      	)
}}

SELECT * FROM {{ ref('s3_connection') }}
