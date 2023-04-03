{{ config(materialized='table') }}

WITH source as (
    SELECT * FROM {{ source('globalmarket', 'raw_orders_data') }}
),

staged as (
    SELECT 
        "OrderID" :: VARCHAR(5) AS order_id
        , "OrderDate" :: VARCHAR(10) AS order_date
        , "ShipDate" :: VARCHAR(10) AS ship_date
        , "ShipMode" :: VARCHAR(20) AS ship_mode
        , "CustomerID" :: VARCHAR(10) AS customer_id
        , "ProductID" :: VARCHAR(20) AS product_id
        , "OrderCostPrice" :: NUMERIC(8,2) AS order_cost_price
        , "OrderSellingPrice" :: NUMERIC(8,2) AS order_selling_price
    FROM 
        source
)

SELECT * FROM staged