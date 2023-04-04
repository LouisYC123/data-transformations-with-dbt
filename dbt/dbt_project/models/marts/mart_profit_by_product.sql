{{ config(materialized='table') }}

WITH orders as (
    SELECT * FROM {{ ref( 'stg_orders') }}
)

SELECT
    product_id
    , product_name
    , category
    , sub_category
    , sum(order_profit) AS profit 
FROM 
    orders
GROUP BY
    product_id
    , product_name
    , category
    , sub_category