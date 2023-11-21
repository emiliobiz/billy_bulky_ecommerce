WITH enriched_orders AS (
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
    FROM {{ ref('staging_shopify__orders') }} o
    JOIN {{ ref('staging_shopify__products') }} p ON o.PRODUCT_ID = p.PRODUCT_ID
    JOIN {{ ref('staging_shopify__customers') }} c ON o.CUSTOMER_ID = c.CUSTOMER_ID
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
LEFT JOIN {{ ref('int_sales_trend') }} sa ON DATE(eo.ORDER_DATE) = sa.sale_date
