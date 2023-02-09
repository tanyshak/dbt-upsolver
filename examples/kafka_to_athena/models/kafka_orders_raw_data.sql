{{ config(  materialized='uptable',
            table_options={
              'COMMENT': "'table comment'",
            }
          )
}}

PARTITIONED BY $event_date
