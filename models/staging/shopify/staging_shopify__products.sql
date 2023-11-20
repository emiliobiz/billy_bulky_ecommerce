WITH products AS (
    SELECT * FROM {{ source('shopify', 'products')}}
)

SELECT
    PRODUCT_ID
    , NAME
    , CATEGORY
    , PRICE
    , STOCK_LEVEL
FROM products