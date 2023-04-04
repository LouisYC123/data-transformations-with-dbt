{{ config(materialized='table') }}

WITH source as (
    SELECT * FROM {{ source('globalmarket', 'raw_customers_data') }}
)


SELECT 
    "CustomerID" :: VARCHAR(10) AS customer_id
    , "CustomerName" :: VARCHAR(30) AS customer_name
    , "Segment" :: VARCHAR(20) AS segment
    , "Country" :: VARCHAR(20) AS country
    , "State" :: VARCHAR(20) AS state
FROM 
    source
