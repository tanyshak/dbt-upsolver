{{ config( materialized='uptable') }}

  (partition_date date)
  PARTITIONED BY partition_date;
