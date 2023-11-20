WITH customers AS (
    SELECT * FROM {{ ref('staging_shopify__customers') }}
)

, orders AS (
    SELECT * FROM {{ ref('staging_shopify__orders') }}
)

, products AS (
    SELECT * FROM {{ ref('staging_shopify__products') }}
)



, enriched_orders AS (
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
    FROM orders o
    JOIN products p ON o.PRODUCT_ID = p.PRODUCT_ID
    JOIN customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
    WHERE o.STATUS NOT IN ('cancelled') 
)

, final AS (
SELECT
    e.ORDER_ID
    , e.CUSTOMER_ID
    , e.PRODUCT_ID
    , e.QUANTITY
    , e.ORDER_DATE
    , e.STATUS
    , e.CATEGORY
    , e.unit_price
    , e.total_price
    , e.COUNTRY
FROM enriched_orders e
)

SELECT * FROM final
