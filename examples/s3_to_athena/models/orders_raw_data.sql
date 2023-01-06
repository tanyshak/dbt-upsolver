SELECT *
AS COPY FROM
  {{ ref(‘s3_connection’) }}
