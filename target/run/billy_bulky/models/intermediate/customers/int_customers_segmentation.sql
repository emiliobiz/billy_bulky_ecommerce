
  
    

        create or replace transient table E_COMMERCE.intermediate.int_customers_segmentation
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

, order_aggregates AS (
    SELECT
        o.CUSTOMER_ID
        , COUNT(DISTINCT o.ORDER_ID) AS frequency
        , SUM(o.QUANTITY * p.PRICE) AS monetary
        , AVG(o.QUANTITY * p.PRICE) AS average_order_value
        , MAX(o.ORDER_DATE) AS last_purchase_date
        , COUNT(CASE WHEN o.STATUS = 'cancelled' THEN 1 END) AS cancelled_orders
        , COUNT(*) AS total_orders
    FROM orders o
    JOIN products p ON o.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY o.CUSTOMER_ID
)

, customer_tenure AS (
    SELECT
        CUSTOMER_ID
        , JOIN_DATE
        , CURRENT_DATE - JOIN_DATE AS tenure
    FROM customers
)

, customer_recency AS (
    SELECT
        CUSTOMER_ID
        , CURRENT_DATE - last_purchase_date AS recency
    FROM order_aggregates
)

, final AS (
    SELECT
        c.CUSTOMER_ID
        , c.FIRST_NAME
        , c.LAST_NAME
        , c.EMAIL
        , c.JOIN_DATE
        , c.COUNTRY
        , o.frequency
        , o.monetary
        , o.average_order_value
        , o.cancelled_orders
        , o.total_orders
        , CASE 
            WHEN o.total_orders > 0 THEN ROUND((o.cancelled_orders::FLOAT / o.total_orders) * 100, 2) 
            ELSE 0 
          END AS cancellation_rate
        , r.recency
        , t.tenure
    FROM customer_tenure t
    JOIN customers c ON t.CUSTOMER_ID = c.CUSTOMER_ID
    JOIN order_aggregates o ON c.CUSTOMER_ID = o.CUSTOMER_ID
    JOIN customer_recency r ON c.CUSTOMER_ID = r.CUSTOMER_ID
)

SELECT * FROM final
        );
      
  