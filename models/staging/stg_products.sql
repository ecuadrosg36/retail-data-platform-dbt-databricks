{{
    config(
        materialized='view',
        tags=['staging', 'products']
    )
}}

with source as (
    select * from {{ source('raw_retail', 'raw_products') }}
),

renamed as (
    select
        product_id,
        trim(product_name) as product_name,
        trim(category) as category,
        cast(price as decimal(10,2)) as price,
        current_timestamp() as _loaded_at
    from source
)

select * from renamed
