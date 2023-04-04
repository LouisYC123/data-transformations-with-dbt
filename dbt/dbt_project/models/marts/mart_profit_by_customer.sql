{{ config(materialized='table') }}

WITH orders as (
    SELECT * FROM {{ ref( 'stg_orders') }}
)

SELECT
    customer_id
    , segment
    , country
    , sum(order_profit) AS profit 
FROM 
    orders
GROUP BY
    customer_id
    , segment
    , country