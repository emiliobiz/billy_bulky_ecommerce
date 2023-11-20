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