{{ config(severity = 'warn') }}

with orders as (
    SELECT * FROM {{ ref('src_order') }}
)

SELECT 
    order_id
    , SUM(order_selling_price) AS total_sp
FROM 
    orders
GROUP BY
    order_id
HAVING 
    SUM(order_selling_price) < 0