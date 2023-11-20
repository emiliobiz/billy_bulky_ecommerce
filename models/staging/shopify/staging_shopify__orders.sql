WITH orders AS (
    SELECT * FROM {{ source('shopify', 'orders')}}
)

SELECT
    ORDER_ID
    , CUSTOMER_ID
    , PRODUCT_ID
    , QUANTITY
    , ORDER_DATE
    , STATUS
FROM orders