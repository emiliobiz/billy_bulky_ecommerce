
  
    

        create or replace transient table E_COMMERCE.intermediate.int_customer_segmentation
         as
        (WITH customers AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__customers
)

, orders AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__orders
)


SELECT 
    o.ORDER_ID
    , o.CUSTOMER_ID
    , c.FIRST_NAME
    , c.LAST_NAME
    , c.EMAIL
    , o.PRODUCT_ID
    , o.QUANTITY
    , o.ORDER_DATE
    , o.STATUS
    , c.COUNTRY  
FROM orders AS o 
INNER JOIN customers AS c ON c.customer_id = o.customer_id
        );
      
  