{{ config(  materialized='uptable',
            table_options={
              'COMMENT': "'test_comment'",
              'GLOBALLY_UNIQUE_KEYS': True
            }
          )
}}

(partition_date date)
PARTITIONED BY partition_date
