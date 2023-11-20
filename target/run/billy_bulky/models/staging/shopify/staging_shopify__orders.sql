
  create or replace   view E_COMMERCE.staging.staging_shopify__orders
  
   as (
    WITH orders AS (
    SELECT * FROM SHOPIFY.PUBLIC.orders
)

SELECT
    ORDER_ID
    , CUSTOMER_ID
    , PRODUCT_ID
    , QUANTITY
    , ORDER_DATE
    , STATUS
FROM orders
  );

