{{ config(  materialized='incremental',
            job_options={
              'SYNC': True,
              'CONTENT_TYPE': 'JSON',
              'COMPUTE_CLUSTER': 'Default Compute (Free)',
              'TOPIC': 'orders'
            },

            unique_key=[{'field':'user_id', 'type':'string'}, 
                        {'field':'session_number', 'type':'bigint'}],

            partition_by=[{'field':'partition_date', 'type':'date'}],

            remove_duplicates={ --this happens before the select runs, on the input data
              'KEY': '<field_or_expression>',
              'SEARCH_WINDOW': '1 day'
            },

            remove_out_of_order_data={ --this happens before the select runs, on the input data
              'KEY': '<field_or_expression>',
              'ORDER_BY': '<field_or_expression>',
              'SEARCH_WINDOW': '1 day'
            }
          )
}}

-- for now this syntax is hard-coded, none of it can be modified
-- we still need to decide the syntax for the time filter
SELECT * FROM {{ ref('kafka_connection') }} WHERE __time_filter()