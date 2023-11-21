
    
    



with __dbt__cte__int_products_performance as (
WITH orders AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__orders
)

, products AS (
    SELECT * FROM E_COMMERCE.staging.staging_shopify__products
)

, product_sales AS (
    SELECT
        o.PRODUCT_ID
        , COUNT(DISTINCT o.ORDER_ID) AS total_sales
        , SUM(o.QUANTITY) AS total_units_sold
        , SUM(o.QUANTITY * p.PRICE) AS total_sales_value
    FROM orders o
    INNER JOIN products p ON o.PRODUCT_ID = p.PRODUCT_ID
    WHERE o.STATUS NOT IN ('cancelled') 
    GROUP BY o.PRODUCT_ID
)

, product_averages AS (
    SELECT
        PRODUCT_ID
        , (total_sales_value / NULLIF(total_units_sold, 0)) AS average_sale_price
    FROM product_sales
)

, product_stock_turnover AS (
    SELECT
        p.PRODUCT_ID
        , p.STOCK_LEVEL
        , (total_units_sold / NULLIF(p.STOCK_LEVEL, 0)) AS turnover_rate
    FROM product_sales ps
    INNER JOIN products p ON ps.PRODUCT_ID = p.PRODUCT_ID
)

, final AS (
    SELECT
    p.PRODUCT_ID
    , p.NAME
    , p.CATEGORY
    , p.PRICE
    , pa.average_sale_price
    , ps.total_sales
    , ps.total_units_sold
    , ps.total_sales_value
    , pst.turnover_rate
    , p.STOCK_LEVEL
FROM products p
LEFT JOIN product_sales ps ON p.PRODUCT_ID = ps.PRODUCT_ID
LEFT JOIN product_averages pa ON p.PRODUCT_ID = pa.PRODUCT_ID
LEFT JOIN product_stock_turnover pst ON p.PRODUCT_ID = pst.PRODUCT_ID
)

SELECT * FROM final
) select product_id
from __dbt__cte__int_products_performance
where product_id is null


