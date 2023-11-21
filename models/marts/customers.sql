WITH source AS (
    SELECT
        icp.CUSTOMER_ID
        , icp.FIRST_NAME
        , icp.LAST_NAME
        , icp.EMAIL
        , icp.JOIN_DATE
        , icp.COUNTRY
        , icp.frequency AS total_orders
        , icp.monetary AS total_spent
        , icp.recency
        , icp.tenure
    FROM {{ ref('int_customers_segmentation') }} icp
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
    , s.recency
    , s.tenure
    , CASE 
        WHEN s.total_spent > 1000 THEN 'VIP' 
        ELSE 'Regular' 
      END AS customer_segment 
FROM source s
)

SELECT * FROM final
