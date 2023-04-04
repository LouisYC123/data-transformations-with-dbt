{{ config(materialized='table') }}

WITH orders as (
    SELECT * FROM {{ ref( 'src_order') }}
),

customers as (
    SELECT * FROM {{ ref( 'src_customer') }}
),

products as (
    SELECT * FROM {{ ref( 'src_product') }}
)

SELECT
    o.order_id
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
FROM 
    orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN products p ON o.product_id = p.product_id
    