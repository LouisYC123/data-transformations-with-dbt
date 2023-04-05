{% set category = ["Furniture", "Office", "Technology"] %}

WITH orders as (
    SELECT * FROM {{ ref('stg_orders') }}
)

SELECT
    order_id
    , {% for category in category %}
    SUM(CASE WHEN category = '{{category}}' THEN order_profit END) AS {{category}}_order_profit
    {% if not loop.last %}, {% endif %}
    {% endfor %}
FROM 
    orders
GROUP BY 
    order_id
ORDER BY 
    order_id