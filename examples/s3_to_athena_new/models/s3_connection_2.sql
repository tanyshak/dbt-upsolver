{{ config(
        	materialized='connection',
        	connection_type='S3',
          connection_options={
            'aws_role': 'arn:aws:iam::949275490180:role/upsolver_samples_role',
            'external_id': 'SAMPLES',
            'read_only': True
          }
    	)
}}
