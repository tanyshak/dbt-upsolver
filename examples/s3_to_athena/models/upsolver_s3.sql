{{ config(
            materialized='connection',
            connection_type="S3"
        )
}}

AWS_ROLE = 'arn:aws:iam::949275490180:role/upsolver_samples_role'
EXTERNAL_ID = 'SAMPLES'
READ_ONLY = TRUE;
