
  create or replace   view E_COMMERCE.staging.staging_shopify__products
  
   as (
    WITH products AS (
    SELECT * FROM SHOPIFY.PUBLIC.products
)

SELECT
    PRODUCT_ID
    , NAME
    , CATEGORY
    , PRICE
    , STOCK_LEVEL
FROM products
  );

