{{ config(  materialized='incremental',
            sync=True,
            source = 'S3',
        	  options={
          	'CONTENT_TYPE': 'JSON'
        	   },
            source_options={
              'BUCKET': "'upsolver-samples'",
              'PREFIX': "'orders/'"
            },
        	partition_by=[{'field':'$event_date'}]
      	)
}}

SELECT * FROM {{ ref('upsolver_s3_samples_1') }}
