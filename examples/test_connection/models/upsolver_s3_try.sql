/*
There are 3 design way:
1. Run query as it is  upsolver way

CREATE S3 CONNECTION upsolver_s3_samples_try
    AWS_ROLE = 'arn:aws:iam::949275490180:role/upsolver_samples_role'
    EXTERNAL_ID = 'SAMPLES'
    READ_ONLY = TRUE;

2. CREATE CONNECTION plus config in model

3. CREATE CONNECTION plus config in yaml file

*/

{{ config(
            materialized='connection',
            connection_type="S3",
            aws_role='arn:aws:iam::949275490180:role/upsolver_samples_role',
            external_id='SAMPLES',
            read_only= True
        )
}}

CREATE CONNECTION
