WITH final AS (
    SELECT
        pp.PRODUCT_ID
        , pp.NAME
        , pp.CATEGORY
        , pp.PRICE
        , pp.average_sale_price
        , pp.total_sales
        , pp.total_units_sold
        , pp.total_sales_value
        , pp.turnover_rate
        , pp.STOCK_LEVEL
    FROM {{ ref('int_products_performance') }} pp
)

SELECT * FROM final