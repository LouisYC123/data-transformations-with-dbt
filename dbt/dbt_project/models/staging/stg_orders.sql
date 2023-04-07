WITH orders AS (
    SELECT * FROM {{ ref( 'src_order') }}
),

customers AS (
    SELECT * FROM {{ ref( 'src_customer') }}
),

products AS (
    SELECT * FROM {{ ref( 'src_product') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['o.order_id', 'c.customer_id', 'p.product_id'])}} AS sk_order_id
    , o.order_id
    , o.order_date
    , o.ship_date
    , o.ship_mode
    , o.order_selling_price
    , o.order_selling_price - o.order_cost_price AS order_profit
    , c.customer_id
    , c.customer_name
    , c.segment
    , c.country
    , p.product_id
    , p.category
    , p.product_name
    , p.sub_category
    , {{ markup('order_selling_price', 'order_cost_price' ) }} AS markup_pct
FROM 
    orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN products p ON o.product_id = p.product_id
    