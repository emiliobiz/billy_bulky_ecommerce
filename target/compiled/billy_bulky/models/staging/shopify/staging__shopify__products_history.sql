WITH products AS (
    SELECT * FROM E_COMMERCE.SNAPSHOTS.products_snapshot
)

SELECT
    PRODUCT_ID
    , NAME
    , CATEGORY
    , PRICE
    , STOCK_LEVEL
    , DBT_SCD_ID
    , DBT_UPDATED_AT
    , DBT_VALID_FROM
    , DBT_VALID_TO
FROM products