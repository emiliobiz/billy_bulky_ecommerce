
  
    

        create or replace transient table E_COMMERCE.intermediate.int_sales_trends
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

, daily_sales AS (
    SELECT
        DATE(ORDER_DATE) AS sale_date
        , COUNT(DISTINCT ORDER_ID) AS total_orders
        , SUM(QUANTITY) AS total_units_sold
        , SUM(QUANTITY * PRICE) AS total_sales_value
    FROM orders AS o
    JOIN products AS p ON o.PRODUCT_ID = p.PRODUCT_ID
    WHERE o.STATUS NOT IN ('cancelled') 
    GROUP BY sale_date
)

, weekly_sales AS (
    SELECT
        DATE_TRUNC('week', sale_date) AS sale_week
        , SUM(total_orders) AS weekly_orders
        , SUM(total_units_sold) AS weekly_units_sold
        , SUM(total_sales_value) AS weekly_sales_value
    FROM daily_sales
    GROUP BY sale_week
)

, monthly_sales AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS sale_month
        , SUM(total_orders) AS monthly_orders
        , SUM(total_units_sold) AS monthly_units_sold
        , SUM(total_sales_value) AS monthly_sales_value
    FROM daily_sales
    GROUP BY sale_month
)

, yearly_sales AS (
    SELECT
        DATE_TRUNC('year', sale_date) AS sale_year
        , SUM(total_orders) AS yearly_orders
        , SUM(total_units_sold) AS yearly_units_sold
        , SUM(total_sales_value) AS yearly_sales_value
    FROM daily_sales
    GROUP BY sale_year
)

SELECT
    d.sale_date
    , d.total_orders AS daily_orders
    , d.total_units_sold AS daily_units_sold
    , d.total_sales_value AS daily_sales_value
    , w.weekly_orders
    , w.weekly_units_sold
    , w.weekly_sales_value
    , m.monthly_orders
    , m.monthly_units_sold
    , m.monthly_sales_value
    , y.yearly_orders
    , y.yearly_units_sold
    , y.yearly_sales_value
FROM daily_sales d
LEFT JOIN weekly_sales w ON DATE_TRUNC('week', d.sale_date) = w.sale_week
LEFT JOIN monthly_sales m ON DATE_TRUNC('month', d.sale_date) = m.sale_month
LEFT JOIN yearly_sales y ON DATE_TRUNC('year', d.sale_date) = y.sale_year
        );
      
  