/*
-- 6. Create a Materialized View to aggregate the last sales interaction for each order.
-- A Materialized View holds key-value pairs where the key is used to join with another table.
CREATE MATERIALIZED VIEW default_glue_catalog.database_16e61b.physical_store_orders_materialized_view AS
    SELECT orderid,
       LAST(saleinfo.source) as source,
       LAST(saleinfo.store.location.country) as country,
       LAST(saleinfo.store.location.name) as name,
       LAST(saleinfo.store.servicedby.employeeid) as employeeid,
       LAST(saleinfo.store.servicedby.firstname) as firstname,
       LAST(saleinfo.store.servicedby.lastname) as lastname
    FROM default_glue_catalog.database_16e61b.sales_info_raw_data
    GROUP BY orderid;
*/

SELECT orderid,
   LAST(saleinfo.source) as source,
   LAST(saleinfo.store.location.country) as country,
   LAST(saleinfo.store.location.name) as name,
   LAST(saleinfo.store.servicedby.employeeid) as employeeid,
   LAST(saleinfo.store.servicedby.firstname) as firstname,
   LAST(saleinfo.store.servicedby.lastname) as lastname
FROM {{ ref(‘sales_info_raw_data’) }}
GROUP BY orderid;
