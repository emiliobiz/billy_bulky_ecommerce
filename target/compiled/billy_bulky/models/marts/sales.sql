WITH  __dbt__cte__int_sales_trend as (
WITH orders AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__orders
)

, products AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__products
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
), enriched_orders AS (
    SELECT
        o.ORDER_ID
        , o.CUSTOMER_ID
        , o.PRODUCT_ID
        , o.QUANTITY
        , o.ORDER_DATE
        , o.STATUS
        , p.CATEGORY
        , p.PRICE AS unit_price
        , (o.QUANTITY * p.PRICE) AS total_price
        , c.COUNTRY
    FROM E_COMMERCE.staging.staging_shopify__orders o
    JOIN E_COMMERCE.staging.staging_shopify__products p ON o.PRODUCT_ID = p.PRODUCT_ID
    JOIN E_COMMERCE.staging.staging_shopify__customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
    WHERE o.STATUS NOT IN ('cancelled') 
)

SELECT
    eo.ORDER_ID
    , eo.CUSTOMER_ID
    , eo.PRODUCT_ID
    , eo.QUANTITY
    , eo.ORDER_DATE
    , eo.STATUS
    , eo.CATEGORY
    , eo.unit_price
    , eo.total_price
    , eo.COUNTRY
    , sa.daily_orders
    , sa.daily_units_sold
    , sa.daily_sales_value
FROM enriched_orders eo
LEFT JOIN __dbt__cte__int_sales_trend sa ON DATE(eo.ORDER_DATE) = sa.sale_date