{{ config( materialized='materializedview', sync=True ) }}

SELECT partition_date
  FROM {{ ref('uptable_test2')}}
GROUP BY partition_date;
