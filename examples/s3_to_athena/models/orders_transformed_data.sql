{{ config(  materialized='uptable',
            table_options={
              'COMMENT': "'table comment'",
            }
          )
}}

(partition_date date)
PARTITIONED BY partition_date
