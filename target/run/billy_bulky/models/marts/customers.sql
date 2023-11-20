
  
    

        create or replace transient table E_COMMERCE.marts.customers
         as
        (WITH  __dbt__cte__staging_shopify__customers as (
WITH customers AS (
    SELECT * FROM SHOPIFY.PUBLIC.customers
)

SELECT
    CUSTOMER_ID
    , FIRST_NAME
    , LAST_NAME
    , EMAIL
    , JOIN_DATE
    , COUNTRY
FROM customers
),  __dbt__cte__staging_shopify__orders as (
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
),  __dbt__cte__staging_shopify__products as (
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
), customers AS (
    SELECT * FROM __dbt__cte__staging_shopify__customers
)

, orders AS (
    SELECT * FROM __dbt__cte__staging_shopify__orders
)

, products AS (
    SELECT * FROM __dbt__cte__staging_shopify__products
)

, source AS (
    SELECT
        c.CUSTOMER_ID
        , c.FIRST_NAME
        , c.LAST_NAME
        , c.EMAIL
        , c.JOIN_DATE
        , c.COUNTRY
        , COUNT(o.ORDER_ID) AS total_orders
        , SUM(o.QUANTITY * p.PRICE) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
    LEFT JOIN products p ON o.PRODUCT_ID = p.PRODUCT_ID
    WHERE o.STATUS NOT IN ('cancelled')
    GROUP BY c.CUSTOMER_ID, c.FIRST_NAME, c.LAST_NAME, c.EMAIL, c.JOIN_DATE, c.COUNTRY
)

, final AS (
SELECT
    s.CUSTOMER_ID
    , s.FIRST_NAME
    , s.LAST_NAME
    , s.EMAIL
    , s.JOIN_DATE
    , s.COUNTRY
    , s.total_orders
    , s.total_spent
    , CASE WHEN s.total_spent > 1000 THEN 'VIP' ELSE 'Regular' END AS customer_segment 
FROM source s
)

SELECT * FROM final
        );
      
  