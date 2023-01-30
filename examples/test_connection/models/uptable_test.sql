{{ config( materialized='uptable') }}

  PARTITIONED BY $event_date;
