WITH source as (
    SELECT * FROM {{ source('globalmarket', 'raw_product_data') }}
)

SELECT 
    "Category" :: VARCHAR(10) AS category
    , "ProductID" :: VARCHAR(20) AS product_id
    , "ProductName" :: TEXT AS product_name
    , "SubCategory" :: VARCHAR(15) AS sub_category

FROM 
    source

