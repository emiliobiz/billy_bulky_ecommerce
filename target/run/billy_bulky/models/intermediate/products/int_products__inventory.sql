
  
    

        create or replace transient table E_COMMERCE.intermediate.int_products__inventory
         as
        (

WITH inventory_data AS (
    SELECT
        DATE_TRUNC('day', CURRENT_TIMESTAMP) AS snapshot_date
        , p.PRODUCT_ID
        , p.STOCK_LEVEL
    FROM E_COMMERCE.staging.staging_shopify__products p
    WHERE NOT EXISTS (
        SELECT 1
        FROM E_COMMERCE.intermediate.int_products__inventory
        WHERE snapshot_date = DATE_TRUNC('day', CURRENT_TIMESTAMP)
          AND PRODUCT_ID = p.PRODUCT_ID
    )
)

SELECT
    snapshot_date
    , PRODUCT_ID
    , STOCK_LEVEL
FROM inventory_data


        );
      
  