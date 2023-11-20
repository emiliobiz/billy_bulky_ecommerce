WITH customers AS (
    SELECT * FROM {{ ref('staging_shopify__customers') }}
)

, orders AS (
    SELECT * FROM {{ ref('staging_shopify__orders') }}
)

, products AS (
    SELECT * FROM {{ ref('staging_shopify__products') }}
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