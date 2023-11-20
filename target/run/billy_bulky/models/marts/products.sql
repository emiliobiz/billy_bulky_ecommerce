
  
    

        create or replace transient table E_COMMERCE.marts.products
         as
        (WITH  __dbt__cte__staging_shopify__orders as (
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
), orders AS (
    SELECT * FROM __dbt__cte__staging_shopify__orders
)

, products AS (
    SELECT * FROM __dbt__cte__staging_shopify__products
)


, product_sales AS (
    SELECT
        o.PRODUCT_ID
        , SUM(o.QUANTITY) AS total_units_sold
        , SUM(o.QUANTITY * p.PRICE) AS total_sales_value
    FROM orders o
    JOIN products p ON o.PRODUCT_ID = p.PRODUCT_ID
    WHERE o.STATUS NOT IN ('cancelled')
    GROUP BY o.PRODUCT_ID
)

, final AS (
    SELECT
    p.PRODUCT_ID
    , p.NAME
    , p.CATEGORY
    , p.PRICE
    , COALESCE(ps.total_units_sold, 0) AS total_units_sold
    , COALESCE(ps.total_sales_value, 0) AS total_sales_value
FROM products p
LEFT JOIN product_sales ps ON p.PRODUCT_ID = ps.PRODUCT_ID)

SELECT * FROM final
        );
      
  