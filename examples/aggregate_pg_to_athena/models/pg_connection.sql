/*
-- 1. Create a connection to SQLake sample data source.
CREATE POSTGRES CONNECTION upsolver_postgres_samples
    CONNECTION_STRING = 'jdbc:postgresql://host:5432/schema_name'
    USER_NAME = 'your_user_name'
    PASSWORD = 'your_password';
*/

CREATE CONNECTION {{ this }}
