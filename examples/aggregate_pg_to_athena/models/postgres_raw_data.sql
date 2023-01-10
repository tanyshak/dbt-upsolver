/*
-- 2. Create an empty table to use as staging for the raw data.
CREATE TABLE default_glue_catalog.database_16e61b.postgres_raw_data()
    PARTITIONED BY $event_date;

-- 3. Create a streaming job to ingest data from the sample database into the staging table.
-- Learn how to configure Postgres for CDC at https://docs.upsolver.com/sqlake/sql-command-reference/sql-jobs/create-job/copy-from/cdc-options
CREATE JOB load_raw_data_from_postgres
    PUBLICATION_NAME = 'your_publiction_name'
    AS COPY FROM POSTGRES upsolver_postgres_samples TABLE_INCLUDE_LIST = ('your_table_name')
    INTO default_glue_catalog.database_16e61b.postgres_raw_data;
*/

SELECT *
FROM
  {{ ref('pg_connection') }}
